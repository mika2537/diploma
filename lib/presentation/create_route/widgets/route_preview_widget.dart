import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoutePreviewWidget extends StatelessWidget {
  final String? origin;
  final String? destination;
  final String distance;
  final String duration;
  final bool showMap;

  const RoutePreviewWidget({
    super.key,
    this.origin,
    this.destination,
    required this.distance,
    required this.duration,
    this.showMap = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasRoute = origin != null && destination != null;

    return Card(
      elevation: AppTheme.elevationLevel2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'map',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Маршрутын урьдчилсан харагдац',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (hasRoute && showMap) ...[
            Container(
              height: 25.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: Stack(
                  children: [
                    // Map placeholder with route visualization
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                            theme.colorScheme.secondary.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _RouteLinePainter(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    // Origin marker
                    Positioned(
                      left: 8.w,
                      top: 4.h,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'my_location',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    // Destination marker
                    Positioned(
                      right: 8.w,
                      bottom: 4.h,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'location_on',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    // Map overlay info
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius:
                          BorderRadius.circular(AppTheme.radiusSmall),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Газрын зураг',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
          if (!hasRoute) ...[
            Container(
              height: 15.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'map_outlined',
                      color: AppTheme.secondaryGray,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Эхлэх болон очих цэгээ сонгоно уу',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
          // Route info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context: context,
                    icon: 'straighten',
                    label: 'Зай',
                    value: distance,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildInfoItem(
                    context: context,
                    icon: 'schedule',
                    label: 'Хугацаа',
                    value: duration,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.w),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryGray,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteLinePainter extends CustomPainter {
  final Color color;

  _RouteLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Start from origin (left-top area)
    path.moveTo(size.width * 0.2, size.height * 0.25);

    // Create a curved route line
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1, // Control point
      size.width * 0.8, size.height * 0.3, // Mid point
    );

    path.quadraticBezierTo(
      size.width * 0.9, size.height * 0.6, // Control point
      size.width * 0.8, size.height * 0.75, // End point (destination)
    );

    canvas.drawPath(path, paint);

    // Draw dashed line effect
    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < 1; i += 0.05) {
      final point1 = path
          .computeMetrics()
          .first
          .getTangentForOffset(
        path.computeMetrics().first.length * i,
      )
          ?.position;
      final point2 = path
          .computeMetrics()
          .first
          .getTangentForOffset(
        path.computeMetrics().first.length * (i + 0.02),
      )
          ?.position;

      if (point1 != null && point2 != null) {
        canvas.drawLine(point1, point2, dashPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
