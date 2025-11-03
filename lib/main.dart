import 'package:flutter/material.dart';
import 'package:labtest/provider/navigatorprodiver.dart';
import 'package:labtest/provider/lab_registration_provider.dart';
import 'package:labtest/provider/login_provider.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/router/app_router.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

NavigatorProvider navigatorProvider = NavigatorProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KDebugPrint.info('Initializing Blood Lab Management System');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  KDebugPrint.success('Firebase initialized successfully');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigatorProvider()),
        ChangeNotifierProvider(create: (context) => AppTheme()),
        ChangeNotifierProvider(create: (context) => LabRegistrationProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => TestRequestProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return MaterialApp.router(
          title: 'Blood Lab Management System',
          debugShowCheckedModeBanner: false,
          theme: theme.themeData,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  1.0,
                ), // Prevent text scaling on web
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
