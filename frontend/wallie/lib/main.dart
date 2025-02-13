import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallie/presentation/screens/signup_screen.dart';
import 'package:wallie/presentation/screens/login_screen.dart';
import 'package:wallie/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _storage = const FlutterSecureStorage();
  String _initialRoute = 'login';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _storage.read(key: "access_token");
    if (token != null) {
      setState(() {
        _initialRoute = 'home';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _initialRoute, // Check login status and navigate
      routes: {
        'signup': (context) => const SignupScreen(),
        'login': (context) => const LoginScreen(),
        'home': (context) => const HomeScreen(),
      },
    );
  }
}
