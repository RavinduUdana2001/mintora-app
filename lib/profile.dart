import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = '';
  String _userEmail = '';
  String _profileImage = '';
  String _memberSince = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _userEmail = prefs.getString('userEmail') ?? 'Not Available';
      _profileImage = prefs.getString('profileImage') ?? '';
      _memberSince = prefs.getString('createdAt') ?? ''; // ✅ now it works
      _isLoading = false;
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Not available';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM d, y').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2b2d42),
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.tealAccent),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.tealAccent.withOpacity(0.2),
                      child: ClipOval(
                        child:
                            (_profileImage.isNotEmpty &&
                                    _profileImage != 'null' &&
                                    _profileImage.startsWith("http"))
                                ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/user.png',
                                  image: _profileImage,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/user.png',
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          ),
                                )
                                : Image.asset(
                                  'assets/user.png',
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2b2d42),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildProfileItem(
                            icon: Icons.calendar_today,
                            label: "Member since",
                            value: _formatDate(_memberSince),
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildProfileItem(
                            icon: Icons.email,
                            label: "Email",
                            value: _userEmail,
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildProfileItem(
                            icon: Icons.person,
                            label: "Username",
                            value: _userName,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
