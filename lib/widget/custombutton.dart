import 'package:flutter/material.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

class Custombutton extends StatelessWidget {
  const Custombutton({
    super.key,
    this.onTap,
    required this.text,
    this.width,
    this.height,
    this.fontSize,
  });

  final void Function()? onTap;
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: height ??
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 40,
                  tablet: 44,
                  desktop: 48,
                ),
            width: width ??
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 180,
                  tablet: 200,
                  desktop: 220,
                ),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
              color: theme.colors.primary,
              boxShadow: [
                BoxShadow(
                  color: theme.colors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: ResponsiveText(
                text,
                style: TextStyle(
                  color: theme.colors.onPrimary,
                  fontFamily: "uber",
                  fontSize: fontSize ??
                      ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
