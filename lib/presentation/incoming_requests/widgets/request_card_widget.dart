import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class RequestCardWidget extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const RequestCardWidget({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<RequestCardWidget> createState() => _RequestCardWidgetState();
}

class _RequestCardWidgetState extends State<RequestCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _countdownController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  double _dragOffset = 0.0;
  bool _isDragging = false;
  static const double _swipeThreshold = 100.0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _countdownController = AnimationController(
      duration: Duration(seconds: widget.request['timeRemaining'] ?? 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _countdownController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-200.0, 200.0);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragOffset.abs() > _swipeThreshold) {
      HapticFeedback.mediumImpact();
      if (_dragOffset > 0) {
        _handleAccept();
      } else {
        _handleDecline();
      }
    } else {
      setState(() {
        _dragOffset = 0.0;
        _isDragging = false;
      });
    }
  }

  void _handleAccept() {
    HapticFeedback.heavyImpact();
    _slideController.forward().then((_) {
      widget.onAccept();
    });
  }

  void _handleDecline() {
    HapticFeedback.heavyImpact();
    _slideController.forward().then((_) {
      widget.onDecline();
    });
  }

  Color _getUrgencyColor() {
    final timeRemaining = widget.request['timeRemaining'] ?? 300;
    if (timeRemaining <= 60) return AppTheme.errorRed;
    if (timeRemaining <= 120) return AppTheme.warningOrange;
    return AppTheme.successGreen;
  }

  String _formatTimeRemaining() {
    final timeRemaining = widget.request['timeRemaining'] ?? 300;
    final minutes = timeRemaining ~/ 60;
    final seconds = timeRemaining % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildCard(theme, isDark),
          ),
        );
      },
    );
  }

  Widget _buildCard(ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              _buildSwipeBackground(),
              _buildCardContent(theme, isDark),
              if (_isDragging) _buildSwipeIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          gradient: LinearGradient(
            colors: _dragOffset > 0
                ? [
              AppTheme.successGreen.withValues(alpha: 0.1),
              AppTheme.successGreen.withValues(alpha: 0.3)
            ]
                : [
              AppTheme.errorRed.withValues(alpha: 0.1),
              AppTheme.errorRed.withValues(alpha: 0.3)
            ],
            begin:
            _dragOffset > 0 ? Alignment.centerLeft : Alignment.centerRight,
            end: _dragOffset > 0 ? Alignment.centerRight : Alignment.centerLeft,
          ),
        ),
        child: Align(
          alignment:
          _dragOffset > 0 ? Alignment.centerLeft : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: _dragOffset > 0 ? 'check_circle' : 'cancel',
                  color: _dragOffset > 0
                      ? AppTheme.successGreen
                      : AppTheme.errorRed,
                  size: 32,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _dragOffset > 0 ? 'Accept' : 'Decline',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: _dragOffset > 0
                        ? AppTheme.successGreen
                        : AppTheme.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, isDark),
          SizedBox(height: 2.h),
          _buildPassengerInfo(theme, isDark),
          SizedBox(height: 2.h),
          _buildLocationInfo(theme, isDark),
          SizedBox(height: 2.h),
          _buildRequestDetails(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: _getUrgencyColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: _getUrgencyColor(),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _formatTimeRemaining(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _getUrgencyColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(
            '${widget.request['distance']} км',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerInfo(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            child: CustomImageWidget(
              imageUrl: widget.request['passengerPhoto'] ?? '',
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
              semanticLabel: widget.request['passengerPhotoLabel'] ??
                  'Passenger profile photo',
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.request['passengerName'] ?? 'Unknown',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.warningOrange,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${widget.request['rating'] ?? 0.0}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Зорчигч • ${widget.request['requestTime'] ?? 'Одоо'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(ThemeData theme, bool isDark) {
    return Column(
      children: [
        _buildLocationRow(
          theme,
          'trip_origin',
          AppTheme.successGreen,
          widget.request['pickupLocation'] ?? 'Pickup location',
        ),
        SizedBox(height: 1.h),
        _buildLocationRow(
          theme,
          'place',
          AppTheme.errorRed,
          widget.request['dropoffLocation'] ?? 'Dropoff location',
        ),
      ],
    );
  }

  Widget _buildLocationRow(
      ThemeData theme, String iconName, Color iconColor, String location) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: iconColor,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            location,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestDetails(ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'people',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              '${widget.request['passengers'] ?? 1} зорчигч',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(
            '${widget.request['price'] ?? '0'}₮',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppTheme.successGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeIndicator() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: _dragOffset > 0 ? AppTheme.successGreen : AppTheme.errorRed,
            width: 2,
          ),
        ),
      ),
    );
  }
}