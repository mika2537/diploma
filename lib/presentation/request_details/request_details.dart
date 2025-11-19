import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/message_preview_card.dart';
import './widgets/passenger_info_card.dart';
import './widgets/route_info_card.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({super.key});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  bool _isLoading = false;
  bool _isRequestCancelled = false;

  // Mock data for the passenger request
  final Map<String, dynamic> _passengerData = {
    "id": 1,
    "name": "Батбаяр Энхтүвшин",
    "avatar":
    "https://img.rocket.new/generatedImages/rocket_gen_img_1ebebdcd4-1762274009418.png",
    "avatarSemanticLabel":
    "Professional headshot of a young Mongolian man with short black hair wearing a dark blue suit jacket",
    "rating": 4.8,
    "totalRatings": 127,
    "isVerified": true,
    "joinDate": "2023 оны 3-р сар",
    "totalTrips": 45,
    "mutualConnections": 3,
    "previousTrips": 2,
    "specialRequirements": [
      {
        "type": "luggage",
        "label": "Том ачаа тээвэр",
      },
      {
        "type": "pets",
        "label": "Гэрийн тэжээвэр амьтан",
      }
    ],
  };

  final Map<String, dynamic> _routeData = {
    "pickupLocation": "Сүхбаатарын талбай, Улаанбаатар",
    "dropoffLocation": "Чингисийн талбай, Улаанбаатар",
    "distance": "12.5 км",
    "duration": "25 мин",
    "mapPreview":
    "https://images.unsplash.com/photo-1627797341872-7694d02573f4",
    "mapSemanticLabel":
    "Aerial view of Ulaanbaatar city streets with main roads and intersections highlighted showing the route from Sukhbaatar Square to Chinggis Square",
    "routeImpact": {
      "level": "medium",
      "additionalDistance": "3.2 км",
      "additionalTime": "8 мин",
      "distanceChange": "+3.2 км",
      "timeChange": "+8 мин",
    }
  };

  final Map<String, dynamic> _messageData = {
    "hasExistingMessages": true,
    "existingMessages": [
      {
        "id": 1,
        "content": "Сайн байна уу? Та хэзээ хөдөлж эхлэх вэ?",
        "isFromPassenger": true,
        "timestamp": "14:30",
        "senderAvatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1ebebdcd4-1762274009418.png",
        "senderAvatarSemanticLabel":
        "Professional headshot of a young Mongolian man with short black hair wearing a dark blue suit jacket",
      },
      {
        "id": 2,
        "content": "Сайн байна уу! 15:00 цагт хөдлөх төлөвлөгөөтэй байна.",
        "isFromPassenger": false,
        "timestamp": "14:32",
        "senderAvatar":
        "https://images.unsplash.com/photo-1689691959105-6ad16e5b7eeb",
        "senderAvatarSemanticLabel":
        "Smiling middle-aged Mongolian driver wearing a casual blue shirt sitting in a car",
      },
      {
        "id": 3,
        "content": "Маш сайн! Би бэлэн байна. Танд асуух зүйл байна.",
        "isFromPassenger": true,
        "timestamp": "14:35",
        "senderAvatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1ebebdcd4-1762274009418.png",
        "senderAvatarSemanticLabel":
        "Professional headshot of a young Mongolian man with short black hair wearing a dark blue suit jacket",
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: _buildAppBar(context),
      body: _isRequestCancelled
          ? _buildCancelledView(context)
          : _buildMainContent(context),
      bottomNavigationBar:
      _isRequestCancelled ? null : _buildBottomActions(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 1,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: colorScheme.onSurface,
          size: 5.w,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Хүсэлтийн дэлгэрэнгүй',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            _passengerData["name"] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: colorScheme.onSurface,
            size: 5.w,
          ),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          CountdownTimerWidget(
            initialDuration: const Duration(minutes: 5),
            onTimerExpired: _handleTimerExpired,
          ),
          PassengerInfoCard(passengerData: _passengerData),
          RouteInfoCard(routeData: _routeData),
          MessagePreviewCard(
            messageData: _messageData,
            onMessageSent: _handleMessageSent,
          ),
          SizedBox(height: 10.h), // Space for bottom actions
        ],
      ),
    );
  }

  Widget _buildCancelledView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        margin: EdgeInsets.all(4.w),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow,
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.warningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: CustomIconWidget(
                iconName: 'cancel',
                color: AppTheme.warningOrange,
                size: 15.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Хүсэлт цуцлагдлаа',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Зорчигч хүсэлтээ цуцалсан эсвэл хугацаа дууссан байна.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: AppTheme.onPrimaryWhite,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: Text(
                  'Буцах',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.onPrimaryWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return ActionButtonsWidget(
      onAccept: _handleAcceptRequest,
      onDecline: _handleDeclineRequest,
      isLoading: _isLoading,
    );
  }

  void _handleTimerExpired() {
    setState(() => _isRequestCancelled = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Хүсэлтийн хугацаа дууслаа'),
        backgroundColor: AppTheme.warningOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _handleMessageSent(String message) {
    // Handle message sending logic here
    print('Message sent: $message');
  }

  void _handleAcceptRequest() {
    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Хүсэлт амжилттай зөвшөөрөгдлөө!'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );

        // Navigate to active ride screen
        Navigator.pushReplacementNamed(context, '/driver-dashboard');
      }
    });
  }

  void _handleDeclineRequest() {
    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);

        // Navigate back to incoming requests
        Navigator.pop(context);
      }
    });
  }

  void _showMoreOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXLarge),
          ),
        ),
        padding: EdgeInsets.all(4.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
                title: const Text('Зорчигчийн профайл үзэх'),
                onTap: () {
                  Navigator.pop(context);
                  _showPassengerProfile();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'report',
                  color: AppTheme.errorRed,
                  size: 5.w,
                ),
                title: const Text('Гомдол гаргах'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showPassengerProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Зорчигчийн профайл харах функц удахгүй нэмэгдэнэ')),
    );
  }

  void _showReportDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Гомдол гаргах функц удахгүй нэмэгдэнэ')),
    );
  }
}
