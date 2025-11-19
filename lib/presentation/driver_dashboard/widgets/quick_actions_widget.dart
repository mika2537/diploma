import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onCreateRoute;
  final VoidCallback onViewRequests;
  final VoidCallback? onActiveRide;
  final bool hasActiveRide;

  const QuickActionsWidget({
    super.key,
    required this.onCreateRoute,
    required this.onViewRequests,
    this.onActiveRide,
    this.hasActiveRide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Хурдан үйлдлүүд',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  title: 'Маршрут үүсгэх',
                  icon: 'add_road',
                  color: AppTheme.primaryBlue,
                  onTap: onCreateRoute,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  title: 'Хүсэлтүүд харах',
                  icon: 'inbox',
                  color: AppTheme.warningOrange,
                  onTap: onViewRequests,
                ),
              ),
            ],
          ),
          if (hasActiveRide && onActiveRide != null) ...[
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                context: context,
                title: 'Идэвхтэй аялал',
                icon: 'navigation',
                color: AppTheme.successGreen,
                onTap: onActiveRide!,
                isFullWidth: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: isFullWidth ? 3.h : 2.5.h,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: isFullWidth
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
