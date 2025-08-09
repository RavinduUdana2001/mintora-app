import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.help_outline, size: 40, color: Colors.tealAccent),
            const SizedBox(height: 16),
            const Text(
              "Need Help?",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Browse common questions or reach out to our team.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),

            _buildSectionTitle("FAQs"),
            const SizedBox(height: 10),
            _buildFAQItem(
              question: "How do I place an order?",
              answer: "Go to the Shop section, select your items, and complete the checkout process.",
            ),
            _buildFAQItem(
              question: "What payment methods do you support?",
              answer: "We accept credit cards, PayPal, and bank transfers securely.",
            ),
            _buildFAQItem(
              question: "When will my order arrive?",
              answer: "Orders usually arrive within 3–5 business days. Expedited options are available.",
            ),

            const SizedBox(height: 30),
            _buildSectionTitle("Contact Us"),
            const SizedBox(height: 10),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "support@aichallengecoin.com",
              onTap: _launchEmail,
            ),
            _buildContactCard(
              icon: Icons.phone_in_talk,
              title: "Call Us",
              subtitle: "+1 (555) 123-4567",
              onTap: _launchPhone,
            ),
            _buildContactCard(
              icon: FontAwesomeIcons.whatsapp,
              title: "WhatsApp",
              subtitle: "Chat with us directly",
              onTap: _launchWhatsApp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.tealAccent,
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      color: const Color(0xFF2b2d42),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF2b2d42),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.tealAccent, size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: 'support@aichallengecoin.com',
      queryParameters: {'subject': 'Help Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError("Could not open email app.");
    }
  }

  Future<void> _launchPhone() async {
    final Uri uri = Uri(scheme: 'tel', path: '+15551234567');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError("Could not launch phone dialer.");
    }
  }

  Future<void> _launchWhatsApp() async {
    final phoneNumber = '+15551234567';
    final message = Uri.encodeComponent("Hello, I need help with Mintora.");
    final url = Uri.parse("https://wa.me/$phoneNumber?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showError("Could not open WhatsApp.");
    }
  }

  void _showError(String message) {
    debugPrint(message); // You could also show a snackbar if needed
  }
}
