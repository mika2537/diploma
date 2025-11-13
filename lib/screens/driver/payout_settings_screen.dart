// lib/screens/driver/payout_settings_screen.dart
// Payout setup (bank account / mobile wallet)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://10.0.2.2:5050/api";

class PayoutSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const PayoutSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<PayoutSettingsScreen> createState() => _PayoutSettingsScreenState();
}

class _PayoutSettingsScreenState extends State<PayoutSettingsScreen> {
  final _accCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    // optionally load existing payout
  }

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      final res = await http.put(Uri.parse("$baseUrl/driver/${widget.user['id']}/payout"), headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'account': _accCtrl.text,
        'bank': _bankCtrl.text,
      }));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Хадгалагдлаа")));
      }
    } catch (e) {
      debugPrint("Payout save: $e");
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Шилжүүлэх тохиргоо")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _bankCtrl, decoration: const InputDecoration(labelText: "Банк/Wallet нэр")),
            const SizedBox(height: 12),
            TextField(controller: _accCtrl, decoration: const InputDecoration(labelText: "Данс/Дугаар")),
            const SizedBox(height: 20),
            saving ? const CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: const Text("Хадгалах"))
          ],
        ),
      ),
    );
  }
}