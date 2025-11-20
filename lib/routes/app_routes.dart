import 'package:flutter/material.dart';
import 'package:ubcarpool/presentation/driver_register/driver_register.dart';
import '../presentation/driver_wallet/driver_wallet.dart';
import '../presentation/create_route/create_route.dart';
import '../presentation/request_details/request_details.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/driver_dashboard/driver_dashboard.dart';
import '../presentation/incoming_requests/incoming_requests.dart';
import '../presentation/driver_login/driver_login.dart';
import '../presentation/saved_route/saved_route.dart';
import '../presentation/edit_route/edit_route.dart';
import '../presentation/saved_route/models/saved_route_model.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/forgot_password/forgot_password.dart';

class AppRoutes {
  static const String initial = '/';
  static const String createRoute = '/create-route';
  static const String requestDetails = '/request-details';
  static const String splash = '/splash-screen';
  static const String driverDashboard = '/driver-dashboard';
  static const String incomingRequests = '/incoming-requests';
  static const String driverLogin = '/driver-login';
  static const String driverWallet = '/driver-wallet';
  static const String savedRoute = '/saved-route';
  static const String editRoute = '/edit-route';
  static const String profileScreen = '/profile';
  static const String forgotPassword = '/forgot_password';
  static const String driverRegister = '/driver_register';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DriverDashboard(),
    createRoute: (context) => const CreateRoute(),
    requestDetails: (context) => const RequestDetails(),
    splash: (context) => const SplashScreen(),
    driverDashboard: (context) => const DriverDashboard(),
    incomingRequests: (context) => const IncomingRequests(),
    driverLogin: (context) => const DriverLogin(),
    driverWallet: (context) => const DriverWalletScreen(),
    savedRoute: (context) => const SavedRouteScreen(),

    editRoute: (context) => EditRoute(
      route: ModalRoute.of(context)!.settings.arguments as SavedRouteModel,
    ),

    profileScreen: (context) => const ProfileScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    driverRegister: (context) => const DriverRegisterScreen(),
  };
}