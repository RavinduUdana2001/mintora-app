import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _loading = false;

  Future<void> _submitReset() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? '';

    if (_newPassController.text.trim().length < 6) {
      _showSnack("Password must be at least 6 characters");
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      _showSnack("Passwords do not match");
      return;
    }

    setState(() => _loading = true);
    final response = await http.post(
      Uri.parse('https://apps.aichallengecoin.com/app/reset_password.php'),
      body: {
        'email': email,
        'new_password': _newPassController.text.trim(),
      },
    );

    final result = jsonDecode(response.body);
    setState(() => _loading = false);

    if (result['status'] == 'success') {
      _showSnack("Password updated successfully", success: true);
      Navigator.pop(context);
    } else {
      _showSnack(result['message'] ?? "Error resetting password");
    }
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? Colors.green : Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2b2d42),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Enter a new password",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _newPassController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("New Password"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPassController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Confirm Password"),
              ),
              const SizedBox(height: 30),
              _loading
                  ? const CircularProgressIndicator(color: Colors.tealAccent)
                  : ElevatedButton(
                      onPressed: _submitReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      ),
                      child: const Text("Reset Password"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white30),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.tealAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
