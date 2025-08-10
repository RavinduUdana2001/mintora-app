import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1e1e2c);
    const header = Color(0xFF2b2d42);

    final items = <_ContactItem>[
      _ContactItem(
        label: 'Facebook',
        icon: FontAwesomeIcons.facebook,
        color: const Color(0xFF1877F2),
        url: 'https://facebook.com/YourPage',
      ),
      _ContactItem(
        label: 'TikTok',
        icon: FontAwesomeIcons.tiktok,
        color: Colors.black,
        url: 'https://www.tiktok.com/@YourUsername',
      ),
      _ContactItem(
        label: 'WhatsApp',
        icon: FontAwesomeIcons.whatsapp,
        color: const Color(0xFF25D366),
        url: 'https://wa.me/94717777017?text=Hello%20Mintora',
      ),
      _ContactItem(
        label: 'YouTube',
        icon: FontAwesomeIcons.youtube,
        color: const Color(0xFFFF0000),
        url: 'https://youtube.com/YourChannel',
      ),
      _ContactItem(
        label: 'Fiverr',
        icon: FontAwesomeIcons.briefcase, // Fallback (FA Free doesn't include Fiverr)
        color: const Color(0xFF00B22D),
        url: 'https://www.fiverr.com/YourProfile',
      ),
      _ContactItem(
        label: 'Upwork',
        icon: FontAwesomeIcons.userTie, // Fallback (FA Free doesn't include Upwork)
        color: const Color(0xFF14A800),
        url: 'https://www.upwork.com/freelancers/~YourProfile',
      ),
      _ContactItem(
        label: 'Pinterest',
        icon: FontAwesomeIcons.pinterest,
        color: const Color(0xFFE60023),
        url: 'https://pinterest.com/YourProfile',
      ),
      _ContactItem(
        label: 'Behance',
        icon: FontAwesomeIcons.behance,
        color: const Color(0xFF1769FF),
        url: 'https://www.behance.net/YourProfile',
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: header,
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,          // 👉 one card per row
          mainAxisSpacing: 12,
          childAspectRatio: 5.0,      // 👉 nice, short “pill” cards
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _GlassCard(
            label: item.label,
            icon: item.icon,
            color: item.color,
            onTap: () => _openUrl(context, item.url),
          );
        },
      ),
    );
  }
}

class _GlassCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GlassCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<_GlassCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), // glassy
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_pressed ? 0.10 : 0.20),
                blurRadius: _pressed ? 4 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: widget.color.withOpacity(0.18),
                child: FaIcon(widget.icon, color: widget.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(Icons.open_in_new, color: Colors.white60, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem {
  final String label;
  final IconData icon;
  final Color color;
  final String url;

  _ContactItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.url,
  });
}
