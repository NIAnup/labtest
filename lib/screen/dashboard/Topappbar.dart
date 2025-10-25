import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

// Top bar with user info, date, etc.

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Container(
          color: theme.colors.surface,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
            vertical: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      '${getGreeting()}, Dr. Anup Singh',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                        fontFamily: "uber",
                        fontWeight: FontWeight.bold,
                        color: theme.colors.textPrimary,
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 4,
                      tablet: 6,
                      desktop: 8,
                    )),
                    ResponsiveText(
                      'Welcome back to your dashboard',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                        fontFamily: "uber",
                        color: theme.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveText(
                'Today: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  fontFamily: "uber",
                  color: theme.colors.textSecondary,
                ),
              ),
              SizedBox(
                  width: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              )),
              Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: theme.colors.textPrimary,
                    size: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 8,
                        tablet: 10,
                        desktop: 12,
                      ),
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 8,
                        tablet: 10,
                        desktop: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              )),
              CircleAvatar(
                radius: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                backgroundColor: theme.colors.primary,
                child: Icon(
                  Icons.person,
                  color: theme.colors.onPrimary,
                  size: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
