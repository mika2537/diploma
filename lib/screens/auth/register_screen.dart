import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ✅ Your backend API
const String apiBaseUrl = "http://localhost:5050/api";

class RegisterScreen extends StatefulWidget {
  final Function(Map<String, dynamic> user, String role) onRegister;
  final VoidCallback onSwitchToLogin;

  const RegisterScreen({
    Key? key,
    required this.onRegister,
    required this.onSwitchToLogin,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _vehicleModel = TextEditingController();
  final _vehiclePlate = TextEditingController();
  final _licenseNumber = TextEditingController();

  String role = "passenger";
  bool loading = false;
  String error = "";

  Future<void> handleRegister() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    final password = _password.text.trim();
    final confirmPassword = _confirmPassword.text.trim();

    if (password != confirmPassword) {
      setState(() => error = "Нууц үг таарахгүй байна");
      return;
    }
    if (password.length < 6) {
      setState(() => error = "Нууц үг 6-аас дээш тэмдэгт байх ёстой");
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });

    try {
      final body = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "role": role,
        "vehicleModel": _vehicleModel.text.trim(),
        "vehiclePlate": _vehiclePlate.text.trim(),
        "licenseNumber": _licenseNumber.text.trim(),
      };

      final res = await http.post(
        Uri.parse("$apiBaseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        widget.onRegister(Map<String, dynamic>.from(data["user"]), role);
      } else {
        setState(() => error = data["error"] ?? "Бүртгэл амжилтгүй боллоо");
      }
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
                children: [
                  // --- Logo ---
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_car_rounded,
                        color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "UB Carpool",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const Text("Бүртгүүлэх",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  // --- Form Container ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField("Нэр", _name),
                        _buildTextField("Цахим шуудан", _email,
                            type: TextInputType.emailAddress),
                        _buildTextField("Утасны дугаар", _phone,
                            type: TextInputType.phone),

                        const SizedBox(height: 8),
                        // --- Role Selector ---
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => role = "passenger"),
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: role == "passenger"
                                        ? Colors.blueAccent
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: role == "passenger"
                                            ? Colors.blueAccent
                                            : Colors.grey.shade300),
                                  ),
                                  child: Text("Зорчигч",
                                      style: TextStyle(
                                        color: role == "passenger"
                                            ? Colors.white
                                            : Colors.black87,
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => role = "driver"),
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: role == "driver"
                                        ? Colors.blueAccent
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: role == "driver"
                                            ? Colors.blueAccent
                                            : Colors.grey.shade300),
                                  ),
                                  child: Text("Жолооч",
                                      style: TextStyle(
                                        color: role == "driver"
                                            ? Colors.white
                                            : Colors.black87,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // --- Driver-specific fields ---
                        if (role == "driver") ...[
                          const SizedBox(height: 12),
                          _buildTextField("Машины марк", _vehicleModel),
                          _buildTextField("Улсын дугаар", _vehiclePlate),
                          _buildTextField("Жолоочийн үнэмлэх", _licenseNumber),
                        ],

                        _buildTextField("Нууц үг", _password, obscure: true),
                        _buildTextField("Нууц үг давтах", _confirmPassword,
                            obscure: true),

                        if (error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // --- Register Button ---
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              loading ? "Бүртгэж байна..." : "Бүртгүүлэх",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // --- Switch to Login ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Бүртгэлтэй юу?",
                                style: TextStyle(color: Colors.grey)),
                            TextButton(
                              onPressed: widget.onSwitchToLogin,
                              child: const Text(
                                "Нэвтрэх",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? type, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: type,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}