import 'package:flutter/material.dart';
import 'package:labtest/provider/navigatorprodiver.dart';
import 'package:labtest/screen/Auth/registration/Registrationpage.dart';
import 'package:labtest/screen/Auth/verification_pending_screen.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

NavigatorProvider navigatorProvider = NavigatorProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigatorProvider()),
        ChangeNotifierProvider(create: (context) => AppTheme()),
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
        return MaterialApp(
          title: 'Blood Lab Management System',
          debugShowCheckedModeBanner: false,
          theme: theme.themeData,
          home: RegistrationPage(),
          routes: {
            '/verification-pending': (context) => VerificationPendingScreen(),
            '/login': (context) => RegistrationPage(),
          },
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0, // Prevent text scaling on web
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
