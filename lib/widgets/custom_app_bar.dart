import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for ride-sharing driver application
/// Implements Professional Mobility design with Trust Blue Foundation
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final AppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 1.0,
    this.centerTitle = true,
    this.bottom,
    this.variant = AppBarVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor:
      backgroundColor ?? _getBackgroundColor(colorScheme, isDark),
      foregroundColor:
      foregroundColor ?? _getForegroundColor(colorScheme, isDark),
      elevation: elevation,
      shadowColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.05),
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      bottom: bottom,
      systemOverlayStyle: _getSystemOverlayStyle(isDark),
      titleSpacing: leading == null && !showBackButton ? 16.0 : null,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (variant) {
      case AppBarVariant.dashboard:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_taxi,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _getForegroundColor(theme.colorScheme, isDark),
              ),
            ),
          ],
        );
      case AppBarVariant.earnings:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _getForegroundColor(theme.colorScheme, isDark),
              ),
            ),
          ],
        );
      case AppBarVariant.standard:
      default:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _getForegroundColor(theme.colorScheme, isDark),
          ),
        );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    switch (variant) {
      case AppBarVariant.dashboard:
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _navigateToNotifications(context),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => _navigateToProfile(context),
            tooltip: 'Profile',
          ),
          const SizedBox(width: 8),
        ];
      case AppBarVariant.earnings:
        return [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _navigateToEarningsHistory(context),
            tooltip: 'Earnings History',
          ),
          const SizedBox(width: 8),
        ];
      default:
        return null;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isDark) {
    switch (variant) {
      case AppBarVariant.dashboard:
        return isDark ? colorScheme.surface : colorScheme.surface;
      case AppBarVariant.earnings:
        return isDark ? colorScheme.surface : colorScheme.surface;
      default:
        return isDark ? colorScheme.surface : colorScheme.surface;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme, bool isDark) {
    return isDark ? colorScheme.onSurface : colorScheme.onSurface;
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(bool isDark) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );
  }

  void _navigateToNotifications(BuildContext context) {
    // Navigate to notifications - placeholder for future implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications feature coming soon')),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  void _navigateToEarningsHistory(BuildContext context) {
    // Navigate to earnings history - placeholder for future implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Earnings history feature coming soon')),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
  );
}

/// Enum for different AppBar variants
enum AppBarVariant {
  standard,
  dashboard,
  earnings,
}
