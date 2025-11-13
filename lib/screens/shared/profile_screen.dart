// ignore_for_file: use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubcarpool/screens/auth/login_screen.dart'; // ✅ import your LoginScreen
import 'package:ubcarpool/screens/driver/driver_dashboard.dart';
import 'package:ubcarpool/screens/passenger/passenger_dashboard.dart';
class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onLogout;

  const ProfileScreen({
    Key? key,
    required this.user,
    this.onLogout,
  }) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove stored token & user

    // ✅ Use direct navigation — no named routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLogin: (user, role) async {
            // ✅ Save user to storage
            final storage = await SharedPreferences.getInstance();
            await storage.setString('user', user.toString());
            await storage.setString('role', role);

            // ✅ Navigate back into the app
            if (role == "driver") {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => DriverDashboard(
                    user: user,
                    onViewRequests: () {}, onMakeRoute: () {  },
                  ),
                ),
                    (route) => false,
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => PassengerDashboard(user: user, onFindRoute: () {  },),
                ),
                    (route) => false,
              );
            }
          },
          onSwitchToRegister: () {},
        ),
      ),
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Амжилттай гарлаа')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = user['name'] ?? 'Тодорхойгүй хэрэглэгч';
    final email = user['email'] ?? 'И-мэйл байхгүй';
    final phone = user['phone'] ?? 'Утасны дугаар байхгүй';
    final carModel = user['carModel'] ?? 'Машины мэдээлэл байхгүй';
    final totalIncome = user['totalIncome'] ?? 0;
    final rating = user['rating'] ?? 4.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профайл'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Гарах',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Profile Avatar ---
            CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // --- Profile Info Cards ---
            _ProfileInfoCard(
              icon: Icons.phone_rounded,
              label: 'Утасны дугаар',
              value: phone,
            ),
            const SizedBox(height: 12),
            _ProfileInfoCard(
              icon: Icons.directions_car_rounded,
              label: 'Машины загвар',
              value: carModel,
            ),
            const SizedBox(height: 12),
            _ProfileInfoCard(
              icon: Icons.monetization_on_rounded,
              label: 'Нийт орлого',
              value: '${_thousand(totalIncome)} ₮',
            ),
            const SizedBox(height: 12),
            _ProfileInfoCard(
              icon: Icons.star_rate_rounded,
              label: 'Жолоочийн үнэлгээ',
              value: '$rating / 5.0',
            ),

            const SizedBox(height: 30),

            // --- Edit Profile Button ---
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Профайл засах хэсэг удахгүй нэмэгдэнэ')),
                );
              },
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Профайл засах'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Profile Info Card ---
class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryContainer;
    final textColor = Theme.of(context).colorScheme.onSecondaryContainer;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Helper Function ---
String _thousand(num n) {
  return n.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
  );
}