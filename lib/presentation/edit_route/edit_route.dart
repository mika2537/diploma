import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../create_route/widgets/additional_options_widget.dart';
import '../create_route/widgets/origin_destination_widget.dart';
import '../create_route/widgets/route_preview_widget.dart';
import '../create_route/widgets/schedule_picker_widget.dart';
import '../create_route/widgets/seats_pricing_widget.dart';

import '../saved_route/models/saved_route_model.dart';

class EditRoute extends StatefulWidget {
  final SavedRouteModel route;

  const EditRoute({super.key, required this.route});

  @override
  State<EditRoute> createState() => _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  // Controllers
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;

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

  // Location suggestions
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

    // Pre-fill
    _originController = TextEditingController(text: widget.route.origin);
    _destinationController = TextEditingController(text: widget.route.destination);
    _priceController = TextEditingController(text: widget.route.price.toString());
    _notesController = TextEditingController();

    _selectedDate = widget.route.date;

    _selectedTime = TimeOfDay(
      hour: widget.route.date.hour,
      minute: widget.route.date.minute,
    );

    _availableSeats = widget.route.seats;
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
                      origin: _originController.text,
                      destination: _destinationController.text,
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
                      suggestedPrice: '—',
                      priceError: _priceError,
                    ),

                    SizedBox(height: 3.h),

                    AdditionalOptionsWidget(
                      allowSmoking: _allowSmoking,
                      petFriendly: _petFriendly,
                      musicPreferences: _musicPreferences,
                      onSmokingChanged: (v) => setState(() => _allowSmoking = v),
                      onPetFriendlyChanged: (v) => setState(() => _petFriendly = v),
                      onMusicChanged: (v) => setState(() => _musicPreferences = v),
                      notesController: _notesController,
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  // =========== APP BAR ===========
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
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Маршрут засах',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _isFormValid() ? _saveRoute : null,
          child: Text(
            'Хадгалах',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color:
              _isFormValid() ? theme.colorScheme.primary : AppTheme.secondaryGray,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  // =========== HEADER ===========
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: CustomIconWidget(
              iconName: 'edit',
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Маршрут засварлах',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Өмнө үүсгэсэн маршрутаа шинэчилнэ үү',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryGray,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // =========== SAVE BUTTON ===========
  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isFormValid() && !_isLoading ? _saveRoute : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid()
                  ? Theme.of(context).colorScheme.primary
                  : AppTheme.secondaryGray.withOpacity(0.3),
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Маршрут хадгалах'),
          ),
        ),
      ),
    );
  }

  // =========== PICKERS ===========
  void _selectOrigin() => _showLocationPicker(
    title: 'Эхлэх цэг сонгох',
    onSelected: (loc) {
      setState(() {
        _originController.text = loc;
        _originError = null;
      });
    },
  );

  void _selectDestination() => _showLocationPicker(
    title: 'Очих цэг сонгох',
    onSelected: (loc) {
      setState(() {
        _destinationController.text = loc;
        _destinationError = null;
      });
    },
  );

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
          builder: (_, scroll) {
            return ListView(
              controller: scroll,
              children: [
                SizedBox(height: 2.h),
                ..._locationSuggestions.map(
                      (loc) => ListTile(
                    leading: const Icon(Icons.location_pin, color: Colors.blue),
                    title: Text(loc),
                    onTap: () {
                      onSelected(loc);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Date Picker
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateError = null;
      });
    }
  }

  // Time Picker
  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _timeError = null;
      });
    }
  }

  // =========== SEATS ===========
  void _incrementSeats() =>
      setState(() => _availableSeats < 6 ? _availableSeats++ : null);

  void _decrementSeats() =>
      setState(() => _availableSeats > 1 ? _availableSeats-- : null);

  // =========== VALIDATION ===========
  bool _isFormValid() {
    return _originController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _priceController.text.isNotEmpty;
  }

  // =========== SAVE ===========
  Future<void> _saveRoute() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Маршрут амжилттай шинэчлэгдлээ"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}