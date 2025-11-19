import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class RequestContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onViewProfile;
  final VoidCallback onMessagePassenger;
  final VoidCallback onReportIssue;
  final VoidCallback onDismiss;

  const RequestContextMenuWidget({
    super.key,
    required this.request,
    required this.onViewProfile,
    required this.onMessagePassenger,
    required this.onReportIssue,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.15),
              offset: const Offset(0, 8),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme, isDark),
            _buildMenuItems(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
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
                imageUrl: request['passengerPhoto'] ?? '',
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
                semanticLabel:
                request['passengerPhotoLabel'] ?? 'Passenger profile photo',
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['passengerName'] ?? 'Unknown',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.warningOrange,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${request['rating'] ?? 0.0}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '•',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${request['distance']} км',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(ThemeData theme, bool isDark) {
    return Column(
      children: [
        _buildMenuItem(
          theme,
          'person',
          'Профайл үзэх',
          'Зорчигчийн дэлгэрэнгүй мэдээлэл үзэх',
          onViewProfile,
        ),
        _buildMenuItem(
          theme,
          'chat',
          'Мессеж илгээх',
          'Зорчигчтай шууд харилцах',
          onMessagePassenger,
        ),
        _buildMenuItem(
          theme,
          'report',
          'Асуудал мэдээлэх',
          'Энэ хүсэлттэй холбоотой асуудал мэдээлэх',
          onReportIssue,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
      ThemeData theme,
      String iconName,
      String title,
      String subtitle,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {
    final iconColor = isDestructive
        ? AppTheme.errorRed
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final titleColor =
    isDestructive ? AppTheme.errorRed : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}