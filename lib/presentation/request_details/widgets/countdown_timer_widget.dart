import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CountdownTimerWidget extends StatefulWidget {
  final Duration initialDuration;
  final VoidCallback onTimerExpired;

  const CountdownTimerWidget({
    super.key,
    required this.initialDuration,
    required this.onTimerExpired,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with TickerProviderStateMixin {
  late Timer _timer;
  late Duration _remainingTime;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;

    _progressController = AnimationController(
      duration: widget.initialDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.linear,
    ));

    _startTimer();
    _progressController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onTimerExpired();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _getTimerBackgroundColor(),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: _getTimerBorderColor(),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getTimerBorderColor().withValues(alpha: 0.2),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTimerHeader(context),
          SizedBox(height: 2.h),
          _buildProgressIndicator(context),
          SizedBox(height: 2.h),
          _buildTimerDisplay(context),
          SizedBox(height: 1.h),
          _buildTimerMessage(context),
        ],
      ),
    );
  }

  Widget _buildTimerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: _getTimerIconColor().withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: CustomIconWidget(
            iconName: 'timer',
            color: _getTimerIconColor(),
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Хүлээх хугацаа',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getTimerTextColor(),
                ),
              ),
              Text(
                'Хариу өгөх хугацаа дуусах гэж байна',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _getTimerTextColor().withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 1.h,
          decoration: BoxDecoration(
            color: _getTimerIconColor().withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: _getTimerIconColor(),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerDisplay(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _getTimerIconColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeUnit(context, minutes.toString().padLeft(2, '0'), 'мин'),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              ':',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: _getTimerIconColor(),
              ),
            ),
          ),
          _buildTimeUnit(context, seconds.toString().padLeft(2, '0'), 'сек'),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, String value, String unit) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: _getTimerIconColor(),
            fontSize: 24.sp,
          ),
        ),
        Text(
          unit,
          style: theme.textTheme.bodySmall?.copyWith(
            color: _getTimerIconColor().withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerMessage(BuildContext context) {
    final theme = Theme.of(context);
    final String message = _getTimerMessage();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: _getTimerIconColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: _getTimerMessageIcon(),
            color: _getTimerIconColor(),
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _getTimerIconColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimerBackgroundColor() {
    final totalSeconds = widget.initialDuration.inSeconds;
    final remainingSeconds = _remainingTime.inSeconds;
    final progress = remainingSeconds / totalSeconds;

    if (progress > 0.5) {
      return AppTheme.successGreen.withValues(alpha: 0.1);
    } else if (progress > 0.2) {
      return AppTheme.warningOrange.withValues(alpha: 0.1);
    } else {
      return AppTheme.errorRed.withValues(alpha: 0.1);
    }
  }

  Color _getTimerBorderColor() {
    final totalSeconds = widget.initialDuration.inSeconds;
    final remainingSeconds = _remainingTime.inSeconds;
    final progress = remainingSeconds / totalSeconds;

    if (progress > 0.5) {
      return AppTheme.successGreen.withValues(alpha: 0.3);
    } else if (progress > 0.2) {
      return AppTheme.warningOrange.withValues(alpha: 0.3);
    } else {
      return AppTheme.errorRed.withValues(alpha: 0.3);
    }
  }

  Color _getTimerIconColor() {
    final totalSeconds = widget.initialDuration.inSeconds;
    final remainingSeconds = _remainingTime.inSeconds;
    final progress = remainingSeconds / totalSeconds;

    if (progress > 0.5) {
      return AppTheme.successGreen;
    } else if (progress > 0.2) {
      return AppTheme.warningOrange;
    } else {
      return AppTheme.errorRed;
    }
  }

  Color _getTimerTextColor() {
    return _getTimerIconColor();
  }

  String _getTimerMessage() {
    final totalSeconds = widget.initialDuration.inSeconds;
    final remainingSeconds = _remainingTime.inSeconds;
    final progress = remainingSeconds / totalSeconds;

    if (progress > 0.5) {
      return 'Хүсэлтийг авч үзэх хангалттай хугацаа байна';
    } else if (progress > 0.2) {
      return 'Хугацаа дуусах гэж байна - шийдвэр гаргаарай';
    } else {
      return 'Хугацаа дуусах дөхөж байна!';
    }
  }

  String _getTimerMessageIcon() {
    final totalSeconds = widget.initialDuration.inSeconds;
    final remainingSeconds = _remainingTime.inSeconds;
    final progress = remainingSeconds / totalSeconds;

    if (progress > 0.5) {
      return 'check_circle';
    } else if (progress > 0.2) {
      return 'warning';
    } else {
      return 'error';
    }
  }
}
