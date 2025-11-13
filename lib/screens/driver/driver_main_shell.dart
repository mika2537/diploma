// lib/screens/driver/driver_main_shell.dart

import 'package:flutter/material.dart';
import 'package:ubcarpool/screens/driver/driver_dashboard.dart';
import 'package:ubcarpool/screens/driver/incoming_requests_screen.dart';
import 'package:ubcarpool/screens/driver/manage_trip_screen.dart';
import 'package:ubcarpool/screens/shared/profile_screen.dart';

class DriverMainShell extends StatefulWidget {
  final Map<String, dynamic> user;

  const DriverMainShell({super.key, required this.user});

  @override
  State<DriverMainShell> createState() => _DriverMainShellState();
}

class _DriverMainShellState extends State<DriverMainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DriverDashboard(
        user: widget.user,
        onViewRequests: () => setState(() => index = 1),
        onMakeRoute: () => setState(() => index = 2),
      ),
      IncomingRequests(
        user: widget.user,
        onBack: () => setState(() => index = 0),
      ),
      ManageTripScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];

    final items = const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Нүүр',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Хүсэлт',
      ),
      NavigationDestination(
        icon: Icon(Icons.route_outlined),
        selectedIcon: Icon(Icons.route),
        label: 'Маршрут',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Профайл',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),

      // --- Footer Navigation ---
      bottomNavigationBar: NavigationBar(
        height: 65,
        destinations: items,
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() => index = i);
        },
      ),
    );
  }
}