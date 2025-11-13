// ignore_for_file: use_super_parameters

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverNavigationMapScreen extends StatefulWidget {
  final LatLng pickup;
  final LatLng dropoff;
  final VoidCallback onBack;

  const DriverNavigationMapScreen({
    Key? key,
    required this.pickup,
    required this.dropoff,
    required this.onBack,
  }) : super(key: key);

  @override
  State<DriverNavigationMapScreen> createState() =>
      _DriverNavigationMapScreenState();
}

class _DriverNavigationMapScreenState extends State<DriverNavigationMapScreen> {
  GoogleMapController? _controller;
  LatLng? currentPosition;
  Timer? _simTimer;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.pickup;

    // Fake movement simulation
    _simTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        currentPosition =
            LatLng(currentPosition!.latitude - 0.0001, currentPosition!.longitude + 0.0001);
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _simTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickup,
                zoom: 14,
              ),
              onMapCreated: (c) => _controller = c,
              markers: {
                Marker(
                  markerId: const MarkerId("pickup"),
                  position: widget.pickup,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  infoWindow: const InfoWindow(title: "Авах цэг"),
                ),
                Marker(
                  markerId: const MarkerId("dropoff"),
                  position: widget.dropoff,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: const InfoWindow(title: "Буух цэг"),
                ),
                if (currentPosition != null)
                  Marker(
                    markerId: const MarkerId("driver"),
                    position: currentPosition!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                    infoWindow: const InfoWindow(title: "Таны байршил"),
                  ),
              },
            ),

            // Header
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Замаар чиглүүлэх",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom action
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flag),
                label: const Text("Аялал дуусгах"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}