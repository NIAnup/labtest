import 'package:flutter/material.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

import '../registration/Registrationpage.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome text
              ResponsiveText(
                'Welcome Back',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  fontFamily: "uber",
                  fontWeight: FontWeight.bold,
                  color: theme.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
              ResponsiveText(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                  fontFamily: "uber",
                  color: theme.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              )),
              // Email field
              Customtextfield(
                hintText: 'Email',
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
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              )),
              // Password field
              Customtextfield(
                hintText: 'Password',
                labelText: 'Password',
                obscureText: true,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: theme.colors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: ResponsiveText(
                          'Forgot password functionality coming soon',
                          style: TextStyle(
                            color: theme.colors.onError,
                            fontFamily: 'uber',
                          ),
                        ),
                        backgroundColor: theme.colors.error,
                      ),
                    );
                  },
                  child: ResponsiveText(
                    'Forgot Password?',
                    style: TextStyle(
                      color: theme.colors.primary,
                      fontFamily: "uber",
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              )),
              // Sign in button
              Custombutton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Show loading indicator
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: ResponsiveText(
                          'Logging in...',
                          style: TextStyle(
                            color: theme.colors.onPrimary,
                            fontFamily: 'uber',
                          ),
                        ),
                        backgroundColor: theme.colors.primary,
                      ),
                    );
                  }
                },
                text: "Sign In",
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              )),
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: theme.colors.divider,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                    ),
                    child: ResponsiveText(
                      'OR',
                      style: TextStyle(
                        color: theme.colors.textSecondary,
                        fontFamily: "uber",
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: theme.colors.divider,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              )),
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveText(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      color: theme.colors.textSecondary,
                      fontFamily: "uber",
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()),
                      );
                    },
                    child: ResponsiveText(
                      'Sign Up',
                      style: TextStyle(
                        color: theme.colors.primary,
                        fontFamily: "uber",
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
