import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labtest/models/lab_registration_model.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:labtest/utils/route_names.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _mockEmail = 'mock.lab@gmail.com';
  static const String _mockPassword = 'MockPass@123';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    if (_isLoading == value) return;
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

  bool _validateForm(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null) {
      return false;
    }
    if (!formState.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the highlighted fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    formState.save();
    return true;
  }

  Future<void> login(BuildContext context) async {
    if (isLoading) return;

    if (!_validateForm(context)) {
      return;
    }

    final trimmedEmail = emailController.text.trim();
    final trimmedPassword = passwordController.text.trim();

    isLoading = true;
    email = trimmedEmail;
    password = trimmedPassword;

    try {
      if (_isMockCredentials(trimmedEmail, trimmedPassword)) {
        await _handleMockLogin(context);
        return;
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Authentication succeeded without a user object.',
        );
      }

      LabRegistration? registration;
      try {
        final snapshot = await _firestore
            .collection(LabRegistration.collectionName)
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          registration = LabRegistration.fromFirestore(snapshot);
        } else {
          KDebugPrint.warning(
            'No lab registration found for uid ${user.uid}',
          );
        }
      } on FirebaseException catch (firestoreError) {
        KDebugPrint.error(
          'Failed to fetch lab registration: ${firestoreError.message}',
        );
      }

      final status = registration?.status ?? LabRegistrationStatus.underReview;
      final emailVerified =
          user.emailVerified || registration?.emailVerified == true;

      if (!emailVerified) {
        try {
          await user.sendEmailVerification();
        } catch (verificationError) {
          KDebugPrint.warning(
            'Unable to resend verification email: $verificationError',
          );
        }
      }

      if (status == LabRegistrationStatus.approved && emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome back!'),
            backgroundColor: Colors.green,
          ),
        );
        KDebugPrint.success('User ${user.uid} logged in successfully');
        context.go(RouteNames.dashboard);
      } else {
        final pendingMessage = status == LabRegistrationStatus.rejected
            ? 'Your registration was rejected. Please contact support.'
            : 'We are still reviewing your registration. Check your email for updates.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(pendingMessage),
            backgroundColor: Colors.orange,
          ),
        );

        context.go(RouteNames.verificationPending);
      }
    } on FirebaseAuthException catch (authError) {
      final message = _mapAuthErrorToMessage(authError);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
      KDebugPrint.error('Login failed: ${authError.code}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
      KDebugPrint.error('Unexpected login error: $e');
    } finally {
      isLoading = false;
    }
  }

  void forgotPassword(BuildContext context) {
    context.go(RouteNames.forgotPassword);
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      KDebugPrint.warning('Failed to sign out: $e');
    }
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

  String _mapAuthErrorToMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is invalid. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support for help.';
      case 'user-not-found':
        return 'We couldn\'t find an account with that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'We couldn\'t sign you in. Please try again.';
    }
  }

  bool _isMockCredentials(String email, String password) {
    return email.toLowerCase() == _mockEmail.toLowerCase() &&
        password == _mockPassword;
  }

  Future<void> _handleMockLogin(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in with mock account (demo mode).'),
        backgroundColor: Colors.green,
      ),
    );
    KDebugPrint.info('Mock login successful for $_mockEmail');
    clearForm();
    context.go(RouteNames.dashboard);
  }
}
