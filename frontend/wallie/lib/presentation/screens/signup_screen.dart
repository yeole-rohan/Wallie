import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wallie/core/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _fullMobileNumber = "";
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  // Function to Sign up User
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await Dio().post(
        ApiConstants.createAccount,
        data: {
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
          "first_name": _firstNameController.text.trim(),
          "last_name": _lastNameController.text.trim(),
          "mobile_number": _fullMobileNumber,
        },
      );

      if (response.statusCode == 201) {
        _showMessage("Account Created Successfully!", Colors.green);

        // Auto-login user after signup
        final loginResponse = await Dio().post(
          ApiConstants.login,
          data: {
            "email": _emailController.text.trim(),
            "password": _passwordController.text,
          },
        );
        print('login data ${loginResponse.data}');
        if (loginResponse.statusCode == 200 &&
            loginResponse.data["access"] != null) {
          final data = response.data;
          // Save data in secure storage
          await _storage.write(key: "access_token", value: data["access"]);
          await _storage.write(key: "refresh_token", value: data["refresh"]);
          await _storage.write(key: "email", value: data["email"]);
          await _storage.write(key: "full_name", value: data["full_name"]);
          await _storage.write(
              key: "mobile_number", value: data["mobile_number"]);

          // Navigate to Home Screen using named route
          Navigator.pushNamed(context, 'home');
        } else {
          _showMessage("Signup successful, but login failed!", Colors.orange);
        }
      } else {
        _showMessage("Something went wrong!", Colors.red);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _showMessage(e.response!.data["error"] ?? "Signup Failed!", Colors.red);
      } else {
        _showMessage("Network Error. Try Again!", Colors.red);
      }
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
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                key: const Key("emailField"), // ✅ Unique key added
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => EmailValidator.validate(value ?? "")
                    ? null
                    : "Enter a valid email",
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const Key("passwordField"), // ✅ Unique key added
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                  if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                    return "Password must contain at least one uppercase letter and one number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const Key("firstNameField"), // ✅ Unique key added
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) =>
                    value!.isEmpty ? "First Name cannot be empty" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const Key("lastNameField"), // ✅ Unique key added
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) =>
                    value!.isEmpty ? "Last Name cannot be empty" : null,
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                key: const Key("phoneField"), // ✅ Unique key added
                decoration: const InputDecoration(labelText: "Mobile Number"),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  _fullMobileNumber = phone.completeNumber;
                },
                validator: (value) =>
                    value == null ? "Enter a valid phone number" : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: // Spacing between buttons
                    TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // ✅ Navigate to Login Page
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
