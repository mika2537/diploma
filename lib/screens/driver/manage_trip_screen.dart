// lib/screens/driver/manage_trip_screen.dart
// Manage (list / edit / cancel) driver's routes/trips

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://10.0.2.2:5050/api"; // change as needed

class ManageTripScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ManageTripScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ManageTripScreen> createState() => _ManageTripScreenState();
}

class _ManageTripScreenState extends State<ManageTripScreen> {
  bool loading = true;
  List<Map<String, dynamic>> trips = [];

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() => loading = true);
    try {
      final uri = Uri.parse("$baseUrl/driver/${widget.user['id']}/routes");
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        setState(() => trips = List<Map<String, dynamic>>.from(body['routes'] ?? []));
      }
    } catch (e) {
      debugPrint("Failed load trips: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _cancelRoute(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Цуцлах"),
        content: const Text("Энэхүү маршрутыг цуцлах уу?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Үгүй")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Тийм")),
        ],
      ),
    ) ??
        false;
    if (!ok) return;

    try {
      final res = await http.put(Uri.parse("$baseUrl/routes/$id/cancel"));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Цуцлагдлаа")));
        _loadTrips();
      }
    } catch (e) {
      debugPrint("Cancel error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Миний маршрутууд")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : trips.isEmpty
          ? const Center(child: Text("Одоогоор маршрут байхгүй"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: trips.length,
        itemBuilder: (ctx, i) {
          final t = trips[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text("${t['startPoint']} → ${t['endPoint']}"),
              subtitle: Text("Хөдлөх: ${t['departureTime']?.toString()?.substring(0, 16) ?? '-'}"),
              trailing: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'cancel') _cancelRoute(t['_id']);
                },
                itemBuilder: (c) => [
                  const PopupMenuItem(value: 'cancel', child: Text('Цуцлах')),
                ],
              ),
              onTap: () {
                // open details or edit
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/driver/make-route'),
        icon: const Icon(Icons.add),
        label: const Text("Шинэ маршрут"),
      ),
    );
  }
}