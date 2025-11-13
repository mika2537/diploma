// lib/screens/driver/driver_review_passenger_screen.dart
// Leave rating & feedback for passenger after ride

import 'package:flutter/material.dart';

class DriverReviewPassengerScreen extends StatefulWidget {
  final String passengerName;
  final String rideId;
  const DriverReviewPassengerScreen({Key? key, required this.passengerName, required this.rideId}) : super(key: key);

  @override
  State<DriverReviewPassengerScreen> createState() => _DriverReviewPassengerScreenState();
}

class _DriverReviewPassengerScreenState extends State<DriverReviewPassengerScreen> {
  int rating = 5;
  final _commentCtrl = TextEditingController();
  bool sending = false;

  Future<void> _submit() async {
    setState(() => sending = true);
    // TODO: call backend to submit rating
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => sending = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Талархал илгээв")));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Сэтгэгдэл: ${widget.passengerName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Оноо (1-5)"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final index = i + 1;
                return IconButton(
                  onPressed: () => setState(() => rating = index),
                  icon: Icon(index <= rating ? Icons.star : Icons.star_border, size: 34, color: Colors.amber),
                );
              }),
            ),
            const SizedBox(height: 12),
            TextField(controller: _commentCtrl, maxLines: 4, decoration: const InputDecoration(hintText: "Товч сэтгэгдэл (заавал биш)")),
            const Spacer(),
            sending ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text("Илгээх"))
          ],
        ),
      ),
    );
  }
}