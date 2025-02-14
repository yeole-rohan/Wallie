import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallie/presentation/screens/login_screen.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            _buildMenuItem(Icons.person, "Profile", () {}),
            _buildMenuItem(Icons.settings, "Settings", () {}),
            _buildMenuItem(Icons.info, "About", () {}),
            _buildMenuItem(Icons.lock, "Privacy Policy", () {}),
            _buildMenuItem(Icons.description, "Terms of Use", () {}),
            _buildMenuItem(Icons.star, "Upgrade to Wallie Pro", () {}),
            _buildMenuItem(Icons.logout, "Logout", () {
              _logout();
            }),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // Close the bottom sheet
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ❌ Disable back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Wallie"),
          automaticallyImplyLeading: false, // ❌ Hide back button in AppBar
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome, $_fullName!",
                  style: const TextStyle(fontSize: 20)),
              Text("Email: $_email", style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0, // Creates space around the floating button
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _showBottomMenu,
                ),
                const SizedBox(width: 50), // Space for FloatingActionButton
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {}, // Empty for now
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, // Add Upload Functionality
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          elevation: 6.0, // Adds shadow for depth
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
