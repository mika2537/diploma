import 'package:flutter/material.dart';

class PassengerDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const PassengerDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passenger Dashboard")),
      body: Center(
        child: Text("Welcome, ${user['name'] ?? 'Passenger'}!"),
      ),
    );
  }
}