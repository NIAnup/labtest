import 'package:flutter/material.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';

class CustomSnackBar {
  /// Show success snackbar
  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool showCloseIcon = true,
  }) {
    _showSnackBar(
      context,
      message,
      SnackBarType.success,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Show error snackbar
  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool showCloseIcon = true,
  }) {
    _showSnackBar(
      context,
      message,
      SnackBarType.error,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Show warning snackbar
  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool showCloseIcon = true,
  }) {
    _showSnackBar(
      context,
      message,
      SnackBarType.warning,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Show info snackbar
  static void info(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool showCloseIcon = true,
  }) {
    _showSnackBar(
      context,
      message,
      SnackBarType.info,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Show custom snackbar
  static void custom(
    BuildContext context,
    String message,
    SnackBarType type, {
    Duration? duration,
    SnackBarAction? action,
    bool showCloseIcon = true,
    IconData? icon,
  }) {
    _showSnackBar(
      context,
      message,
      type,
      duration: duration,
      action: action,
      showCloseIcon: showCloseIcon,
      icon: icon,
    );
  }

  /// Show loading snackbar
  static void loading(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      SnackBarType.loading,
      duration: Duration(hours: 1), // Long duration for loading
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    SnackBarType type, {
    Duration? duration,
    SnackBarAction? action,
    bool showCloseIcon = true,
    IconData? icon,
  }) {
    final theme = Provider.of<AppTheme>(context, listen: false);
    final snackDuration = duration ?? Duration(seconds: 4);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _SnackBarContent(
          message: message,
          type: type,
          theme: theme,
          icon: icon,
        ),
        backgroundColor: _getBackgroundColor(type),
        duration: snackDuration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          )),
        ),
        margin: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        )),
        showCloseIcon: showCloseIcon,
        closeIconColor: Colors.white,
      ),
    );
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.info:
        return Colors.blue;
      case SnackBarType.loading:
        return Colors.grey[800]!;
    }
  }
}

enum SnackBarType {
  success,
  error,
  warning,
  info,
  loading,
}

class _SnackBarContent extends StatelessWidget {
  final String message;
  final SnackBarType type;
  final AppTheme theme;
  final IconData? icon;

  const _SnackBarContent({
    required this.message,
    required this.type,
    required this.theme,
    this.icon,
  });

  IconData _getIcon() {
    if (icon != null) return icon!;

    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.warning:
        return Icons.warning;
      case SnackBarType.info:
        return Icons.info;
      case SnackBarType.loading:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (type == SnackBarType.loading)
          SizedBox(
            width: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
            height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else
          Icon(
            _getIcon(),
            color: Colors.white,
            size: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
        SizedBox(width: 12),
        Expanded(
          child: ResponsiveText(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
              fontWeight: FontWeight.w500,
              fontFamily: 'uber',
            ),
          ),
        ),
      ],
    );
  }
}
