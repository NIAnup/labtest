import 'package:flutter/material.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:labtest/provider/lab_registration_provider.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, LabRegistrationProvider>(
      builder: (context, theme, provider, child) {
        return Form(
          key: provider.formKey,
          child: Column(
            children: [
              // First Name
              Customtextfield(
                controller: provider.labNameController,
                hintText: 'Lab Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter lab name'
                    : null,
              ),

              const SizedBox(height: 16),
              // Owner Name
              Customtextfield(
                controller: provider.ownerNameController,
                hintText: 'Owner Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter owner name'
                    : null,
              ),
              const SizedBox(height: 16),
              // Contact Number
              Customtextfield(
                controller: provider.contactNumberController,
                hintText: 'Contact Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  if (!RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(value)) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email
              Customtextfield(
                controller: provider.emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password
              Customtextfield(
                controller: provider.passwordController,
                hintText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Confirm Password
              Customtextfield(
                controller: provider.confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm password';
                  }
                  if (value != provider.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Sign Up Button
              Custombutton(
                onTap: () {
                  if (provider.formKey.currentState?.validate() ?? false) {
                    context.go(RouteNames.labRegistration);
                  }
                },
                text: 'Lab Registration',
              ),
              const SizedBox(height: 24),
              TextButton(
                style: TextButton.styleFrom(
                    elevation: 0, foregroundColor: Colors.white),
                onPressed: () {
                  // Navigate to login page
                  context.go(RouteNames.login);
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                      color: Colors.black, fontFamily: "uber", fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
