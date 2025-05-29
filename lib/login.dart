import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  String _email = '';
  String _password = '';

  final String _apiUrl = 'https://apps.aichallengecoin.com/app/login.php';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': _email, 'password': _password},
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
  final prefs = await SharedPreferences.getInstance();
await prefs.setString('userName', data['name']);
await prefs.setString('userEmail', data['email']);
await prefs.setString('profileImage', data['profile_image'] ?? 'assets/default.png');
await prefs.setString('createdAt', data['created_at'] ?? ''); // ✅ ADD THIS LINE


  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => HomePage()),
  );
}
 else {
        _showError(data['message'] ?? 'Login failed');
      }
    } on TimeoutException {
      _showError('Connection timeout.');
    } on SocketException {
      _showError('No internet connection.');
    } catch (e) {
      _showError('Unexpected error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff0f2027),
                  Color(0xff203a43),
                  Color(0xff2c5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Glass Card Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_open_rounded, size: 64, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        "Welcome To Mintora",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: _glassInput("Email", Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => _email = val!.trim(),
                        validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.white),
                        decoration: _glassInput(
                          "Password",
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        onSaved: (val) => _password = val!,
                        validator: (val) => val == null || val.length < 6 ? 'Password must be at least 6 characters' : null,
                      ),
                      SizedBox(height: 30),
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : ElevatedButton.icon(
                              icon: Icon(Icons.login, color: Colors.white),
                              label: Text("Login", style: TextStyle(fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.white.withOpacity(0.4)),
                                ),
                              ),
                              onPressed: _login,
                            ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?", style: TextStyle(color: Colors.white70)),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage())),
                            child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _glassInput(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white30),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}