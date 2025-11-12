import 'package:flutter/material.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/provider/login_provider.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Consumer2<AppTheme, LoginProvider>(
        builder: (context, theme, provider, child) {
          return Form(
            key: provider.formKey,
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
                  controller: provider.emailController,
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
                    if (!provider.validateEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => provider.email = value,
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
                  controller: provider.passwordController,
                  hintText: 'Password',
                  labelText: 'Password',
                  obscureText: provider.obscurePassword,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: theme.colors.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: theme.colors.textSecondary,
                    ),
                    onPressed: () => provider.togglePasswordVisibility(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!provider.validatePassword(value)) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => provider.password = value,
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
                    onPressed: () => provider.forgotPassword(context),
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
                  onTap:
                      provider.isLoading ? null : () => provider.login(context),
                  text: provider.isLoading ? "Signing In..." : "Sign In",
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
                        context.go(RouteNames.labRegistration);
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
      ),
    );
  }
}
