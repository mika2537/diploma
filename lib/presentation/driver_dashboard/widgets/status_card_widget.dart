import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusCardWidget extends StatelessWidget {
  final bool isOnline;
  final String todayEarnings;
  final VoidCallback onToggle;

  const StatusCardWidget({
    super.key,
    required this.isOnline,
    required this.todayEarnings,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статус',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    isOnline ? 'Онлайн' : 'Оффлайн',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isOnline
                          ? AppTheme.successGreen
                          : AppTheme.secondaryGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 15.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppTheme.successGreen.withValues(alpha: 0.2)
                        : AppTheme.secondaryGray.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isOnline
                          ? AppTheme.successGreen
                          : AppTheme.secondaryGray,
                      width: 2,
                    ),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment:
                    isOnline ? Alignment.topCenter : Alignment.bottomCenter,
                    child: Container(
                      width: 10.w,
                      height: 3.h,
                      margin: EdgeInsets.all(0.5.w),
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppTheme.successGreen
                            : AppTheme.secondaryGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Өнөөдрийн орлого',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            todayEarnings,
            style: AppTheme.dataTextStyle(
              isLight: !isDark,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ).copyWith(
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
