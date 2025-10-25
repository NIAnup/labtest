import 'package:flutter/material.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 6,
              tablet: 6,
              desktop: 8,
            ),
            vertical: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 2,
              tablet: 3,
              desktop: 4,
            ),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colors.success.withOpacity(0.15)
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 6,
              tablet: 8,
              desktop: 10,
            )),
            border: isSelected
                ? Border.all(
                    color: theme.colors.success.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                  vertical: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 8,
                    tablet: 12,
                    desktop: 16,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? theme.colors.success
                          : theme.colors.textPrimary,
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
                      mobile: 12,
                      tablet: 16,
                      desktop: 20,
                    )),
                    Expanded(
                      child: ResponsiveText(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? theme.colors.success
                              : theme.colors.textPrimary,
                          fontFamily: 'uber',
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 4,
                          tablet: 5,
                          desktop: 6,
                        ),
                        height: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colors.onError,
                          borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 2,
                            tablet: 3,
                            desktop: 4,
                          )),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
