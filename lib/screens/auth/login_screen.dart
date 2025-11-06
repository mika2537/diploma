import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Your backend API base (Node.js + MongoDB)
const String apiBaseUrl = "http://10.0.2.2:5050/api";

class LoginScreen extends StatefulWidget {
  final Function(Map<String, dynamic> user, String role) onLogin;
  final VoidCallback onSwitchToRegister;

  const LoginScreen({
    Key? key,
    required this.onLogin,
    required this.onSwitchToRegister,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String role = "passenger";
  bool loading = false;
  String error = "";

  Future<void> handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => error = "Бүх талбарыг бөглөнө үү");
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });

    try {
      final res = await http.post(
        Uri.parse("$apiBaseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password, "role": role}),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        setState(() => error = data["error"] ?? "Нэвтрэхэд алдаа гарлаа");
        setState(() => loading = false);
        return;
      }

      // ✅ Save user data & token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      await prefs.setString("user", jsonEncode(data["user"]));

      widget.onLogin(Map<String, dynamic>.from(data["user"]), role);
    } catch (e) {
      setState(() => error = "Сүлжээний алдаа: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Logo ---
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_car_rounded,
                        color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "UB Carpool",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 8),
                  const Text("Нэвтрэх",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 24),

                  // --- Role Selector ---
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => role = "passenger"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: role == "passenger"
                                  ? Colors.blueAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: role == "passenger"
                                      ? Colors.blueAccent
                                      : Colors.grey.shade300),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Зорчигч",
                              style: TextStyle(
                                color: role == "passenger"
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => role = "driver"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: role == "driver"
                                  ? Colors.blueAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: role == "driver"
                                      ? Colors.blueAccent
                                      : Colors.grey.shade300),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Жолооч",
                              style: TextStyle(
                                color: role == "driver"
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Email Input ---
                  _buildInputField(
                    label: "Цахим шуудан",
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hint: "example@email.com",
                  ),
                  const SizedBox(height: 16),

                  // --- Password Input ---
                  _buildInputField(
                    label: "Нууц үг",
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    hint: "••••••••",
                    obscure: true,
                  ),
                  const SizedBox(height: 12),

                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  // --- Login Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        loading ? "Уншиж байна..." : "Нэвтрэх",
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- Biometric login (placeholder) ---
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Биометрик нэвтрэх удахгүй нэмэгдэнэ")),
                      );
                    },
                    icon: const Icon(Icons.fingerprint, color: Colors.blueAccent),
                    label: const Text("Биометрик нэвтрэх",
                        style: TextStyle(color: Colors.blueAccent)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Switch to Register ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Бүртгэлгүй юу?",
                          style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: widget.onSwitchToRegister,
                        child: const Text(
                          "Бүртгүүлэх",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}