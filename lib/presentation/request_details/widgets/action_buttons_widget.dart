import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final bool isLoading;

  const ActionButtonsWidget({
    super.key,
    required this.onAccept,
    required this.onDecline,
    this.isLoading = false,
  });

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
  bool _isAcceptLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAcceptButton(context),
            SizedBox(height: 2.h),
            _buildDeclineButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed:
        (_isAcceptLoading || widget.isLoading) ? null : _handleAccept,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: AppTheme.onPrimaryWhite,
          elevation: AppTheme.elevationLevel2,
          shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: _isAcceptLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 4.w,
              height: 4.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.onPrimaryWhite,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'Боловсруулж байна...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.onPrimaryWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.onPrimaryWhite,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Хүсэлт зөвшөөрөх',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.onPrimaryWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeclineButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: OutlinedButton(
        onPressed:
        (_isAcceptLoading || widget.isLoading) ? null : _handleDecline,
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: colorScheme.outline,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'cancel',
              color: colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Татгалзах',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAccept() async {
    setState(() => _isAcceptLoading = true);

    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isAcceptLoading = false);

    // Success haptic feedback
    HapticFeedback.heavyImpact();

    widget.onAccept();
  }

  void _handleDecline() {
    // Light haptic feedback for decline
    HapticFeedback.lightImpact();

    _showDeclineReasonBottomSheet();
  }

  void _showDeclineReasonBottomSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                'Татгалзах шалтгаан',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Хүсэлтийг татгалзах шалтгаанаа сонгоно уу',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 3.h),
              ..._buildDeclineReasons(context),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDeclineReasons(BuildContext context) {
    final reasons = [
      {
        'title': 'Маршрут таарахгүй байна',
        'subtitle': 'Миний маршруттай давхцахгүй байна',
        'icon': 'route',
      },
      {
        'title': 'Цагийн хуваарь тохирохгүй',
        'subtitle': 'Тогтоосон цагт явах боломжгүй',
        'icon': 'schedule',
      },
      {
        'title': 'Машин дүүрсэн',
        'subtitle': 'Бусад зорчигч аль хэдийн байна',
        'icon': 'airline_seat_recline_normal',
      },
      {
        'title': 'Бусад шалтгаан',
        'subtitle': 'Өөр шалтгаанаар татгалзах',
        'icon': 'more_horiz',
      },
    ];

    return reasons
        .map((reason) => _buildDeclineReasonTile(
      context,
      reason['title'] as String,
      reason['subtitle'] as String,
      reason['icon'] as String,
    ))
        .toList();
  }

  Widget _buildDeclineReasonTile(
      BuildContext context, String title, String subtitle, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        onTap: () => _selectDeclineReason(title),
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: colorScheme.error,
            size: 5.w,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        tileColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
    );
  }

  void _selectDeclineReason(String reason) {
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Хүсэлт татгалзагдлаа: $reason'),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );

    widget.onDecline();
  }
}
