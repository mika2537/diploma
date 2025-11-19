import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const EmptyStateWidget({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(theme, isDark),
            SizedBox(height: 4.h),
            _buildTitle(theme),
            SizedBox(height: 2.h),
            _buildDescription(theme),
            SizedBox(height: 4.h),
            _buildSuggestions(theme),
            if (onRefresh != null) ...[
              SizedBox(height: 4.h),
              _buildRefreshButton(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme, bool isDark) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles for depth
          Positioned(
            top: 8.w,
            right: 8.w,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
          ),
          Positioned(
            bottom: 10.w,
            left: 6.w,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
          ),
          // Main icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'notifications_none',
                color: theme.colorScheme.primary,
                size: 48,
              ),
            ),
          ),
          // Animated dots
          Positioned(
            top: 12.w,
            left: 12.w,
            child: _buildAnimatedDot(theme, 0),
          ),
          Positioned(
            top: 14.w,
            left: 16.w,
            child: _buildAnimatedDot(theme, 200),
          ),
          Positioned(
            top: 16.w,
            left: 20.w,
            child: _buildAnimatedDot(theme, 400),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(ThemeData theme, int delay) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: value * 0.6),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'Хүсэлт байхгүй байна',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      'Одоогоор таны маршрутад тохирох зорчигчийн хүсэлт байхгүй байна. Та дараах зүйлсийг хийж үзээрэй.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSuggestions(ThemeData theme) {
    return Column(
      children: [
        _buildSuggestionItem(
          theme,
          'visibility',
          'Маршрутын харагдах байдлыг шалгаарай',
          'Таны маршрут бусад хэрэглэгчдэд харагдаж байгаа эсэхийг шалгана уу',
        ),
        SizedBox(height: 2.h),
        _buildSuggestionItem(
          theme,
          'schedule',
          'Цагийн хуваарийг шинэчилнэ үү',
          'Илүү олон зорчигч байгаа цагт маршрут үүсгэж үзээрэй',
        ),
        SizedBox(height: 2.h),
        _buildSuggestionItem(
          theme,
          'location_on',
          'Алдартай газруудаар дамжуулаарай',
          'Олон хүний явдаг газруудаар дамжих маршрут үүсгээрэй',
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(
      ThemeData theme,
      String iconName,
      String title,
      String description,
      ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: theme.colorScheme.primary,
                size: 24,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(ThemeData theme) {
    return OutlinedButton.icon(
      onPressed: onRefresh,
      icon: CustomIconWidget(
        iconName: 'refresh',
        color: theme.colorScheme.primary,
        size: 20,
      ),
      label: Text(
        'Дахин шинэчлэх',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }
}
