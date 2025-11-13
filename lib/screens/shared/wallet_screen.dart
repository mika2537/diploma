// ignore_for_file: use_super_parameters, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final String role; // "driver" or "passenger"

  const WalletScreen({required this.user, required this.role});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double balance = 0;
  List<Map<String, dynamic>> transactions = [];
  bool loading = false;
  bool showAddMoney = false;
  bool showWithdraw = false;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    try {
      setState(() => loading = true);

      final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:5050/api/wallet?userId=${widget.user['id']}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          balance = (data['balance'] ?? 0).toDouble();
          transactions =
          List<Map<String, dynamic>>.from(data['transactions'] ?? []);
        });
      } else {
        print("⚠️ Failed to load wallet: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error loading wallet: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> handleAddMoney() async {
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5050/api/wallet/add"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": widget.user["id"],
          "amount": amount,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        amountController.clear();
        loadWalletData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Мөнгө амжилттай нэмэгдлээ")),
        );
      }
    } catch (e) {
      print("❌ Failed to add money: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> handleWithdraw() async {
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0 || amount > balance) return;

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5050/api/wallet/withdraw"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": widget.user["id"],
          "amount": amount,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        amountController.clear();
        loadWalletData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Мөнгө амжилттай татагдлаа")),
        );
      }
    } catch (e) {
      print("❌ Failed to withdraw: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void openModal({required bool add}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(add ? "Мөнгө нэмэх" : "Мөнгө татах",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "₮ Дүн оруулах",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        amountController.clear();
                      },
                      child: const Text("Цуцлах"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: add ? handleAddMoney : handleWithdraw,
                      child: Text(add ? "Нэмэх" : "Татах"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text("Хэтэвч",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Balance Card ---
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C8EFF), Color(0xFF357AFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Нийт үлдэгдэл",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text("${balance.toStringAsFixed(0)}₮",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => openModal(add: true),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text("Нэмэх",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (widget.role == "driver")
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => openModal(add: false),
                            icon: const Icon(Icons.arrow_upward,
                                color: Colors.white),
                            label: const Text("Татах",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Transaction History ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Гүйлгээний түүх",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 10),

            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                    child: Text("Гүйлгээ олдсонгүй",
                        style: TextStyle(color: Colors.grey))),
              )
            else
              Column(
                children: transactions.map((tx) {
                  final isIncoming =
                      tx["type"] == "add" || tx["type"] == "incoming";
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            backgroundColor: isIncoming
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            child: Icon(
                              isIncoming
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncoming
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tx["description"] ?? "Гүйлгээ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text(tx["date"] ?? "Өнөөдөр",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          )
                        ]),
                        Text(
                          "${isIncoming ? "+" : "-"}${tx["amount"]}₮",
                          style: TextStyle(
                            color: isIncoming
                                ? Colors.green
                                : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}