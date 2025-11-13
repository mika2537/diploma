// ignore_for_file: avoid_print, use_super_parameters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class FindRouteScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const FindRouteScreen({required this.user});

  @override
  State<FindRouteScreen> createState() => _FindRouteScreenState();
}

class _FindRouteScreenState extends State<FindRouteScreen> {
  LatLng? _currentLocation;
  LatLng? _destination;
  bool _loading = false;
  String? _mapError;
  List<Map<String, dynamic>> foundRoutes = [];

  static const _defaultLatLng = LatLng(47.9191, 106.9170);
  final TextEditingController _destinationCtrl = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentLocation = _defaultLatLng;
          _mapError = "Location service is disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = _defaultLatLng;
          _mapError = "Location permission denied.";
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
      });
    } catch (e) {
      setState(() => _mapError = "Failed to get location: $e");
    }
  }

  Future<void> _searchRoutes() async {
    if (_destinationCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Очих цэгийг оруулна уу.")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final uri = Uri.parse(
          "http://10.0.2.2:5050/api/routes/search?query=${_destinationCtrl.text}");
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          foundRoutes = List<Map<String, dynamic>>.from(data);
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        print("Server error: ${res.statusCode}");
      }
    } catch (e) {
      setState(() => _loading = false);
      print("❌ Failed to search routes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Маршрут хайх"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _destinationCtrl,
                    decoration: InputDecoration(
                      hintText: "Очих газар",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _searchRoutes,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text("Хайх"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (_currentLocation != null)
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: _currentLocation!, zoom: 13.5),
                    myLocationEnabled: true,
                    markers: {
                      Marker(
                        markerId: const MarkerId("start"),
                        position: _currentLocation!,
                        infoWindow: const InfoWindow(title: "Таны байршил"),
                      ),
                      if (_destination != null)
                        Marker(
                          markerId: const MarkerId("destination"),
                          position: _destination!,
                          infoWindow: const InfoWindow(title: "Очих газар"),
                        ),
                    },
                    onTap: (LatLng pos) {
                      setState(() => _destination = pos);
                    },
                    onMapCreated: (controller) => _mapController = controller,
                  )
                else if (_mapError != null)
                  Center(child: Text("❌ $_mapError")),
                if (_loading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          if (foundRoutes.isNotEmpty)
            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView.builder(
                itemCount: foundRoutes.length,
                itemBuilder: (context, index) {
                  final r = foundRoutes[index];
                  return ListTile(
                    leading: const Icon(Icons.directions_car_rounded),
                    title: Text("${r['startPoint']} → ${r['endPoint']}"),
                    subtitle: Text(
                        "Үнэ: ${r['price']}₮ | Суудал: ${r['seatsLeft']}"),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Маршрут сонгогдлоо: ${r['startPoint']} → ${r['endPoint']}"),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}