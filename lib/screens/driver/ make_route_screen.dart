import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Replace with your MongoDB backend API
const baseUrl = "http://localhost:5050/api";

class MakeRoute extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onRouteCreated;
  final VoidCallback onBack;

  const MakeRoute({
    Key? key,
    required this.user,
    required this.onRouteCreated,
    required this.onBack,
  }) : super(key: key);

  @override
  State<MakeRoute> createState() => _MakeRouteState();
}

class _MakeRouteState extends State<MakeRoute> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _priceController = TextEditingController();
  final _seatsController = TextEditingController(text: "4");
  DateTime? _departureTime;

  List<TextEditingController> midpoints = [TextEditingController()];
  bool voiceInput = false;
  bool loading = false;
  GoogleMapController? _mapController;

  LatLng? startPoint;
  LatLng? endPoint;

  void _addMidpoint() {
    setState(() => midpoints.add(TextEditingController()));
  }

  void _toggleVoice() {
    setState(() => voiceInput = !voiceInput);
    if (voiceInput) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Дуу авах функц идэвхжлээ (прототип горим)")),
      );
    }
  }

  Future<void> _handlePublish() async {
    if (_startController.text.isEmpty ||
        _endController.text.isEmpty ||
        _departureTime == null ||
        _priceController.text.isEmpty) {
      _showAlert("Бүх шаардлагатай талбаруудыг бөглөнө үү");
      return;
    }

    setState(() => loading = true);

    try {
      final body = {
        "driverId": widget.user["id"],
        "startPoint": _startController.text,
        "endPoint": _endController.text,
        "midpoints": midpoints.map((c) => c.text).toList(),
        "departureTime": _departureTime.toString(),
        "seats": _seatsController.text,
        "pricePerSeat": _priceController.text,
        "status": "active",
      };

      final res = await http.post(
        Uri.parse("$baseUrl/routes/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        _showAlert("Маршрут амжилттай нийтлэгдлээ!");
        widget.onRouteCreated();
      } else {
        _showAlert("Маршрут үүсгэхэд алдаа гарлаа");
      }
    } catch (e) {
      debugPrint("❌ Error creating route: $e");
      _showAlert("Сервертэй холбогдоход алдаа гарлаа");
    } finally {
      setState(() => loading = false);
    }
  }

  void _showAlert(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Маршрут үүсгэх",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Map
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GoogleMap(
                      onMapCreated: (controller) => _mapController = controller,
                      initialCameraPosition: const CameraPosition(
                          target: LatLng(47.92, 106.92), zoom: 13),
                      markers: {
                        if (startPoint != null)
                          Marker(
                              markerId: const MarkerId("start"),
                              position: startPoint!,
                              infoWindow:
                              InfoWindow(title: _startController.text)),
                        if (endPoint != null)
                          Marker(
                              markerId: const MarkerId("end"),
                              position: endPoint!,
                              infoWindow:
                              InfoWindow(title: _endController.text)),
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Voice Input Toggle
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _toggleVoice,
                      icon: const Icon(Icons.mic),
                      label: const Text("Дуугаар оруулах"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: voiceInput
                            ? Colors.blueAccent
                            : Colors.grey.shade200,
                        foregroundColor:
                        voiceInput ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Start Point
                  _buildInput(
                    label: "Эхлэх цэг",
                    controller: _startController,
                    hint: "Баянзүрх дүүрэг, 3-р хороо",
                    icon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 12),

                  // Midpoints
                  Column(
                    children: [
                      for (int i = 0; i < midpoints.length; i++)
                        _buildInput(
                          label: "Дундын цэг ${i + 1}",
                          controller: midpoints[i],
                          hint: "Нэмэлт зогсоол (заавал биш)",
                          icon: Icons.place_outlined,
                        ),
                      TextButton(
                        onPressed: _addMidpoint,
                        child: const Text(
                          "+ Дундын цэг нэмэх",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  // End Point
                  _buildInput(
                    label: "Очих газар",
                    controller: _endController,
                    hint: "Сүхбаатар дүүрэг, 1-р хороо",
                    icon: Icons.flag_outlined,
                  ),

                  // Departure Time
                  _buildTimePicker(context),

                  const SizedBox(height: 8),

                  // Seats and Price
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          label: "Суудлын тоо",
                          controller: _seatsController,
                          hint: "4",
                          icon: Icons.event_seat,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInput(
                          label: "Суудлын үнэ (₮)",
                          controller: _priceController,
                          hint: "5000",
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showAlert("Загвар хадгалах функц удахгүй нэмэгдэнэ");
                          },
                          icon: const Icon(Icons.bookmark_border),
                          label: const Text("Загвар хадгалах"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading ? null : _handlePublish,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: Text(
                            loading ? "Нийтлэж байна..." : "Нийтлэх",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Хөдлөх цаг",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (date == null) return;
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                _departureTime = DateTime(date.year, date.month, date.day,
                    time.hour, time.minute);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _departureTime == null
                      ? "Огноо, цаг сонгох"
                      : _departureTime.toString().substring(0, 16),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}