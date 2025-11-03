import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labtest/utils/k_debug_print.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;
  bool _emailSent = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get emailSent => _emailSent;

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  set emailSent(bool value) {
    _emailSent = value;
    notifyListeners();
  }

  // Methods
  bool validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    if (!validateEmail(email)) {
      errorMessage = 'Please enter a valid email address';
      return;
    }

    isLoading = true;
    errorMessage = null;

    try {
      await _auth.sendPasswordResetEmail(email: email);

      emailSent = true;
      KDebugPrint.success('Password reset email sent to: $email');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = _getFirebaseErrorMessage(e.code);
      errorMessage = errorMsg;

      KDebugPrint.error('Password reset failed: ${e.code} - ${e.message}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      errorMessage = 'An unexpected error occurred. Please try again.';

      KDebugPrint.error('Unexpected error during password reset: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoading = false;
    }
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Failed to send reset email. Please try again.';
    }
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    _emailSent = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
