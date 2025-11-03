import 'package:flutter/material.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:go_router/go_router.dart';

class LoginProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form state
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _email;
  String? _password;

  // Getters
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get email => _email;
  String? get password => _password;

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set obscurePassword(bool value) {
    _obscurePassword = value;
    notifyListeners();
  }

  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  set password(String? value) {
    _password = value;
    notifyListeners();
  }

  // Methods
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  bool validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value.length >= 6;
  }

  bool validateForm() {
    return validateEmail(emailController.text) &&
        validatePassword(passwordController.text);
  }

  Future<void> login(BuildContext context) async {
    if (!validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isLoading = true;
    email = emailController.text;
    password = passwordController.text;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      KDebugPrint.success('User logged in successfully');
      // Navigate to dashboard or next screen
      context.go(RouteNames.dashboard);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading = false;
    }
  }

  void forgotPassword(BuildContext context) {
    context.go(RouteNames.forgotPassword);
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _email = null;
    _password = null;
    _obscurePassword = true;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
