import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.privacy_tip_outlined, size: 48, color: Colors.tealAccent),
            const SizedBox(height: 20),
            const Text(
              'Your Privacy Matters',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This Privacy Policy outlines how we handle your personal data and information when using the Mintora app.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),

            _buildSectionTitle('1. Data Collection'),
            _buildParagraph(
              'We collect only the information you provide to us (like name, email, etc.) to ensure account creation, personalization, and support.',
            ),

            _buildSectionTitle('2. Usage of Information'),
            _buildParagraph(
              'Your data is used strictly for app functionality such as logging in, placing orders, and viewing order history. We do not sell or share your data.',
            ),

            _buildSectionTitle('3. Security'),
            _buildParagraph(
              'All user data is stored securely using encrypted methods and industry best practices. We strive to protect your privacy at all times.',
            ),

            _buildSectionTitle('4. Third-Party Services'),
            _buildParagraph(
              'We may use third-party services like payment processors or analytics tools. They follow their own privacy standards as well.',
            ),

            _buildSectionTitle('5. Your Rights'),
            _buildParagraph(
              'You have the right to access, update, or delete your personal data at any time by contacting us at support@aichallengecoin.com.',
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                'Last Updated: May 2025',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
      ),
    );
  }
}
