import 'package:flutter/material.dart';
import '../presentation/create_route/create_route.dart';
import '../presentation/request_details/request_details.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/driver_dashboard/driver_dashboard.dart';
import '../presentation/incoming_requests/incoming_requests.dart';
import '../presentation/driver_login/driver_login.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String createRoute = '/create-route';
  static const String requestDetails = '/request-details';
  static const String splash = '/splash-screen';
  static const String driverDashboard = '/driver-dashboard';
  static const String incomingRequests = '/incoming-requests';
  static const String driverLogin = '/driver-login';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DriverDashboard(),
    createRoute: (context) => const CreateRoute(),
    requestDetails: (context) => const RequestDetails(),
    splash: (context) => const SplashScreen(),
    driverDashboard: (context) => const DriverDashboard(),
    incomingRequests: (context) => const IncomingRequests(),
    driverLogin: (context) => const DriverLogin(),
    // TODO: Add your other routes here
  };
}
