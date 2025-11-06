import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Replace with your backend API (connected to MongoDB)
const baseUrl = "http://localhost:5050/api";

class ActiveRide extends StatefulWidget {
  final Map<String, dynamic> user;
  final String rideId;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const ActiveRide({
    Key? key,
    required this.user,
    required this.rideId,
    required this.onComplete,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ActiveRide> createState() => _ActiveRideState();
}

class _ActiveRideState extends State<ActiveRide> {
  Map<String, dynamic>? ride;
  double distance = 0.0;
  int elapsed = 0;
  Timer? _timer;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadRideData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() => elapsed += 5);
      _simulateGPS();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadRideData() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/rides/${widget.rideId}"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          ride = data["ride"];
          distance = (data["ride"]["distance"] ?? 0).toDouble();
        });
      }
    } catch (e) {
      debugPrint("❌ Failed to load ride: $e");
    }
  }

  void _simulateGPS() {
    setState(() => distance += 0.1);
  }

  Future<void> _handlePassengerSeated() async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/rides/${widget.rideId}/seated"),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        _showSnack("Зорчигч суусан гэж баталгаажлаа");
        _loadRideData();
      }
    } catch (e) {
      debugPrint("❌ Failed to update status: $e");
    }
  }

  Future<void> _handleDropOff() async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/rides/${widget.rideId}/complete"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "distance": distance,
          "duration": elapsed,
        }),
      );
      if (res.statusCode == 200) {
        _showSnack("Аялал амжилттай дууслаа!");
        widget.onComplete();
      }
    } catch (e) {
      debugPrint("❌ Failed to complete ride: $e");
    }
  }

  Future<void> _handleCancel() async {
    final confirm = await _showConfirm("Та энэ аяллыг цуцлахдаа итгэлтэй байна уу?");
    if (!confirm) return;

    try {
      final res = await http.put(Uri.parse("$baseUrl/rides/${widget.rideId}/cancel"));
      if (res.statusCode == 200) {
        _showSnack("Аялал цуцлагдлаа");
        widget.onBack();
      }
    } catch (e) {
      debugPrint("❌ Failed to cancel: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> _showConfirm(String msg) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Баталгаажуулах"),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Үгүй")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Тийм")),
        ],
      ),
    ) ??
        false;
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString();
    final secs = (seconds % 60).toString().padLeft(2, "0");
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    if (ride == null) {
      return const Scaffold(
        body: Center(child: Text("Уншиж байна...", style: TextStyle(color: Colors.grey))),
      );
    }

    final LatLng start = LatLng(47.92, 106.91);
    final LatLng end = LatLng(47.91, 106.93);
    final LatLng current = LatLng(47.915, 106.92);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- Map Section ---
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: CameraPosition(target: current, zoom: 14),
                    markers: {
                      Marker(
                        markerId: const MarkerId("start"),
                        position: start,
                        infoWindow: InfoWindow(title: ride!["pickupPoint"]),
                      ),
                      Marker(
                        markerId: const MarkerId("end"),
                        position: end,
                        infoWindow: InfoWindow(title: ride!["dropoffPoint"]),
                      ),
                      Marker(
                        markerId: const MarkerId("current"),
                        position: current,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                      ),
                    },
                  ),

                  // --- Trip Info Overlay ---
                  Positioned(
                    top: 20,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ride!["passengerName"] ?? "Зорчигч",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 16)),
                                  Text(
                                    ride!["vehicleModel"] ?? "Toyota Prius",
                                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                              Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (ride!["status"] == "seated"
                                      ? Colors.green
                                      : Colors.blue)
                                      .withOpacity(0.1),
                                ),
                                child: Text(
                                  ride!["status"] == "seated"
                                      ? "Зорчигч суусан"
                                      : "Очиж байна",
                                  style: TextStyle(
                                      color: ride!["status"] == "seated"
                                          ? Colors.green
                                          : Colors.blue,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _InfoBox(icon: Icons.timer, label: "Хугацаа", value: _formatTime(elapsed)),
                              _InfoBox(icon: Icons.navigation, label: "Зай", value: "${distance.toStringAsFixed(1)} км"),
                              _InfoBox(icon: Icons.attach_money, label: "Үнэ", value: "${ride!["fare"] ?? 5000}₮"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Bottom Controls ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  if (ride!["status"] != "seated")
                    ElevatedButton.icon(
                      onPressed: _handlePassengerSeated,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Зорчигч суусан"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  if (ride!["status"] == "seated")
                    ElevatedButton.icon(
                      onPressed: _handleDropOff,
                      icon: const Icon(Icons.flag_rounded),
                      label: const Text("Буулгах"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showSnack("Чат функц удахгүй нэмэгдэнэ"),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text("Чат"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleCancel,
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text("Цуцлах"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}