import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();
  String _email = "Loading...";
  String _fullName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? email = await _storage.read(key: "email");
    String? fullName = await _storage.read(key: "full_name");

    setState(() {
      _email = email ?? "No Email Found";
      _fullName = fullName ?? "User";
    });
  }

  Future<void> _logout() async {
    await _storage.deleteAll(); // Clear stored data
    Navigator.pushNamed(context, '/login'); // Navigate to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, $_fullName!", style: const TextStyle(fontSize: 20)),
            Text("Email: $_email", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
