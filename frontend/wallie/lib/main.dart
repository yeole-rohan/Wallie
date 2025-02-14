import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallie/presentation/screens/login_screen.dart';
import 'package:wallie/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = const FlutterSecureStorage();
  String? token = await storage.read(key: "access_token"); // Check login status
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallie',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(), // Decide initial screen
    );
  }
}
