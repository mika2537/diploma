import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the ride-sharing driver application.
/// Implements Professional Mobility design with Trust Blue Foundation color scheme.
class AppTheme {
  AppTheme._();

  // Trust Blue Foundation - Core Colors
  static const Color primaryBlue = Color(0xFF0A73FF);
  static const Color secondaryGray = Color(0xFF6C7B7F);
  static const Color successGreen = Color(0xFF00C851);
  static const Color warningOrange = Color(0xFFFF8800);
  static const Color errorRed = Color(0xFFFF4444);
  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color onSurfaceBlack = Color(0xFF1A1A1A);
  static const Color onPrimaryWhite = Color(0xFFFFFFFF);
  static const Color accentBlue = Color(0xFFE8F4FD);

  // Dark theme variations
  static const Color primaryBlueDark = Color(0xFF4A9AFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Color(0xFFE0E0E0);
  static const Color cardDark = Color(0xFF2D2D2D);

  // Functional colors
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF404040);
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x1AFFFFFF);
  static const Color dividerLight = Color(0x1F000000);
  static const Color dividerDark = Color(0x1FFFFFFF);

  // Text emphasis levels
  static const Color textHighEmphasisLight = Color(0xDE000000); // 87% opacity
  static const Color textMediumEmphasisLight = Color(0x99000000); // 60% opacity
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasisDark = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  /// Light theme optimized for daytime driving conditions
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: onPrimaryWhite,
      primaryContainer: accentBlue,
      onPrimaryContainer: primaryBlue,
      secondary: secondaryGray,
      onSecondary: onPrimaryWhite,
      secondaryContainer: secondaryGray.withValues(alpha: 0.1),
      onSecondaryContainer: secondaryGray,
      tertiary: successGreen,
      onTertiary: onPrimaryWhite,
      tertiaryContainer: successGreen.withValues(alpha: 0.1),
      onTertiaryContainer: successGreen,
      error: errorRed,
      onError: onPrimaryWhite,
      surface: surfaceWhite,
      onSurface: onSurfaceBlack,
      onSurfaceVariant: secondaryGray,
      outline: borderLight,
      outlineVariant: borderLight.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: surfaceDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: primaryBlueDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceWhite,
    dividerColor: dividerLight,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceWhite,
      foregroundColor: onSurfaceBlack,
      elevation: 1.0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurfaceBlack,
      ),
      iconTheme: const IconThemeData(
        color: onSurfaceBlack,
        size: 24,
      ),
    ),
    cardTheme: CardThemeData (
      color: surfaceWhite,
      elevation: 2.0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceWhite,
      selectedItemColor: primaryBlue,
      unselectedItemColor: secondaryGray,
      elevation: 4.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: onPrimaryWhite,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryWhite,
        backgroundColor: primaryBlue,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: secondaryGray,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textMediumEmphasisLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorRed,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return secondaryGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue.withValues(alpha: 0.3);
        }
        return secondaryGray.withValues(alpha: 0.2);
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryWhite),
      side: const BorderSide(color: borderLight, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlue;
        }
        return secondaryGray;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: accentBlue,
      circularTrackColor: accentBlue,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withValues(alpha: 0.2),
      inactiveTrackColor: accentBlue,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primaryBlue,
      unselectedLabelColor: secondaryGray,
      indicatorColor: primaryBlue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceBlack.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceWhite,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceBlack,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceWhite,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceWhite),
  );

  /// Dark theme optimized for nighttime driving conditions
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlueDark,
      onPrimary: onSurfaceBlack,
      primaryContainer: primaryBlue.withValues(alpha: 0.2),
      onPrimaryContainer: primaryBlueDark,
      secondary: secondaryGray,
      onSecondary: onSurfaceBlack,
      secondaryContainer: secondaryGray.withValues(alpha: 0.2),
      onSecondaryContainer: secondaryGray,
      tertiary: successGreen,
      onTertiary: onSurfaceBlack,
      tertiaryContainer: successGreen.withValues(alpha: 0.2),
      onTertiaryContainer: successGreen,
      error: errorRed,
      onError: onPrimaryWhite,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: secondaryGray,
      outline: borderDark,
      outlineVariant: borderDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceWhite,
      onInverseSurface: onSurfaceBlack,
      inversePrimary: primaryBlue,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: onSurfaceDark,
      elevation: 1.0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurfaceDark,
      ),
      iconTheme: const IconThemeData(
        color: onSurfaceDark,
        size: 24,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryBlueDark,
      unselectedItemColor: secondaryGray,
      elevation: 4.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlueDark,
      foregroundColor: onSurfaceBlack,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onSurfaceBlack,
        backgroundColor: primaryBlueDark,
        elevation: 2.0,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlueDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryBlueDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlueDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryBlueDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: secondaryGray,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textMediumEmphasisDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorRed,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlueDark;
        }
        return secondaryGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlueDark.withValues(alpha: 0.3);
        }
        return secondaryGray.withValues(alpha: 0.2);
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlueDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onSurfaceBlack),
      side: const BorderSide(color: borderDark, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryBlueDark;
        }
        return secondaryGray;
      }),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryBlueDark,
      linearTrackColor: primaryBlue.withValues(alpha: 0.2),
      circularTrackColor: primaryBlue.withValues(alpha: 0.2),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlueDark,
      thumbColor: primaryBlueDark,
      overlayColor: primaryBlueDark.withValues(alpha: 0.2),
      inactiveTrackColor: primaryBlue.withValues(alpha: 0.2),
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primaryBlueDark,
      unselectedLabelColor: secondaryGray,
      indicatorColor: primaryBlueDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceDark,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryBlueDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: cardDark,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: cardDark),
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for consistent readability across all text elements
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
    isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
    isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Title styles for card headers and important text
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles for buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Data text style using SF Mono for earnings and numerical information
  static TextStyle dataTextStyle({
    required bool isLight,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor =
    isLight ? textHighEmphasisLight : textHighEmphasisDark;
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0.5,
    );
  }

  /// Status colors for driver application states
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
      case 'active':
      case 'completed':
        return successGreen;
      case 'pending':
      case 'waiting':
        return warningOrange;
      case 'offline':
      case 'cancelled':
      case 'error':
        return errorRed;
      default:
        return secondaryGray;
    }
  }

  /// Elevation values following Material Design 3 guidelines
  static const double elevationLevel1 = 1.0;
  static const double elevationLevel2 = 2.0;
  static const double elevationLevel3 = 4.0;
  static const double elevationLevel4 = 8.0;

  /// Border radius values for consistent UI elements
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
}
