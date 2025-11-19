import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SeatsPricingWidget extends StatelessWidget {
  final int availableSeats;
  final VoidCallback onSeatsIncrement;
  final VoidCallback onSeatsDecrement;
  final TextEditingController priceController;
  final String suggestedPrice;
  final String? priceError;

  const SeatsPricingWidget({
    super.key,
    required this.availableSeats,
    required this.onSeatsIncrement,
    required this.onSeatsDecrement,
    required this.priceController,
    required this.suggestedPrice,
    this.priceError,
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
              'Суудал болон үнэ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            _buildSeatsSelector(context),
            SizedBox(height: 3.h),
            _buildPricingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Боломжтой суудал',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'airline_seat_recline_normal',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Зорчигчийн тоо',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              _buildStepperButton(
                context: context,
                icon: 'remove',
                onTap: availableSeats > 1 ? onSeatsDecrement : null,
              ),
              SizedBox(width: 3.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Text(
                  availableSeats.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              _buildStepperButton(
                context: context,
                icon: 'add',
                onTap: availableSeats < 6 ? onSeatsIncrement : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Хамгийн ихдээ 6 зорчигч',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryGray,
          ),
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required BuildContext context,
    required String icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          HapticFeedback.lightImpact();
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isEnabled
              ? theme.colorScheme.primary
              : AppTheme.secondaryGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: isEnabled ? Colors.white : AppTheme.secondaryGray,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Үнэ (нэг зорчигчид)',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 0.5.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                'Санал болгох: $suggestedPrice₮',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: priceController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(7),
          ],
          decoration: InputDecoration(
            hintText: 'Үнэ оруулна уу',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'payments',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            suffixText: '₮',
            suffixStyle: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            errorText: priceError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: priceError != null
                    ? AppTheme.errorRed
                    : theme.colorScheme.outline,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.errorRed,
                width: 2.0,
              ),
            ),
          ),
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: AppTheme.secondaryGray,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Нийт орлого: ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryGray,
                ),
              ),
              Text(
                '${_calculateTotalEarnings()}₮',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateTotalEarnings() {
    final priceText = priceController.text;
    if (priceText.isEmpty) return '0';

    final price = int.tryParse(priceText) ?? 0;
    final total = price * availableSeats;

    return total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}
