import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 48, color: Colors.tealAccent),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Mintora!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We are passionate about transforming how people explore and personalize AI-powered experiences. Our mission is to provide seamless, fun, and secure services through innovative technology and user-focused design.',
              style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.6),
            ),
            const SizedBox(height: 30),

            _buildSectionTitle("Our Vision"),
            _buildParagraph(
              'To lead in delivering unique, intelligent tools and content that empower creativity, customization, and connection in the AI era.',
            ),

            _buildSectionTitle("What We Offer"),
            _buildBullet("AI-powered personalized content and tools."),
            _buildBullet("Secure ordering with real-time updates."),
            _buildBullet("A growing gallery of creative inspiration."),
            _buildBullet("Friendly and responsive support team."),

            _buildSectionTitle("Contact Us"),
            const SizedBox(height: 10),
            _buildContactInfo(label: "Email", value: "support@aichallengecoin.com"),
            _buildContactInfo(label: "Phone", value: "+1 (555) 123-4567"),

            const SizedBox(height: 30),
            Center(
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
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

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.tealAccent, fontSize: 18)),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.tealAccent, fontSize: 15)),
          Text(value, style: const TextStyle(color: Colors.white70, fontSize: 15)),
        ],
      ),
    );
  }
}
