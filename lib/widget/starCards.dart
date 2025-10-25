import 'package:flutter/material.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color? textColor;
  final IconData? icon;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            )),
          ),
          child: Container(
            width: double.infinity,
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: const EdgeInsets.all(12),
              tablet: const EdgeInsets.all(16),
              desktop: const EdgeInsets.all(20),
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
              border: Border.all(
                color: theme.colors.border.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: textColor ?? theme.colors.textPrimary,
                        size: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 20,
                          tablet: 22,
                          desktop: 24,
                        ),
                      ),
                      SizedBox(
                          width: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 8,
                        tablet: 10,
                        desktop: 12,
                      )),
                    ],
                    Expanded(
                      child: ResponsiveText(
                        title,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'uber',
                          color: textColor ?? theme.colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 8,
                  tablet: 10,
                  desktop: 12,
                )),
                ResponsiveText(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                    fontFamily: 'uber',
                    fontWeight: FontWeight.w700,
                    color: textColor ?? theme.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
