import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RouteInfoCard extends StatelessWidget {
  final Map<String, dynamic> routeData;

  const RouteInfoCard({
    super.key,
    required this.routeData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteHeader(context),
          SizedBox(height: 2.h),
          _buildLocationDetails(context),
          SizedBox(height: 2.h),
          _buildRouteImpact(context),
          SizedBox(height: 2.h),
          _buildMapPreview(context),
        ],
      ),
    );
  }

  Widget _buildRouteHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: CustomIconWidget(
            iconName: 'route',
            color: colorScheme.primary,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Маршрутын мэдээлэл',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${routeData["distance"]} • ${routeData["duration"]}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildLocationRow(
          context,
          'Авах газар',
          routeData["pickupLocation"] as String,
          'trip_origin',
          AppTheme.successGreen,
        ),
        SizedBox(height: 1.5.h),
        Container(
          margin: EdgeInsets.only(left: 6.w),
          child: Column(
            children: List.generate(
                3,
                    (index) => Container(
                  margin: EdgeInsets.only(bottom: 0.5.h),
                  width: 0.5.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                )),
          ),
        ),
        SizedBox(height: 1.5.h),
        _buildLocationRow(
          context,
          'Буулгах газар',
          routeData["dropoffLocation"] as String,
          'location_on',
          AppTheme.errorRed,
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context, String label, String location,
      String iconName, Color iconColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: iconColor,
            size: 4.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                location,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteImpact(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final impact = routeData["routeImpact"] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color:
        _getImpactColor(impact["level"] as String).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color:
          _getImpactColor(impact["level"] as String).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: _getImpactIcon(impact["level"] as String),
                color: _getImpactColor(impact["level"] as String),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Маршрутын нөлөө',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getImpactColor(impact["level"] as String),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildImpactDetail(
                  context,
                  'Нэмэлт зай',
                  impact["additionalDistance"] as String,
                  impact["distanceChange"] as String,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildImpactDetail(
                  context,
                  'Нэмэлт хугацаа',
                  impact["additionalTime"] as String,
                  impact["timeChange"] as String,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactDetail(
      BuildContext context, String label, String value, String change) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          change,
          style: theme.textTheme.bodySmall?.copyWith(
            color: change.startsWith('+')
                ? AppTheme.errorRed
                : AppTheme.successGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMapPreview(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 20.h,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Stack(
          children: [
            CustomImageWidget(
              imageUrl: routeData["mapPreview"] as String,
              width: double.infinity,
              height: 20.h,
              fit: BoxFit.cover,
              semanticLabel: routeData["mapSemanticLabel"] as String,
            ),
            Positioned(
              top: 2.w,
              right: 2.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'map',
                      color: colorScheme.primary,
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Дэлгэрэнгүй',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getImpactColor(String level) {
    switch (level) {
      case 'low':
        return AppTheme.successGreen;
      case 'medium':
        return AppTheme.warningOrange;
      case 'high':
        return AppTheme.errorRed;
      default:
        return AppTheme.secondaryGray;
    }
  }

  String _getImpactIcon(String level) {
    switch (level) {
      case 'low':
        return 'check_circle';
      case 'medium':
        return 'warning';
      case 'high':
        return 'error';
      default:
        return 'info';
    }
  }
}
