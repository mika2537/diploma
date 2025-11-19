import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/request_card_widget.dart';
import './widgets/request_context_menu_widget.dart';

class IncomingRequests extends StatefulWidget {
  const IncomingRequests({super.key});

  @override
  State<IncomingRequests> createState() => _IncomingRequestsState();
}

class _IncomingRequestsState extends State<IncomingRequests>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late AnimationController _filterController;
  late Animation<double> _refreshAnimation;
  late Animation<double> _filterAnimation;

  bool _isRefreshing = false;
  bool _isLoading = true;
  Map<String, dynamic> _currentFilters = {
    'sortBy': 'distance',
    'maxDistance': 50,
    'minRating': 1.0,
    'minRouteMatch': 70,
  };

  List<Map<String, dynamic>> _allRequests = [];
  List<Map<String, dynamic>> _filteredRequests = [];
  Map<String, dynamic>? _selectedRequest;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMockData();
    _startAutoRefresh();
  }

  void _initializeAnimations() {
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));

    _filterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterController,
      curve: Curves.easeInOut,
    ));
  }

  void _loadMockData() {
    _allRequests = [
      {
        "id": 1,
        "passengerName": "Батбаяр",
        "passengerPhoto":
        "https://images.unsplash.com/photo-1603960098349-1b00a01b2d32",
        "passengerPhotoLabel":
        "Young Mongolian man with short black hair wearing a dark blue jacket, smiling at camera outdoors",
        "pickupLocation": "Сүхбаатарын талбай",
        "dropoffLocation": "Зайсан толгой",
        "distance": 8.5,
        "passengers": 2,
        "price": "15,000",
        "rating": 4.8,
        "requestTime": "2 минутын өмнө",
        "timeRemaining": 180,
        "routeMatch": 85,
      },
      {
        "id": 2,
        "passengerName": "Цэцэгмаа",
        "passengerPhoto":
        "https://images.unsplash.com/photo-1705348153342-2b52db296266",
        "passengerPhotoLabel":
        "Young Mongolian woman with long black hair wearing a red traditional deel, standing in front of mountains",
        "pickupLocation": "Их сургууль",
        "dropoffLocation": "Хан-Уул дүүрэг",
        "distance": 12.3,
        "passengers": 1,
        "price": "18,500",
        "rating": 4.9,
        "requestTime": "5 минутын өмнө",
        "timeRemaining": 120,
        "routeMatch": 92,
      },
      {
        "id": 3,
        "passengerName": "Болдбаатар",
        "passengerPhoto":
        "https://images.unsplash.com/photo-1601833384276-f8b2d26b1170",
        "passengerPhotoLabel":
        "Middle-aged Mongolian man with mustache wearing a brown leather jacket, serious expression",
        "pickupLocation": "Төв зах",
        "dropoffLocation": "Аэропорт",
        "distance": 25.7,
        "passengers": 3,
        "price": "35,000",
        "rating": 4.6,
        "requestTime": "1 минутын өмнө",
        "timeRemaining": 240,
        "routeMatch": 78,
      },
      {
        "id": 4,
        "passengerName": "Оюунчимэг",
        "passengerPhoto":
        "https://images.unsplash.com/photo-1711468964388-bf87076f6846",
        "passengerPhotoLabel":
        "Young Mongolian woman with braided hair wearing a white blouse, smiling warmly at camera",
        "pickupLocation": "Барилгачдын талбай",
        "dropoffLocation": "Сонгинохайрхан дүүрэг",
        "distance": 15.2,
        "passengers": 2,
        "price": "22,000",
        "rating": 4.7,
        "requestTime": "3 минутын өмнө",
        "timeRemaining": 90,
        "routeMatch": 88,
      },
    ];

    setState(() {
      _isLoading = false;
      _applyFilters();
    });
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _handleRefresh();
        _startAutoRefresh();
      }
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allRequests);

    // Apply distance filter
    filtered = filtered.where((request) {
      return (request['distance'] as double) <= _currentFilters['maxDistance'];
    }).toList();

    // Apply rating filter
    filtered = filtered.where((request) {
      return (request['rating'] as double) >= _currentFilters['minRating'];
    }).toList();

    // Apply route match filter
    filtered = filtered.where((request) {
      return (request['routeMatch'] as int) >= _currentFilters['minRouteMatch'];
    }).toList();

    // Apply sorting
    switch (_currentFilters['sortBy']) {
      case 'distance':
        filtered.sort((a, b) =>
            (a['distance'] as double).compareTo(b['distance'] as double));
        break;
      case 'time':
        filtered.sort((a, b) =>
            (b['timeRemaining'] as int).compareTo(a['timeRemaining'] as int));
        break;
      case 'rating':
        filtered.sort(
                (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'price':
        filtered.sort((a, b) {
          final aPrice = int.parse((a['price'] as String).replaceAll(',', ''));
          final bPrice = int.parse((b['price'] as String).replaceAll(',', ''));
          return bPrice.compareTo(aPrice);
        });
        break;
    }

    setState(() {
      _filteredRequests = filtered;
    });
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();
    HapticFeedback.lightImpact();

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));

    // Update time remaining for existing requests
    for (var request in _allRequests) {
      final currentTime = request['timeRemaining'] as int;
      request['timeRemaining'] = (currentTime - 30).clamp(0, 300);
    }

    // Remove expired requests
    _allRequests
        .removeWhere((request) => (request['timeRemaining'] as int) <= 0);

    _refreshController.reverse();
    setState(() {
      _isRefreshing = false;
      _applyFilters();
    });

    HapticFeedback.mediumImpact();
  }

  void _showFilterBottomSheet() {
    _filterController.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
            _applyFilters();
          });
        },
      ),
    ).then((_) {
      _filterController.reverse();
    });
  }

  void _handleAcceptRequest(Map<String, dynamic> request) {
    HapticFeedback.heavyImpact();
    setState(() {
      _allRequests.removeWhere((r) => r['id'] == request['id']);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request['passengerName']}-ийн хүсэлтийг хүлээн авлаа'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        action: SnackBarAction(
          label: 'Дэлгэрэнгүй',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/request-details');
          },
        ),
      ),
    );
  }

  void _handleDeclineRequest(Map<String, dynamic> request) {
    HapticFeedback.heavyImpact();
    setState(() {
      _allRequests.removeWhere((r) => r['id'] == request['id']);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request['passengerName']}-ийн хүсэлтийг татгалзлаа'),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _handleRequestTap(Map<String, dynamic> request) {
    Navigator.pushNamed(context, '/request-details');
  }

  void _showContextMenu(Map<String, dynamic> request, Offset position) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx - 40.w,
            top: position.dy - 20.h,
            child: RequestContextMenuWidget(
              request: request,
              onViewProfile: () {
                Navigator.pop(context);
                _showComingSoonSnackBar('Профайл үзэх');
              },
              onMessagePassenger: () {
                Navigator.pop(context);
                _showComingSoonSnackBar('Мессеж илгээх');
              },
              onReportIssue: () {
                Navigator.pop(context);
                _showComingSoonSnackBar('Асуудал мэдээлэх');
              },
              onDismiss: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature функц удахгүй нэмэгдэнэ'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Ирсэн хүсэлтүүд',
        actions: [
          Stack(
            children: [
              IconButton(
                icon: AnimatedBuilder(
                  animation: _filterAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _filterAnimation.value * 0.5,
                      child: CustomIconWidget(
                        iconName: 'tune',
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                    );
                  },
                ),
                onPressed: _showFilterBottomSheet,
                tooltip: 'Шүүлтүүр',
              ),
              if (_filteredRequests.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 4.w,
                      minHeight: 4.w,
                    ),
                    child: Text(
                      '${_filteredRequests.length}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(theme)
          : _filteredRequests.isEmpty
          ? EmptyStateWidget(onRefresh: _handleRefresh)
          : _buildRequestsList(theme, isDark),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 2,
        variant: BottomBarVariant.driver,
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Хүсэлтүүдийг ачааллаж байна...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          _buildRefreshIndicator(theme),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 1.h,
                bottom: 2.h,
              ),
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                final request = _filteredRequests[index];
                return RequestCardWidget(
                  key: ValueKey(request['id']),
                  request: request,
                  onAccept: () => _handleAcceptRequest(request),
                  onDecline: () => _handleDeclineRequest(request),
                  onTap: () => _handleRequestTap(request),
                  onLongPress: () {
                    final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    _showContextMenu(request, position);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshIndicator(ThemeData theme) {
    return AnimatedBuilder(
      animation: _refreshAnimation,
      builder: (context, child) {
        if (!_isRefreshing) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 4.w,
                height: 4.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Шинэчилж байна...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
