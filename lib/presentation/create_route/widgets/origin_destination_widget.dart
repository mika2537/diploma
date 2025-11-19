import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OriginDestinationWidget extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  final VoidCallback? onOriginTap;
  final VoidCallback? onDestinationTap;
  final String? originError;
  final String? destinationError;

  const OriginDestinationWidget({
    super.key,
    required this.originController,
    required this.destinationController,
    this.onOriginTap,
    this.onDestinationTap,
    this.originError,
    this.destinationError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: AppTheme.elevationLevel2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Маршрут',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            _buildLocationField(
              context: context,
              controller: originController,
              label: 'Эхлэх цэг',
              hint: 'Эхлэх байршлаа оруулна уу',
              iconName: 'my_location',
              onTap: onOriginTap,
              error: originError,
              isDark: isDark,
            ),
            SizedBox(height: 2.h),
            _buildLocationField(
              context: context,
              controller: destinationController,
              label: 'Очих цэг',
              hint: 'Очих байршлаа оруулна уу',
              iconName: 'location_on',
              onTap: onDestinationTap,
              error: destinationError,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required String iconName,
    VoidCallback? onTap,
    String? error,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: error != null
                    ? AppTheme.errorRed
                    : theme.colorScheme.outline,
                width: error != null ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              color: theme.colorScheme.surface,
            ),
            child: TextFormField(
              controller: controller,
              enabled: onTap == null,
              readOnly: onTap != null,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                suffixIcon: onTap != null
                    ? Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'gps_fixed',
                    color: AppTheme.secondaryGray,
                    size: 20,
                  ),
                )
                    : null,
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        if (error != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            error,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
        ],
      ],
    );
  }
}
