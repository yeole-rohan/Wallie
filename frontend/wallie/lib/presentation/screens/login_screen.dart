import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallie/core/constants.dart';
import 'package:wallie/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  // Function to log in the user
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await Dio().post(
        ApiConstants.login, // API endpoint
        data: {
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
        },
      );

      if (response.statusCode == 200 && response.data["access"] != null) {
        _showMessage("Login successful", Colors.green);
        final data = response.data;
        // Save data in secure storage
        await _storage.write(key: "access_token", value: data["access"]);
        await _storage.write(key: "refresh_token", value: data["refresh"]);
        await _storage.write(key: "email", value: data["email"]);
        await _storage.write(key: "full_name", value: data["full_name"]);
        await _storage.write(
            key: "mobile_number", value: data["mobile_number"]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showMessage("Invalid email or password", Colors.red);
      }
    } on DioException catch (e) {
      _showMessage(e.response?.data["error"] ?? "Login failed!", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Show Snackbar Message
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ❌ Disable back navigation
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Login"),
            automaticallyImplyLeading: false), // ❌ Hide back button in AppBar,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) => EmailValidator.validate(value ?? "")
                      ? null
                      : "Enter a valid email",
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (value) => (value == null || value.length < 6)
                      ? "Enter a valid password"
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
                const SizedBox(height: 10), // Spacing between buttons
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, 'signup'); // ✅ Navigate to Signup Page
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
