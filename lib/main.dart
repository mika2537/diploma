import 'package:flutter/material.dart';
import 'package:ubcarpool/screens/auth/login_screen.dart';
import 'package:ubcarpool/screens/auth/register_screen.dart';
import 'package:ubcarpool/screens/driver/driver_main_shell.dart';
import 'package:ubcarpool/screens/passenger/passenger_dashboard.dart';
import 'package:ubcarpool/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final user = await StorageService.getUser();
  runApp(MyApp(initialUser: user));
}

class MyApp extends StatefulWidget {
  final Map<String, dynamic>? initialUser;
  const MyApp({super.key, this.initialUser});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? currentUser;
  String? role;

  @override
  void initState() {
    super.initState();
    currentUser = widget.initialUser;
    if (currentUser != null) {
      role = currentUser!["role"];
    }
  }

  void handleLogin(Map<String, dynamic> user, String newRole) async {
    await StorageService.saveUser(user);
    setState(() {
      currentUser = user;
      role = newRole;
    });
  }

  void handleLogout() async {
    await StorageService.clear();
    setState(() {
      currentUser = null;
      role = null;
    });
  }

  void handleSwitchToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          onRegister: handleLogin,
          onSwitchToLogin: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget homeScreen = const SizedBox();

    if (currentUser == null) {
      /// LOGIN
      homeScreen = LoginScreen(
        onLogin: handleLogin,
        onSwitchToRegister: handleSwitchToRegister,
      );

    } else if (role == "driver") {
      /// DRIVER → FOOTER NAVIGATION (Shell)
      homeScreen = DriverMainShell(
        user: currentUser!,
      );

    } else if (role == "passenger") {
      /// PASSENGER
      homeScreen = PassengerDashboard(
        user: currentUser!,
        onFindRoute: () {
          print("Маршрут хайх товч дарлаа!");
        },
      );
    }

    return MaterialApp(
      title: "UB Carpool",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: homeScreen,
    );
  }
}