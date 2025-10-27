import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labtest/screen/Auth/login/LoginPage.dart';
import 'package:labtest/screen/Auth/registration/lab_registration_form.dart';
import 'package:labtest/screen/Auth/verification_pending_screen.dart';
import 'package:labtest/screen/dashboard/dashboard.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:labtest/utils/k_debug_print.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: RouteNames.login,
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: RouteNames.labRegistration,
        name: 'labRegistration',
        builder: (context, state) => LabRegistrationForm(),
      ),
      GoRoute(
        path: RouteNames.verificationPending,
        name: 'verificationPending',
        builder: (context, state) => VerificationPendingScreen(),
      ),

      // Dashboard Routes
      GoRoute(
        path: RouteNames.dashboard,
        name: 'dashboard',
        builder: (context, state) => BloodLabHomePage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => BloodLabHomePage(),
      ),

      // Root route redirects to login
      GoRoute(
        path: RouteNames.root,
        name: 'root',
        redirect: (context, state) => RouteNames.login,
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
    redirect: (context, state) {
      KDebugPrint.navigation('Navigating to: ${state.uri}', route: state.name);
      return null;
    },
  );

  static GoRouter get router => _router;
}

class _ErrorPage extends StatelessWidget {
  final Exception? error;

  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Something went wrong!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (error != null)
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.login),
              child: Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
