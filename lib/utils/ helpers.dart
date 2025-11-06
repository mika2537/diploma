import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/driver/driver_dashboard.dart';
import '../screens/driver/make_route_screen.dart';
import '../screens/driver/incoming_requests_screen.dart';
import '../screens/driver/active_ride_screen.dart';
import '../screens/passenger/passenger_dashboard.dart';
import '../screens/passenger/find_route_screen.dart';
import '../screens/passenger/ride_request_screen.dart';
import '../screens/passenger/live_trip_screen.dart';
import '../screens/passenger/payment_rating_screen.dart';
import '../screens/shared/wallet_screen.dart';
import '../screens/shared/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Driver Routes
      GoRoute(
        path: '/driver/dashboard',
        name: 'driver_dashboard',
        builder: (context, state) => const DriverDashboard(),
      ),
      GoRoute(
        path: '/driver/make-route',
        name: 'make_route',
        builder: (context, state) => const MakeRouteScreen(),
      ),
      GoRoute(
        path: '/driver/requests',
        name: 'incoming_requests',
        builder: (context, state) => const IncomingRequestsScreen(),
      ),
      GoRoute(
        path: '/driver/active-ride/:rideId',
        name: 'active_ride',
        builder: (context, state) {
          final rideId = state.pathParameters['rideId']!;
          return ActiveRideScreen(rideId: rideId);
        },
      ),

      // Passenger Routes
      GoRoute(
        path: '/passenger/dashboard',
        name: 'passenger_dashboard',
        builder: (context, state) => const PassengerDashboard(),
      ),
      GoRoute(
        path: '/passenger/find-route',
        name: 'find_route',
        builder: (context, state) => const FindRouteScreen(),
      ),
      GoRoute(
        path: '/passenger/ride-request',
        name: 'ride_request',
        builder: (context, state) {
          final route = state.extra as Map<String, dynamic>;
          return RideRequestScreen(route: route);
        },
      ),
      GoRoute(
        path: '/passenger/live-trip/:rideId',
        name: 'live_trip',
        builder: (context, state) {
          final rideId = state.pathParameters['rideId']!;
          return LiveTripScreen(rideId: rideId);
        },
      ),
      GoRoute(
        path: '/passenger/payment-rating/:rideId',
        name: 'payment_rating',
        builder: (context, state) {
          final rideId = state.pathParameters['rideId']!;
          return PaymentRatingScreen(rideId: rideId);
        },
      ),

      // Shared Routes
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}