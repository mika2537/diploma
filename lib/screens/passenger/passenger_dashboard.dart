// ignore_for_file: use_super_parameters, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ubcarpool/screens/shared/profile_screen.dart';
import 'package:ubcarpool/screens/passenger/find_route_screen.dart';

class PassengerDashboard extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onFindRoute;

  const PassengerDashboard({
    required this.user,
    required this.onFindRoute,
  });

  @override
  State<PassengerDashboard> createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard> {
  LatLng? _location;
  bool _loadingMap = true;
  String? _mapError;
  GoogleMapController? _mapController;

  static const _defaultLatLng = LatLng(47.9191, 106.9170);

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
          _location = _defaultLatLng;
          _mapError = 'Location services disabled';
          _loadingMap = false;
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
          _location = _defaultLatLng;
          _mapError = 'Permission denied';
          _loadingMap = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _location = LatLng(pos.latitude, pos.longitude);
        _loadingMap = false;
      });
    } catch (e) {
      setState(() {
        _location = _defaultLatLng;
        _mapError = 'Failed to get location';
        _loadingMap = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.user["name"] ?? "User";

    return Scaffold(
      body: Stack(
        children: [
          // --- Google Map Background ---
          if (_location != null)
            GoogleMap(
              initialCameraPosition:
              CameraPosition(target: _location!, zoom: 15),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => _mapController = controller,
            )
          else if (_loadingMap)
            const Center(child: CircularProgressIndicator())
          else
            Center(child: Text("❌ $_mapError")),

          // --- Profile Avatar (top-left) ---
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: widget.user)),
                );
              },
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: const Icon(Icons.person, color: Colors.black, size: 30),
              ),
            ),
          ),

          // --- Search and Actions (top-right) ---
          Positioned(
            top: 50,
            right: 20,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.search_rounded,
                      color: Colors.black87, size: 26),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 26),
                ),
              ],
            ),
          ),

          // --- Bottom Card (Where to?) ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Where to?",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onFindRoute,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text("New Trip",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => print("Home tapped"),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.home_rounded, size: 20),
                                SizedBox(width: 8),
                                Text("Home"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => print("Work tapped"),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.work_outline_rounded, size: 20),
                                SizedBox(width: 8),
                                Text("Work"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // --- Center Location Button ---
          Positioned(
            bottom: 130,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (_location != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _location!, zoom: 15),
                    ),
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}