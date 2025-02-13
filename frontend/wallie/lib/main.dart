import 'package:flutter/material.dart';
import 'package:wallie/presentation/screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'signup',
      routes: {
        'signup': (context) => SignupScreen(),
        // Add more routes here (e.g., login, home screen)
      },
    );
  }
}
