import 'package:flutter/material.dart';
import 'package:labtest/utils/custom_toast.dart';
import 'package:labtest/utils/custom_snackbar.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:go_router/go_router.dart';

/// Demo class showing how to use the custom utilities
class UtilityDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utility Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Toast Examples
            Text('Toast Examples',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      CustomToast.success(context, 'Success message!'),
                  child: Text('Success Toast'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => CustomToast.error(context, 'Error message!'),
                  child: Text('Error Toast'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      CustomToast.warning(context, 'Warning message!'),
                  child: Text('Warning Toast'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => CustomToast.info(context, 'Info message!'),
                  child: Text('Info Toast'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Snackbar Examples
            Text('Snackbar Examples',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      CustomSnackBar.success(context, 'Success snackbar!'),
                  child: Text('Success Snackbar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      CustomSnackBar.error(context, 'Error snackbar!'),
                  child: Text('Error Snackbar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      CustomSnackBar.warning(context, 'Warning snackbar!'),
                  child: Text('Warning Snackbar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      CustomSnackBar.info(context, 'Info snackbar!'),
                  child: Text('Info Snackbar'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Debug Print Examples
            Text('Debug Print Examples',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    KDebugPrint.success('This is a success message');
                    KDebugPrint.error('This is an error message');
                    KDebugPrint.warning('This is a warning message');
                    KDebugPrint.info('This is an info message');
                  },
                  child: Text('Print Debug Messages'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    KDebugPrint.api('API call successful',
                        endpoint: '/api/users');
                    KDebugPrint.navigation('Navigating to dashboard',
                        route: 'dashboard');
                    KDebugPrint.form('Form validation passed',
                        formName: 'login');
                    KDebugPrint.provider('State updated',
                        providerName: 'LoginProvider');
                  },
                  child: Text('Print Tagged Messages'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Navigation Examples
            Text('Navigation Examples',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: Text('Go to Login'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.go(RouteNames.labRegistration),
                  child: Text('Go to Lab Registration'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.go(RouteNames.dashboard),
                  child: Text('Go to Dashboard'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.go(RouteNames.verificationPending),
                  child: Text('Go to Verification'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
