import 'package:flutter/material.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';

class CustomToast {
  static OverlayEntry? _overlayEntry;

  /// Show success toast
  static void success(BuildContext context, String message,
      {Duration? duration}) {
    _showToast(
      context,
      message,
      ToastType.success,
      duration: duration,
    );
  }

  /// Show error toast
  static void error(BuildContext context, String message,
      {Duration? duration}) {
    _showToast(
      context,
      message,
      ToastType.error,
      duration: duration,
    );
  }

  /// Show warning toast
  static void warning(BuildContext context, String message,
      {Duration? duration}) {
    _showToast(
      context,
      message,
      ToastType.warning,
      duration: duration,
    );
  }

  /// Show info toast
  static void info(BuildContext context, String message, {Duration? duration}) {
    _showToast(
      context,
      message,
      ToastType.info,
      duration: duration,
    );
  }

  /// Show custom toast
  static void custom(
    BuildContext context,
    String message,
    ToastType type, {
    Duration? duration,
    IconData? icon,
  }) {
    _showToast(
      context,
      message,
      type,
      duration: duration,
      icon: icon,
    );
  }

  /// Hide current toast
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void _showToast(
    BuildContext context,
    String message,
    ToastType type, {
    Duration? duration,
    IconData? icon,
  }) {
    // Hide existing toast
    hide();

    final theme = Provider.of<AppTheme>(context, listen: false);
    final toastDuration = duration ?? Duration(seconds: 3);

    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        theme: theme,
        icon: icon,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Auto hide after duration
    Future.delayed(toastDuration, () {
      hide();
    });
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final AppTheme theme;
  final IconData? icon;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.theme,
    this.icon,
  });

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    if (widget.icon != null) return widget.icon!;

    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
                vertical: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 8,
                  tablet: 10,
                  desktop: 12,
                )),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
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
                      widget.message,
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
                  GestureDetector(
                    onTap: () => CustomToast.hide(),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
