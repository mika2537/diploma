// lib/screens/driver/earnings_dashboard_screen.dart
// Simple earnings UI with stats and transaction list

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://10.0.2.2:5050/api";

class EarningsDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const EarningsDashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EarningsDashboardScreen> createState() => _EarningsDashboardScreenState();
}

class _EarningsDashboardScreenState extends State<EarningsDashboardScreen> {
  bool loading = true;
  int balance = 0;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse("$baseUrl/driver/${widget.user['id']}/earnings"));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        setState(() {
          balance = body['balance'] ?? 0;
          transactions = List<Map<String, dynamic>>.from(body['transactions'] ?? []);
        });
      }
    } catch (e) {
      debugPrint("Earnings load: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Орлого")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadEarnings,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Нийт баланс", style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text("$balance ₮", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/driver/payout'), child: const Text("Шилжүүлэг хүсэх")),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Гүйлгээний түүх", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...transactions.map((t) {
              return ListTile(
                title: Text(t['title'] ?? 'Гүйлгээ'),
                subtitle: Text(t['date'] ?? ''),
                trailing: Text("${t['amount'] ?? 0} ₮", style: const TextStyle(color: Colors.green)),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}