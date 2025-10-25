import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App Theme Store for managing day/night themes and responsive design
class AppTheme extends ChangeNotifier {
  static final AppTheme _instance = AppTheme._internal();
  factory AppTheme() => _instance;
  AppTheme._internal();

  // Theme state
  bool _isLightTime = true;
  bool get isLightTime => _isLightTime;

  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Theme toggle
  void toggleTheme() {
    _isLightTime = !_isLightTime;
    notifyListeners();
  }

  void setTheme(bool isLight) {
    _isLightTime = isLight;
    notifyListeners();
  }

  // Responsive helper
  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;
  static bool isDesktop(double width) => width >= tabletBreakpoint;

  // Color schemes
  ColorScheme get _lightColorScheme => const ColorScheme.light(
        primary: Color(0xFF1976D2),
        primaryContainer: Color(0xFFE3F2FD),
        secondary: Color(0xFF03DAC6),
        secondaryContainer: Color(0xFFE0F2F1),
        surface: Color(0xFFFFFFFF),
        surfaceContainerHighest: Color(0xFFF5F5F5),
        background: Color(0xFFFAFAFA),
        error: Color(0xFFB00020),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFF1C1B1F),
        onBackground: Color(0xFF1C1B1F),
        onError: Color(0xFFFFFFFF),
        outline: Color(0xFF79747E),
        shadow: Color(0xFF000000),
      );

  ColorScheme get _darkColorScheme => const ColorScheme.dark(
        primary: Color(0xFF1976D2),
        primaryContainer: Color(0xFF1976D2),
        secondary: Color(0xFF03DAC6),
        secondaryContainer: Color(0xFF004D40),
        surface: Color(0xFF121212),
        surfaceContainerHighest: Color(0xFF2C2C2C),
        background: Color(0xFF0F0F0F),
        error: Color(0xFFCF6679),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFFE6E1E5),
        onBackground: Color(0xFFE6E1E5),
        onError: Color(0xFF000000),
        outline: Color(0xFF938F99),
        shadow: Color(0xFF000000),
      );

  // Current color scheme
  ColorScheme get colorScheme =>
      _isLightTime ? _lightColorScheme : _darkColorScheme;

  // App colors
  AppColors get colors => _isLightTime ? AppColors.light : AppColors.dark;

  // Theme data
  ThemeData get themeData => _isLightTime ? _lightTheme : _darkTheme;

  ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        fontFamily: 'uber',
        appBarTheme: AppBarTheme(
          backgroundColor: _lightColorScheme.surface,
          foregroundColor: _lightColorScheme.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'uber',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _lightColorScheme.onSurface,
          ),
        ),
        cardTheme: CardTheme(
          color: _lightColorScheme.surface,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _lightColorScheme.primary,
            foregroundColor: _lightColorScheme.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontFamily: 'uber', fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _lightColorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _lightColorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _lightColorScheme.error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: _lightColorScheme.surface,
          shape: const RoundedRectangleBorder(),
        ),
        listTileTheme: ListTileThemeData(
          textColor: _lightColorScheme.onSurface,
          iconColor: _lightColorScheme.onSurface,
        ),
      );

  ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _darkColorScheme,
        fontFamily: 'uber',
        appBarTheme: AppBarTheme(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'uber',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _darkColorScheme.onSurface,
          ),
        ),
        cardTheme: CardTheme(
          color: _darkColorScheme.surface,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _darkColorScheme.primary,
            foregroundColor: _darkColorScheme.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontFamily: 'uber', fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _darkColorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _darkColorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _darkColorScheme.error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: _darkColorScheme.surface,
          shape: const RoundedRectangleBorder(),
        ),
        listTileTheme: ListTileThemeData(
          textColor: _darkColorScheme.onSurface,
          iconColor: _darkColorScheme.onSurface,
        ),
      );
}

/// App-specific color definitions
class AppColors {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color accent;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;
  final Color success;
  final Color warning;
  final Color info;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color border;
  final Color divider;
  final Color shadow;
  final Color overlay;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.success,
    required this.warning,
    required this.info,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.border,
    required this.divider,
    required this.shadow,
    required this.overlay,
  });

  static const AppColors light = AppColors(
    primary: Color(0xFF1976D2),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    accent: Color(0xFF4CAF50),
    background: Color(0xFFFAFAFA),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1F),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    info: Color(0xFF2196F3),
    textPrimary: Color(0xFF1C1B1F),
    textSecondary: Color(0xFF79747E),
    textDisabled: Color(0xFFBDBDBD),
    border: Color(0xFFE0E0E0),
    divider: Color(0xFFE0E0E0),
    shadow: Color(0x1A000000),
    overlay: Color(0x80000000),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFF1976D2),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    accent: Color(0xFF81C784),
    background: Color(0xFF0F0F0F),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFE6E1E5),
    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF64B5F6),
    textPrimary: Color(0xFFE6E1E5),
    textSecondary: Color(0xFF938F99),
    textDisabled: Color(0xFF616161),
    border: Color(0xFF2C2C2C),
    divider: Color(0xFF2C2C2C),
    shadow: Color(0x33000000),
    overlay: Color(0xCC000000),
  );
}

/// Responsive helper class
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppTheme.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppTheme.mobileBreakpoint &&
        width < AppTheme.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppTheme.tabletBreakpoint;
  }

  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
}
