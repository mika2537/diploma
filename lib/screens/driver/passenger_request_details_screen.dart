// lib/screens/driver/passenger_request_details_screen.dart
// View details for a single incoming passenger request

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://10.0.2.2:5050/api";

class PassengerRequestDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> request;
  final Map<String, dynamic> user;

  const PassengerRequestDetailsScreen({Key? key, required this.request, required this.user}) : super(key: key);

  @override
  State<PassengerRequestDetailsScreen> createState() => _PassengerRequestDetailsScreenState();
}

class _PassengerRequestDetailsScreenState extends State<PassengerRequestDetailsScreen> {
  bool loading = false;

  Future<void> _respond(String action) async {
    setState(() => loading = true);
    try {
      final url = "$baseUrl/rides/${widget.request['_id']}/${action}";
      final res = await http.put(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'driverId': widget.user['id']}));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(action == 'accept' ? "Зөвшөөрлөө" : "Татгалзав")));
        Navigator.pop(context, action);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Алдаа гарлаа")));
      }
    } catch (e) {
      debugPrint("Respond error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    return Scaffold(
      appBar: AppBar(title: const Text("Хүсэлтийн дэлгэрэнгүй")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['passengerName'] ?? 'Зорчигч', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(r['passengerPhone'] ?? '', style: const TextStyle(color: Colors.grey)),
              ])
            ]),
            const SizedBox(height: 16),
            Text("Авах цэг", style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 6),
            Text(r['pickupPoint'] ?? '-'),
            const SizedBox(height: 12),
            Text("Буух цэг", style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 6),
            Text(r['dropoffPoint'] ?? '-'),
            const SizedBox(height: 12),
            Text("Суудал", style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 6),
            Text("${r['seats'] ?? 1}"),
            const Spacer(),
            if (loading) const Center(child: CircularProgressIndicator()) else Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => _respond('reject'), child: const Text("Татгалзах"))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: () => _respond('accept'), child: const Text("Зөвшөөрөх"))),
              ],
            )
          ],
        ),
      ),
    );
  }
}