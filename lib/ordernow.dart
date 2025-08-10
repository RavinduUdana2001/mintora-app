import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart'; // This will allow us to launch WhatsApp

class OrderNowPage extends StatefulWidget {
  const OrderNowPage({super.key});

  @override
  State<OrderNowPage> createState() => _OrderNowPageState();
}

class _OrderNowPageState extends State<OrderNowPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> testimonials = [
    {
      'text':
          'Fantastic coin design, exactly what we envisioned. Delivered fast with great communication!',
      'author': 'Security Forces Veteran',
      'rating': 5,
    },
    {
      'text':
          'Our team coin was a huge hit at the conference. The designer provided clean vector art and perfect revisions.',
      'author': 'Corporate Buyer',
      'rating': 5,
    },
    {
      'text':
          'The designer captured our military unit spirit perfectly in the coin design. Will order again!',
      'author': 'Army Unit Commander',
      'rating': 5,
    },
  ];

  final List<Map<String, dynamic>> features = [
    {'icon': Icons.design_services, 'text': 'Double-sided\ncoin design'},
    {'icon': Icons.high_quality, 'text': 'High-resolution\nfiles'},
    {'icon': Icons.timer, 'text': '3-day\ndelivery'},
    {'icon': Icons.sync, 'text': '2 included\nrevisions'},
    {'icon': Icons.architecture, 'text': 'Mint-ready\nfiles'},
    {'icon': Icons.view_in_ar, 'text': '3D\nmockups'},
  ];

  late AnimationController _controller;
  late Animation<double> _starAnimation;

  void _openWhatsApp() async {
    final String message =
        "Hello, I would like to order a custom challenge coin. Can you assist me with the process?";
    final String phoneNumber = "+94717777017"; // Updated with your phone number
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunch(whatsappUrl.toString())) {
        await launch(whatsappUrl.toString()); // Launch WhatsApp
      } else {
        // Fallback to WhatsApp Web if app is not installed
        final fallbackUrl = Uri.parse(
          "https://web.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}",
        );
        await launch(fallbackUrl.toString());
      }
    } catch (e) {
      print('Error launching WhatsApp: $e'); // Handle any error that occurs
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _starAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildStarAnimation() {
    return FadeTransition(
      opacity: _starAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (index) => ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.2).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(index * 0.1, 1.0, curve: Curves.elasticOut),
              ),
            ),
            child: const Icon(Icons.star, color: Colors.amber, size: 30),
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
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.tealAccent),
      ),
      filled: true,
      fillColor: const Color(0xFF3b4252),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          assetPath,
          width: 280,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                width: 280,
                color: Colors.grey.shade800,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        automaticallyImplyLeading: false, // ❌ removes back icon
        title: const Text(
          'Order Custom Coin',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2b2d42).withOpacity(0.95),
                    const Color(0xFF1e1e2c),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Centered Text
                  Center(
                    // This Center widget ensures the text is centered
                    child: const Text(
                      '🎖️ Custom Challenge Coin Design',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildStarAnimation(),
                  const SizedBox(height: 20),
                  const Text(
                    'Get a professionally designed custom challenge coin for your unit, organization, or event. Hand-crafted with precision and symbolism.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          _openWhatsApp, // This will now open WhatsApp when clicked
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'ORDER NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Gallery
            _sectionTitle("Our Work Samples"),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildGalleryImage('assets/12.jpg'),
                  _buildGalleryImage('assets/123.jpg'),
                  _buildGalleryImage('assets/1234.jpg'),
                ],
              ),
            ),

            // Features, Package, Testimonials...
            _sectionTitle("What You Get"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2e3440),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(feature['icon'], color: Colors.tealAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            feature['text'],
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

         

            // Testimonials
            _sectionTitle("Client Testimonials"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.separated(
                itemCount: testimonials.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final t = testimonials[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2e3440),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(color: Colors.tealAccent, width: 3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                          rating: t['rating'].toDouble(),
                          itemBuilder:
                              (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 20,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '"${t['text']}"',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '– ${t['author']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
