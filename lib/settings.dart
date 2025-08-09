import 'package:flutter/material.dart';
import 'package:mintora/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'support.dart';
import 'privacy_policy.dart';
import 'about_us.dart';
import 'settings/reset_password_page.dart';
import 'settings/delete_account_page.dart';
import 'settings/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all shared preferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Settings",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: ListView(
        children: [
          _buildSectionHeader("Account"),
          _buildTile(Icons.person, "Edit Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }),

          ListTile(
            leading: const Icon(Icons.lock_reset, color: Colors.white),
            title: const Text(
              "Reset Password",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
              );
            },
          ),

          /*   SwitchListTile(
            activeColor: Colors.tealAccent,
            title: const Text(
              "Notifications",
              style: TextStyle(color: Colors.white),
            ),
            value: _notifications,
            onChanged: (val) {
              setState(() => _notifications = val);
              _updateSetting('notifications', val);
            },
          ),*/
          const Divider(color: Colors.white24),
          _buildSectionHeader("More Info"),

          _buildTile(Icons.privacy_tip_outlined, "Privacy Policy", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
            );
          }),

          _buildTile(Icons.info_outline, "About Us", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutUsPage()),
            );
          }),

          _buildTile(Icons.help_outline, "Help & Support", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpSupportPage()),
            );
          }),

          const SizedBox(height: 8),

          const Divider(color: Colors.white24),
          _buildSectionHeader('Danger Zone'),

          _buildTile(Icons.delete, "Delete Account", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DeleteAccountPage()),
            );
          }, color: Colors.redAccent),

          // Logout Section
          _buildTile(Icons.logout, "Logout", () {
            _logout(); // Logout function
          }, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: onTap,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
