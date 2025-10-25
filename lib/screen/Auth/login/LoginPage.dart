import 'package:flutter/material.dart';
import 'package:labtest/screen/Auth/login/loginform.dart';
import 'package:labtest/screen/Auth/registration/Registrationpage.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/widget/Myscaffold.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Myscaffold(
          backgroundColor: theme.colors.background,
          body: Center(
            child: ResponsiveContainer(
              maxWidth: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: double.infinity,
                tablet: 800,
                desktop: 1000,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                )),
                border: Border.all(
                  color: theme.colors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ResponsiveLayout(
                mobile: _buildMobileLayout(context, theme),
                tablet: _buildTabletLayout(context, theme),
                desktop: _buildDesktopLayout(context, theme),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppTheme theme) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.all(20.0),
        tablet: const EdgeInsets.all(24.0),
        desktop: const EdgeInsets.all(32.0),
      ),
      child: Column(
        children: [
          // Logo/Title for mobile
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colors.primary,
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
            ),
            child: ResponsiveText(
              'Blood Lab',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
                fontFamily: 'uber',
                color: theme.colors.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
              height: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 32,
          )),
          LoginForm(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AppTheme theme) {
    return _buildDesktopLayout(context, theme);
  }

  Widget _buildDesktopLayout(BuildContext context, AppTheme theme) {
    return Row(
      children: [
        // Left side - Branding
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                )),
                bottomLeft: Radius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                )),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services,
                    size: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 60,
                      tablet: 80,
                      desktop: 100,
                    ),
                    color: theme.colors.onPrimary,
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 32,
                  )),
                  ResponsiveText(
                    'Blood Lab',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 36,
                      ),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'uber',
                      color: theme.colors.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  )),
                  ResponsiveText(
                    'Professional Laboratory Management',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                      fontFamily: 'uber',
                      color: theme.colors.onPrimary.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Right side - Login Form
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: const EdgeInsets.all(20.0),
              tablet: const EdgeInsets.all(24.0),
              desktop: const EdgeInsets.all(32.0),
            ),
            child: LoginForm(),
          ),
        ),
      ],
    );
  }
}
