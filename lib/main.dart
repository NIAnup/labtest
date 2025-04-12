import 'package:flutter/material.dart';
import 'package:labtest/provider/navigatorprodiver.dart';
import 'package:labtest/screen/Auth/login/LoginPage.dart';
import 'package:labtest/screen/Auth/registration/Registrationpage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

NavigatorProvider navigatorProvider = NavigatorProvider();

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigatorProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegistrationPage(),
    );
  }
}
