import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PassengerInfoCard extends StatelessWidget {
  final Map<String, dynamic> passengerData;

  const PassengerInfoCard({
    super.key,
    required this.passengerData,
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
          _buildPassengerHeader(context),
          SizedBox(height: 2.h),
          _buildPassengerDetails(context),
          if ((passengerData["specialRequirements"] as List).isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildSpecialRequirements(context),
          ],
          if (passengerData["previousTrips"] != null &&
              passengerData["previousTrips"] > 0) ...[
            SizedBox(height: 2.h),
            _buildPreviousTripsInfo(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPassengerHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: CustomImageWidget(
              imageUrl: passengerData["avatar"] as String,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
              semanticLabel: passengerData["avatarSemanticLabel"] as String,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      passengerData["name"] as String,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (passengerData["isVerified"] as bool) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.onPrimaryWhite,
                        size: 3.w,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  _buildRatingStars(passengerData["rating"] as double),
                  SizedBox(width: 2.w),
                  Text(
                    '${passengerData["rating"]} (${passengerData["totalRatings"]} reviews)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < rating.floor() ? 'star' : 'star_border',
          color: AppTheme.warningOrange,
          size: 3.w,
        );
      }),
    );
  }

  Widget _buildPassengerDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildDetailRow(
          context,
          'Член болсон',
          passengerData["joinDate"] as String,
          'calendar_today',
        ),
        SizedBox(height: 1.h),
        _buildDetailRow(
          context,
          'Нийт аялал',
          '${passengerData["totalTrips"]} удаа',
          'directions_car',
        ),
        if (passengerData["mutualConnections"] != null &&
            passengerData["mutualConnections"] > 0) ...[
          SizedBox(height: 1.h),
          _buildDetailRow(
            context,
            'Нийтлэг холбоо',
            '${passengerData["mutualConnections"]} хүн',
            'people',
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.primary,
          size: 4.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialRequirements(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final requirements = passengerData["specialRequirements"] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Тусгай шаардлага',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: requirements.map((requirement) {
            final req = requirement as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getRequirementColor(req["type"] as String)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: _getRequirementColor(req["type"] as String)
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getRequirementIcon(req["type"] as String),
                    color: _getRequirementColor(req["type"] as String),
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    req["label"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getRequirementColor(req["type"] as String),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPreviousTripsInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.successGreen,
            size: 4.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Өмнө нь хамт аялсан',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.successGreen,
                  ),
                ),
                Text(
                  '${passengerData["previousTrips"]} удаа • Сайн үнэлгээтэй',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successGreen.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRequirementColor(String type) {
    switch (type) {
      case 'smoking':
        return AppTheme.errorRed;
      case 'pets':
        return AppTheme.warningOrange;
      case 'luggage':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.secondaryGray;
    }
  }

  String _getRequirementIcon(String type) {
    switch (type) {
      case 'smoking':
        return 'smoking_rooms';
      case 'pets':
        return 'pets';
      case 'luggage':
        return 'luggage';
      default:
        return 'info';
    }
  }
}
