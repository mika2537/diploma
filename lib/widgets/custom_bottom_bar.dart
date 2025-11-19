import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom BottomNavigationBar widget for ride-sharing driver application
/// Implements Professional Mobility design with Trust Blue Foundation
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomBarVariant variant;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = BottomBarVariant.driver,
    this.showLabels = true,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late List<BottomNavigationBarItem> _items;

  @override
  void initState() {
    super.initState();
    _items = _getNavigationItems();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(colorScheme, isDark),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: _handleTap,
          items: _items,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: _getSelectedColor(colorScheme),
          unselectedItemColor: _getUnselectedColor(colorScheme, isDark),
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          showSelectedLabels: widget.showLabels,
          showUnselectedLabels: widget.showLabels,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems() {
    switch (widget.variant) {
      case BottomBarVariant.driver:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route),
            label: 'Routes',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Requests',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
        ];
      case BottomBarVariant.minimal:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi_outlined),
            activeIcon: Icon(Icons.local_taxi),
            label: 'Rides',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
    }
  }

  void _handleTap(int index) {
    if (index == widget.currentIndex) return;

    // Provide haptic feedback for better user experience
    HapticFeedback.lightImpact();

    // Handle navigation based on index and variant
    _navigateToScreen(index);

    // Call the provided onTap callback
    widget.onTap?.call(index);
  }

  void _navigateToScreen(int index) {
    final context = this.context;

    switch (widget.variant) {
      case BottomBarVariant.driver:
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/driver-dashboard',
                  (route) => false,
            );
            break;
          case 1:
            Navigator.pushNamed(context, '/create-route');
            break;
          case 2:
            Navigator.pushNamed(context, '/incoming-requests');
            break;
          case 3:
          // Navigate to earnings screen - placeholder
            _showComingSoonSnackBar('Earnings screen');
            break;
        }
        break;
      case BottomBarVariant.minimal:
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/driver-dashboard',
                  (route) => false,
            );
            break;
          case 1:
            Navigator.pushNamed(context, '/incoming-requests');
            break;
          case 2:
          // Navigate to profile screen - placeholder
            _showComingSoonSnackBar('Profile screen');
            break;
        }
        break;
    }
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isDark) {
    return isDark ? colorScheme.surface : colorScheme.surface;
  }

  Color _getSelectedColor(ColorScheme colorScheme) {
    return colorScheme.primary;
  }

  Color _getUnselectedColor(ColorScheme colorScheme, bool isDark) {
    return isDark
        ? colorScheme.onSurface.withValues(alpha: 0.6)
        : colorScheme.onSurface.withValues(alpha: 0.6);
  }
}

/// Enum for different BottomBar variants
enum BottomBarVariant {
  driver,
  minimal,
}

/// Custom BottomNavigationBar item with enhanced styling
class CustomBottomBarItem extends BottomNavigationBarItem {
  final bool showBadge;
  final String? badgeText;
  final Color? badgeColor;

  const CustomBottomBarItem({
    required super.icon,
    super.label,
    super.activeIcon,
    super.backgroundColor,
    super.tooltip,
    this.showBadge = false,
    this.badgeText,
    this.badgeColor,
  });

  @override
  Widget get icon {
    if (!showBadge) return super.icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        super.icon,
        if (showBadge)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeText ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
