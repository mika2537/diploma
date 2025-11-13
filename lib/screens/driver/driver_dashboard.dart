// ignore_for_file: use_super_parameters, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ubcarpool/screens/driver/make_route_screen.dart';
import 'package:ubcarpool/screens/shared/profile_screen.dart';

class DriverDashboard extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onViewRequests;

  const DriverDashboard({
    Key? key,
    required this.user,
    this.onViewRequests, required Null Function() onMakeRoute,
  }) : super(key: key);

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int todayRides = 0;
  int todayIncome = 1000;
  int activeRides = 2;
  int totalIncome = 100000;

  List<_NotificationItem> notifications = [];
  LatLng? location;
  String? mapError;
  bool loadingMap = true;
  bool loadingData = true;

  static const _ubDefault = LatLng(47.9191, 106.9170);

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _initLocation();
  }

  Future<void> _loadDashboardData() async {
    try {
      final userId = widget.user['id'];
      final uri = Uri.parse(
          'http://10.0.2.2:5050/api/driver/dashboard?userId=$userId'); // ✅ Android emulator-safe

      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final stats = (body['stats'] as Map?) ?? {};
        final notif = (body['notifications'] as List?) ?? [];

        setState(() {
          todayRides = (stats['todayRides'] ?? 0) as int;
          todayIncome = (stats['todayIncome'] ?? 0) as int;
          activeRides = (stats['activeRides'] ?? 0) as int;
          totalIncome = (stats['totalIncome'] ?? 0) as int;
          notifications = notif
              .map((e) => _NotificationItem(
            message: (e['message'] ?? '').toString(),
            time: (e['time'] ?? '').toString(),
          ))
              .toList()
              .cast<_NotificationItem>();
          loadingData = false;
        });
      } else {
        setState(() {
          loadingData = false;
        });
      }
    } catch (e) {
      setState(() => loadingData = false);
      print('Failed to load dashboard: $e');
    }
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = _ubDefault;
          loadingMap = false;
          mapError = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          location = _ubDefault;
          loadingMap = false;
          mapError = 'Location permission denied. Using default location.';
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        location = LatLng(pos.latitude, pos.longitude);
        loadingMap = false;
      });
    } catch (e) {
      setState(() {
        location = _ubDefault;
        loadingMap = false;
        mapError = 'Failed to get location. Using default location.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = (widget.user['name'] ?? '').toString();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Сайн байна уу,',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      _ProfileButton(user: widget.user),
                    ],
                  ),
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 16),

                  // Stats
                  _StatsGrid(
                    todayRides: todayRides,
                    todayIncome: todayIncome,
                    activeRides: activeRides,
                    totalIncome: totalIncome,
                    loading: loadingData,
                  ),

                  const SizedBox(height: 16),

                  // Map
                  const Text('Таны байршил',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    height: 192,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.6)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        if (location != null)
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: location!,
                              zoom: 14,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: true,
                            mapToolbarEnabled: false,
                            markers: {
                              Marker(
                                markerId: const MarkerId('me'),
                                position: location!,
                              )
                            },
                          ),
                        if (loadingMap)
                          const Center(
                              child: Text('Газрын зураг ачаалж байна...',
                                  style: TextStyle(fontSize: 13))),
                        if (!loadingMap && mapError != null)
                          Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '❌ Газрын зураг ачаалагдсангүй: $mapError',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick Actions
                  Column(
                    children: [
                      _PrimaryButton(
                        label: 'Маршрут үүсгэх',
                        icon: Icons.directions_car_filled_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MakeRouteScreen(user: widget.user),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _OutlinedButtonWithSub(
                        label: 'Хүсэлтүүд үзэх',
                        sublabel: '${notifications.length} шинэ хүсэлт',
                        icon: Icons.notifications_none_rounded,
                        onPressed: widget.onViewRequests ?? () {},
                      ),
                    ],
                  ),

                  if (notifications.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Сүүлийн мэдэгдлүүд',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Column(
                      children: notifications.take(3).map((n) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withValues(alpha: 0.6)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(
                                    top: 6, right: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(n.message,
                                        style:
                                        const TextStyle(fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(
                                      n.time,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Small UI pieces ---
class _ProfileButton extends StatelessWidget {
  final Map<String, dynamic> user;
  const _ProfileButton({required this.user});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(user: user),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.person_rounded, size: 24),
        ),
      ),
    );
  }
}
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Icon(icon, size: 24),
        ],
      ),
    );
  }
}

class _OutlinedButtonWithSub extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final VoidCallback onPressed;
  const _OutlinedButtonWithSub({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor.withValues(alpha: 0.6);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, size: 24),
          ],
        ),
      ),
    );
  }
}

// --- Stats Grid ---

class _StatsGrid extends StatelessWidget {
  final int todayRides;
  final int todayIncome;
  final int activeRides;
  final int totalIncome;
  final bool loading;

  const _StatsGrid({
    required this.todayRides,
    required this.todayIncome,
    required this.activeRides,
    required this.totalIncome,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final k = (totalIncome / 1000).toStringAsFixed(0);

    Widget card({
      required Widget leading,
      required String label,
      required String value,
      Color? bg,
      Color? fg,
      bool bold = false,
    }) {
      final background = bg ?? Theme.of(context).colorScheme.primaryContainer;
      final foreground = fg ?? Theme.of(context).colorScheme.onPrimaryContainer;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              leading,
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12, color: foreground.withValues(alpha: 0.9)),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            loading
                ? const SizedBox(
              height: 28,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 60,
                  height: 14,
                  child: LinearProgressIndicator(minHeight: 6),
                ),
              ),
            )
                : Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: foreground,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        card(
          leading: const Icon(Icons.directions_car_filled_rounded, size: 20),
          label: 'Өнөөдрийн аялал',
          value: '$todayRides',
          bold: true,
        ),
        card(
          leading: const Icon(Icons.attach_money_rounded, size: 20),
          label: 'Өнөөдрийн орлого',
          value: '${_thousand(todayIncome)}₮',
          bg: Theme.of(context).colorScheme.secondaryContainer,
          fg: Theme.of(context).colorScheme.onSecondaryContainer,
          bold: true,
        ),
        card(
          leading: Icon(Icons.trending_up_rounded,
              size: 20, color: Theme.of(context).colorScheme.primary),
          label: 'Идэвхтэй аялал',
          value: '$activeRides',
        ),
        card(
          leading: Icon(Icons.savings_outlined,
              size: 20, color: Theme.of(context).colorScheme.secondary),
          label: 'Нийт орлого',
          value: '${k}k₮',
        ),
      ],
    );
  }
}

// --- Helpers & Models ---

class _NotificationItem {
  final String message;
  final String time;
  _NotificationItem({required this.message, required this.time});
}

String _thousand(num n) {
  return n.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
  );
}