import 'package:flutter/material.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class VerificationPendingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Scaffold(
            backgroundColor: theme.colors.background,
            body: SafeArea(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: double.infinity,
                      tablet: 800,
                      desktop: 1000,
                    ),
                  ),
                  padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 16,
                    tablet: 24,
                    desktop: 32,
                  )),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 80,
                            tablet: 100,
                            desktop: 120,
                          ),
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 80,
                            tablet: 100,
                            desktop: 120,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.hourglass_empty,
                            size: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 40,
                              tablet: 50,
                              desktop: 60,
                            ),
                            color: theme.colors.primary,
                          ),
                        ),

                        SizedBox(height: 32),

                        // Title
                        ResponsiveText(
                          'Verification Pending',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                            fontWeight: FontWeight.bold,
                            color: theme.colors.textPrimary,
                            fontFamily: 'uber',
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16),

                        // Subtitle
                        ResponsiveText(
                          'Your details are under review. You\'ll be notified after verification.',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                            color: theme.colors.textSecondary,
                            fontFamily: 'uber',
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 32),

                        // Status Card
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: theme.colors.primary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  ResponsiveText(
                                    'Current Status',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper
                                          .getResponsiveFontSize(
                                        context,
                                        mobile: 16,
                                        tablet: 18,
                                        desktop: 20,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      color: theme.colors.textPrimary,
                                      fontFamily: 'uber',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              ResponsiveText(
                                'Under Review',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 18,
                                    tablet: 20,
                                    desktop: 22,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: theme.colors.primary,
                                  fontFamily: 'uber',
                                ),
                              ),
                              SizedBox(height: 8),
                              ResponsiveText(
                                'Our team is reviewing your submitted documents and information. This process typically takes 2-3 business days.',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18,
                                  ),
                                  color: theme.colors.textSecondary,
                                  fontFamily: 'uber',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32),

                        // What happens next section
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveText(
                                'What happens next?',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 16,
                                    tablet: 18,
                                    desktop: 20,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  color: theme.colors.textPrimary,
                                  fontFamily: 'uber',
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildStepItem(
                                context,
                                theme,
                                '1',
                                'Document Verification',
                                'We verify all your submitted documents and certificates.',
                              ),
                              SizedBox(height: 12),
                              _buildStepItem(
                                context,
                                theme,
                                '2',
                                'Business Validation',
                                'We validate your business registration and GST details.',
                              ),
                              SizedBox(height: 12),
                              _buildStepItem(
                                context,
                                theme,
                                '3',
                                'License Verification',
                                'We verify your clinical establishment license.',
                              ),
                              SizedBox(height: 12),
                              _buildStepItem(
                                context,
                                theme,
                                '4',
                                'Approval Notification',
                                'You\'ll receive an email notification once approved.',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32),

                        // Contact support button
                        Custombutton(
                          text: 'Contact Support',
                          onTap: () {
                            // Navigate to support or open email
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Support contact: support@labtest.com'),
                                action: SnackBarAction(
                                  label: 'Copy',
                                  onPressed: () {
                                    // Copy email to clipboard
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 16),

                        // Logout button
                        TextButton(
                          onPressed: () {
                            // Logout and return to login
                            context.go(RouteNames.login);
                          },
                          child: ResponsiveText(
                            'Logout',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 20,
                              ),
                              color: theme.colors.textSecondary,
                              fontFamily: 'uber',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildStepItem(
    BuildContext context,
    AppTheme theme,
    String stepNumber,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ResponsiveText(
              stepNumber,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                fontWeight: FontWeight.bold,
                color: theme.colors.onPrimary,
                fontFamily: 'uber',
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                  fontWeight: FontWeight.w600,
                  color: theme.colors.textPrimary,
                  fontFamily: 'uber',
                ),
              ),
              SizedBox(height: 4),
              ResponsiveText(
                description,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  color: theme.colors.textSecondary,
                  fontFamily: 'uber',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
