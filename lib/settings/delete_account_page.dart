import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../login.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _loading = false;

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');

    if (email == null || email.isEmpty) {
      _showSnack("No email found");
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);

    final response = await http.post(
      Uri.parse('https://apps.aichallengecoin.com/app/delete_account.php'),
      body: {'email': email},
    );

    final result = jsonDecode(response.body);
    setState(() => _loading = false);

    if (result['status'] == 'success') {
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else {
      _showSnack(result['message'] ?? 'Failed to delete account');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        title: const Text("Delete Account", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2b2d42),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator(color: Colors.tealAccent)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "This will permanently delete your account. Are you sure?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      onPressed: _deleteAccount,
                      child: const Text("Delete My Account"),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
