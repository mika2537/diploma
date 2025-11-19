
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SchedulePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;
  final String? dateError;
  final String? timeError;

  const SchedulePickerWidget({
    super.key,
    this.selectedDate,
    this.selectedTime,
    required this.onDateTap,
    required this.onTimeTap,
    this.dateError,
    this.timeError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              'Хуваарь',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(context),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildTimePicker(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final theme = Theme.of(context);
    final dateText = selectedDate != null
        ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Огноо',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: dateError != null
                    ? AppTheme.errorRed
                    : theme.colorScheme.outline,
                width: dateError != null ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    dateText.isEmpty ? 'Огноо сонгох' : dateText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: dateText.isEmpty
                          ? AppTheme.secondaryGray
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.secondaryGray,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (dateError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            dateError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    final theme = Theme.of(context);
    final timeText = selectedTime != null ? selectedTime!.format(context) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Цаг',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onTimeTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: timeError != null
                    ? AppTheme.errorRed
                    : theme.colorScheme.outline,
                width: timeError != null ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'access_time',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    timeText.isEmpty ? 'Цаг сонгох' : timeText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: timeText.isEmpty
                          ? AppTheme.secondaryGray
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.secondaryGray,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (timeError != null) ...[
          SizedBox(height: 0.5.h),
          Text(
            timeError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
        ],
      ],
    );
  }
}
