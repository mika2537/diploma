import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/additional_options_widget.dart';
import './widgets/origin_destination_widget.dart';
import './widgets/route_preview_widget.dart';
import './widgets/schedule_picker_widget.dart';
import './widgets/seats_pricing_widget.dart';

class CreateRoute extends StatefulWidget {
  const CreateRoute({super.key});

  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  // Form controllers
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Form state
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _availableSeats = 4;
  bool _allowSmoking = false;
  bool _petFriendly = false;
  bool _musicPreferences = true;
  bool _isLoading = false;

  // Validation errors
  String? _originError;
  String? _destinationError;
  String? _dateError;
  String? _timeError;
  String? _priceError;

  // Mock data for suggestions
  final List<String> _locationSuggestions = [
    'Улаанбаатар хот, Сүхбаатар дүүрэг',
    'Улаанбаатар хот, Чингэлтэй дүүрэг',
    'Улаанбаатар хот, Баянзүрх дүүрэг',
    'Улаанбаатар хот, Хан-Уул дүүрэг',
    'Улаанбаатар хот, Баянгол дүүрэг',
    'Дархан хот',
    'Эрдэнэт хот',
    'Чойбалсан хот',
  ];

  @override
  void initState() {
    super.initState();
    _priceController.text = '15000'; // Default suggested price
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 3.h),
                    OriginDestinationWidget(
                      originController: _originController,
                      destinationController: _destinationController,
                      onOriginTap: _selectOrigin,
                      onDestinationTap: _selectDestination,
                      originError: _originError,
                      destinationError: _destinationError,
                    ),
                    SizedBox(height: 3.h),
                    RoutePreviewWidget(
                      origin: _originController.text.isEmpty
                          ? null
                          : _originController.text,
                      destination: _destinationController.text.isEmpty
                          ? null
                          : _destinationController.text,
                      distance: '45 км',
                      duration: '1 цаг 15 мин',
                      showMap: _originController.text.isNotEmpty &&
                          _destinationController.text.isNotEmpty,
                    ),
                    SizedBox(height: 3.h),
                    SchedulePickerWidget(
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      onDateTap: _selectDate,
                      onTimeTap: _selectTime,
                      dateError: _dateError,
                      timeError: _timeError,
                    ),
                    SizedBox(height: 3.h),
                    SeatsPricingWidget(
                      availableSeats: _availableSeats,
                      onSeatsIncrement: _incrementSeats,
                      onSeatsDecrement: _decrementSeats,
                      priceController: _priceController,
                      suggestedPrice: '15,000',
                      priceError: _priceError,
                    ),
                    SizedBox(height: 3.h),
                    AdditionalOptionsWidget(
                      allowSmoking: _allowSmoking,
                      petFriendly: _petFriendly,
                      musicPreferences: _musicPreferences,
                      onSmokingChanged: (value) =>
                          setState(() => _allowSmoking = value),
                      onPetFriendlyChanged: (value) =>
                          setState(() => _petFriendly = value),
                      onMusicChanged: (value) =>
                          setState(() => _musicPreferences = value),
                      notesController: _notesController,
                    ),
                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 1,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'close',
          color: theme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Маршрут үүсгэх',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _isFormValid() ? _createRoute : null,
          child: Text(
            'Үүсгэх',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _isFormValid()
                  ? theme.colorScheme.primary
                  : AppTheme.secondaryGray,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: CustomIconWidget(
              iconName: 'add_road',
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Шинэ маршрут үүсгэх',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Зорчигчдын хүсэлт хүлээн авахын тулд маршрутын мэдээллийг бөглөнө үү',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isFormValid() && !_isLoading ? _createRoute : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid()
                  ? theme.colorScheme.primary
                  : AppTheme.secondaryGray.withValues(alpha: 0.3),
              foregroundColor: Colors.white,
              elevation: _isFormValid() ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: _isLoading
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add_circle_outline',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Маршрут үүсгэх',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectOrigin() {
    _showLocationPicker(
      title: 'Эхлэх цэг сонгох',
      onSelected: (location) {
        setState(() {
          _originController.text = location;
          _originError = null;
        });
      },
    );
  }

  void _selectDestination() {
    _showLocationPicker(
      title: 'Очих цэг сонгох',
      onSelected: (location) {
        setState(() {
          _destinationController.text = location;
          _destinationError = null;
        });
      },
    );
  }

  void _showLocationPicker({
    required String title,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: _locationSuggestions.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppTheme.secondaryGray.withValues(alpha: 0.2),
                      ),
                      itemBuilder: (context, index) {
                        final location = _locationSuggestions[index];
                        return ListTile(
                          leading: CustomIconWidget(
                            iconName: 'location_on',
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          title: Text(
                            location,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onTap: () {
                            onSelected(location);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = now.add(const Duration(days: 30));

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateError = null;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _timeError = null;
      });
    }
  }

  void _incrementSeats() {
    if (_availableSeats < 6) {
      setState(() {
        _availableSeats++;
      });
    }
  }

  void _decrementSeats() {
    if (_availableSeats > 1) {
      setState(() {
        _availableSeats--;
      });
    }
  }

  bool _isFormValid() {
    return _originController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _priceController.text.isNotEmpty;
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _originError = null;
      _destinationError = null;
      _dateError = null;
      _timeError = null;
      _priceError = null;
    });

    if (_originController.text.isEmpty) {
      setState(() {
        _originError = 'Эхлэх цэгээ сонгоно уу';
      });
      isValid = false;
    }

    if (_destinationController.text.isEmpty) {
      setState(() {
        _destinationError = 'Очих цэгээ сонгоно уу';
      });
      isValid = false;
    }

    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Огноо сонгоно уу';
      });
      isValid = false;
    }

    if (_selectedTime == null) {
      setState(() {
        _timeError = 'Цаг сонгоно уу';
      });
      isValid = false;
    }

    if (_priceController.text.isEmpty) {
      setState(() {
        _priceError = 'Үнэ оруулна уу';
      });
      isValid = false;
    } else {
      final price = int.tryParse(_priceController.text);
      if (price == null || price < 1000) {
        setState(() {
          _priceError = 'Хамгийн багадаа 1,000₮';
        });
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _createRoute() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Provide haptic feedback
      HapticFeedback.mediumImpact();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                const Text('Маршрут амжилттай үүсгэгдлээ'),
              ],
            ),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/driver-dashboard',
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                const Text('Алдаа гарлаа. Дахин оролдоно уу'),
              ],
            ),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
