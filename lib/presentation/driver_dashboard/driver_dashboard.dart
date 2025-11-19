import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/notification_banner_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/statistics_cards_widget.dart';
import './widgets/status_card_widget.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool _isOnline = false;
  bool _hasIncomingRequest = false;
  bool _hasActiveRide = false;
  bool _isRefreshing = false;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentTrips = [
    {
      "id": 1,
      "passengerName": "Батбаяр Цэрэндорж",
      "date": "2025-11-13",
      "time": "08:30",
      "earnings": "₮15,000",
      "status": "completed",
    },
    {
      "id": 2,
      "passengerName": "Сарангэрэл Мөнхбат",
      "date": "2025-11-12",
      "time": "17:45",
      "earnings": "₮22,500",
      "status": "completed",
    },
    {
      "id": 3,
      "passengerName": "Энхбаяр Ганбат",
      "date": "2025-11-12",
      "time": "14:20",
      "earnings": "₮8,000",
      "status": "cancelled",
    },
    {
      "id": 4,
      "passengerName": "Оюунчимэг Батсайхан",
      "date": "2025-11-11",
      "time": "09:15",
      "earnings": "₮18,750",
      "status": "completed",
    },
    {
      "id": 5,
      "passengerName": "Болдбаатар Цогтбаяр",
      "date": "2025-11-11",
      "time": "16:30",
      "earnings": "₮12,300",
      "status": "completed",
    },
  ];

  // Mock incoming request data
  final Map<String, dynamic> _incomingRequest = {
    "passengerName": "Мөнхзул Баттөгс",
    "pickupLocation": "Сүхбаатарын талбай, Улаанбаатар",
    "fare": "₮25,000",
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Жолоочийн самбар',
        variant: AppBarVariant.dashboard,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              StatusCardWidget(
                isOnline: _isOnline,
                todayEarnings: _calculateTodayEarnings(),
                onToggle: _toggleOnlineStatus,
              ),

              // Incoming Request Banner
              if (_hasIncomingRequest && _isOnline)
                NotificationBannerWidget(
                  passengerName: _incomingRequest['passengerName'] as String,
                  pickupLocation: _incomingRequest['pickupLocation'] as String,
                  fare: _incomingRequest['fare'] as String,
                  onAccept: _acceptRequest,
                  onReject: _rejectRequest,
                ),

              SizedBox(height: 2.h),

              // Statistics Cards
              StatisticsCardsWidget(
                activeRides: _hasActiveRide ? 1 : 0,
                pendingRequests: _hasIncomingRequest ? 1 : 0,
                weeklyIncome: _calculateWeeklyIncome(),
                driverRating: 4.8,
              ),

              SizedBox(height: 2.h),

              // Quick Actions
              QuickActionsWidget(
                onCreateRoute: _navigateToCreateRoute,
                onViewRequests: _navigateToRequests,
                onActiveRide: _hasActiveRide ? _navigateToActiveRide : null,
                hasActiveRide: _hasActiveRide,
              ),

              SizedBox(height: 2.h),

              // Recent Activity
              RecentActivityWidget(
                recentTrips: _recentTrips,
              ),

              SizedBox(height: 10.h), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        variant: BottomBarVariant.driver,
        onTap: _onBottomNavTap,
      ),
      floatingActionButton: !_isOnline
          ? FloatingActionButton.extended(
        onPressed: _goOnline,
        backgroundColor: AppTheme.successGreen,
        foregroundColor: AppTheme.onPrimaryWhite,
        icon: CustomIconWidget(
          iconName: 'power_settings_new',
          color: AppTheme.onPrimaryWhite,
          size: 20,
        ),
        label: Text(
          'Онлайн болох',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppTheme.onPrimaryWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : null,
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      // Simulate new incoming request occasionally
      if (_isOnline && DateTime.now().millisecond % 3 == 0) {
        _hasIncomingRequest = true;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Мэдээлэл шинэчлэгдлээ'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
      if (!_isOnline) {
        _hasIncomingRequest = false;
        _hasActiveRide = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'Та онлайн боллоо' : 'Та оффлайн боллоо'),
        backgroundColor:
        _isOnline ? AppTheme.successGreen : AppTheme.secondaryGray,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _goOnline() {
    setState(() {
      _isOnline = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Та онлайн боллоо! Аялалын хүсэлт хүлээж байна...'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );

    // Simulate incoming request after going online
    Future.delayed(const Duration(seconds: 5), () {
      if (_isOnline && mounted) {
        setState(() {
          _hasIncomingRequest = true;
        });
      }
    });
  }

  void _acceptRequest() {
    setState(() {
      _hasIncomingRequest = false;
      _hasActiveRide = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Аялалын хүсэлтийг зөвшөөрлөө'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _rejectRequest() {
    setState(() {
      _hasIncomingRequest = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Аялалын хүсэлтийг татгалзлаа'),
        backgroundColor: AppTheme.warningOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _navigateToCreateRoute() {
    Navigator.pushNamed(context, '/create-route');
  }

  void _navigateToRequests() {
    Navigator.pushNamed(context, '/incoming-requests');
  }

  void _navigateToActiveRide() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Идэвхтэй аялалын дэлгэц удахгүй нээгдэнэ')),
    );
  }

  void _onBottomNavTap(int index) {
    // Handle bottom navigation tap
    // Current screen is already dashboard (index 0)
  }

  String _calculateTodayEarnings() {
    final today = DateTime.now();
    final todayString =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    int totalEarnings = 0;
    for (final trip in _recentTrips) {
      if (trip['date'] == todayString && trip['status'] == 'completed') {
        final earningsStr = (trip['earnings'] as String)
            .replaceAll('₮', '')
            .replaceAll(',', '');
        totalEarnings += int.tryParse(earningsStr) ?? 0;
      }
    }

    return totalEarnings > 0
        ? '₮${totalEarnings.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        : '₮0';
  }

  String _calculateWeeklyIncome() {
    int totalEarnings = 0;
    for (final trip in _recentTrips) {
      if (trip['status'] == 'completed') {
        final earningsStr = (trip['earnings'] as String)
            .replaceAll('₮', '')
            .replaceAll(',', '');
        totalEarnings += int.tryParse(earningsStr) ?? 0;
      }
    }

    return '₮${totalEarnings.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
