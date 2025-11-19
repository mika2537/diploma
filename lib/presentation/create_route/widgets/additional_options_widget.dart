import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdditionalOptionsWidget extends StatelessWidget {
  final bool allowSmoking;
  final bool petFriendly;
  final bool musicPreferences;
  final ValueChanged<bool> onSmokingChanged;
  final ValueChanged<bool> onPetFriendlyChanged;
  final ValueChanged<bool> onMusicChanged;
  final TextEditingController notesController;

  const AdditionalOptionsWidget({
    super.key,
    required this.allowSmoking,
    required this.petFriendly,
    required this.musicPreferences,
    required this.onSmokingChanged,
    required this.onPetFriendlyChanged,
    required this.onMusicChanged,
    required this.notesController,
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
              'Нэмэлт сонголтууд',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            _buildOptionSwitch(
              context: context,
              title: 'Тамхи татахыг зөвшөөрөх',
              subtitle: 'Зорчигч тамхи татаж болно',
              icon: 'smoking_rooms',
              value: allowSmoking,
              onChanged: onSmokingChanged,
            ),
            SizedBox(height: 2.h),
            _buildOptionSwitch(
              context: context,
              title: 'Гэрийн тэжээвэр амьтан',
              subtitle: 'Жижиг амьтан авчрах боломжтой',
              icon: 'pets',
              value: petFriendly,
              onChanged: onPetFriendlyChanged,
            ),
            SizedBox(height: 2.h),
            _buildOptionSwitch(
              context: context,
              title: 'Хөгжмийн сонголт',
              subtitle: 'Зорчигч хөгжим сонгож болно',
              icon: 'music_note',
              value: musicPreferences,
              onChanged: onMusicChanged,
            ),
            SizedBox(height: 3.h),
            _buildNotesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionSwitch({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: value
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: value
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: value
                  ? theme.colorScheme.primary
                  : AppTheme.secondaryGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: value ? Colors.white : AppTheme.secondaryGray,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryGray,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
            inactiveThumbColor: AppTheme.secondaryGray,
            inactiveTrackColor: AppTheme.secondaryGray.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'note_add',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Нэмэлт тэмдэглэл',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: notesController,
          maxLines: 3,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'Тусгай заавар эсвэл мэдээлэл...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.all(4.w),
            counterStyle: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryGray,
            ),
          ),
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              color: AppTheme.secondaryGray,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Зорчигчдод харагдах нэмэлт мэдээлэл',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
