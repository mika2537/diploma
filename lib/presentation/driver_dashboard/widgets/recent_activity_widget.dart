import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentTrips;

  const RecentActivityWidget({
    super.key,
    required this.recentTrips,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Сүүлийн үйл ажиллагаа',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full trip history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Аялалын түүх удахгүй нээгдэнэ')),
                  );
                },
                child: Text(
                  'Бүгдийг харах',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          recentTrips.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTrips.length > 5 ? 5 : recentTrips.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final trip = recentTrips[index];
              return _buildTripItem(context, trip);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Аялалын түүх байхгүй',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Эхний маршрутаа үүсгээд аялал эхлүүлээрэй',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTripItem(BuildContext context, Map<String, dynamic> trip) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getStatusColor(trip['status'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getStatusIcon(trip['status'] as String),
              color: _getStatusColor(trip['status'] as String),
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['passengerName'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${trip['date']} • ${trip['time']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trip['earnings'] as String,
                style: AppTheme.dataTextStyle(
                  isLight: !isDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ).copyWith(
                  color: AppTheme.successGreen,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(trip['status'] as String)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(trip['status'] as String),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(trip['status'] as String),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successGreen;
      case 'cancelled':
        return AppTheme.errorRed;
      case 'pending':
        return AppTheme.warningOrange;
      default:
        return AppTheme.secondaryGray;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'check_circle';
      case 'cancelled':
        return 'cancel';
      case 'pending':
        return 'schedule';
      default:
        return 'help';
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Дууссан';
      case 'cancelled':
        return 'Цуцлагдсан';
      case 'pending':
        return 'Хүлээгдэж буй';
      default:
        return 'Тодорхойгүй';
    }
  }
}
