import 'package:flutter/material.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/provider/forgot_password_provider.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    await provider.sendPasswordResetEmail(_emailController.text, context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordProvider(),
      child: Consumer2<AppTheme, ForgotPasswordProvider>(
        builder: (context, theme, provider, child) {
          return Scaffold(
            backgroundColor: theme.colors.background,
            body: SafeArea(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: double.infinity,
                      tablet: 500,
                      desktop: 600,
                    ),
                  ),
                  padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 32,
                  )),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => context.go(RouteNames.login),
                            icon: Icon(
                              Icons.arrow_back,
                              color: theme.colors.textPrimary,
                              size: ResponsiveHelper.getResponsiveValue(
                                context,
                                mobile: 24,
                                tablet: 28,
                                desktop: 32,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

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
                            Icons.lock_reset,
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
                          provider.emailSent
                              ? 'Check Your Email'
                              : 'Forgot Password?',
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
                          provider.emailSent
                              ? 'We\'ve sent a password reset link to ${_emailController.text}'
                              : 'Enter your email address and we\'ll send you a link to reset your password.',
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

                        if (!provider.emailSent) ...[
                          // Email form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Customtextfield(
                                  controller: _emailController,
                                  hintText: 'Enter your email address',
                                  labelText: 'Email Address',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: theme.colors.textSecondary,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!provider.validateEmail(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24),
                                Custombutton(
                                  onTap: provider.isLoading
                                      ? null
                                      : _sendResetEmail,
                                  text: provider.isLoading
                                      ? 'Sending...'
                                      : 'Send Reset Link',
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Success state
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
                                Icon(
                                  Icons.mark_email_read,
                                  size: ResponsiveHelper.getResponsiveValue(
                                    context,
                                    mobile: 48,
                                    tablet: 56,
                                    desktop: 64,
                                  ),
                                  color: Colors.green,
                                ),
                                SizedBox(height: 16),
                                ResponsiveText(
                                  'Email Sent Successfully',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 18,
                                      tablet: 20,
                                      desktop: 22,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    color: theme.colors.textPrimary,
                                    fontFamily: 'uber',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                ResponsiveText(
                                  'Please check your email inbox and follow the instructions to reset your password.',
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
                          SizedBox(height: 24),
                          Custombutton(
                            onTap: () => context.go(RouteNames.login),
                            text: 'Back to Login',
                            width: double.infinity,
                          ),
                        ],

                        SizedBox(height: 24),

                        // Help text
                        if (!provider.emailSent) ...[
                          ResponsiveText(
                            'Remember your password?',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                              color: theme.colors.textSecondary,
                              fontFamily: 'uber',
                            ),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.go(RouteNames.login),
                            child: ResponsiveText(
                              'Sign In',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 16,
                                  desktop: 18,
                                ),
                                color: theme.colors.primary,
                                fontFamily: 'uber',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ] else ...[
                          // Resend email option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ResponsiveText(
                                'Didn\'t receive the email? ',
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
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.resetState();
                                },
                                child: ResponsiveText(
                                  'Resend',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 18,
                                    ),
                                    color: theme.colors.primary,
                                    fontFamily: 'uber',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 32),

                        // Contact support
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.help_outline,
                                color: theme.colors.primary,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ResponsiveText(
                                  'Need help? Contact our support team',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 12,
                                      tablet: 14,
                                      desktop: 16,
                                    ),
                                    color: theme.colors.textSecondary,
                                    fontFamily: 'uber',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Support: support@labtest.com'),
                                      action: SnackBarAction(
                                        label: 'Copy',
                                        onPressed: () {
                                          // Copy email to clipboard
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: ResponsiveText(
                                  'Contact',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 12,
                                      tablet: 14,
                                      desktop: 16,
                                    ),
                                    color: theme.colors.primary,
                                    fontFamily: 'uber',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
