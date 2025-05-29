import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'product.dart';

class OrderNowPage extends StatefulWidget {
  const OrderNowPage({Key? key}) : super(key: key);

  @override
  State<OrderNowPage> createState() => _OrderNowPageState();
}

class _OrderNowPageState extends State<OrderNowPage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> testimonials = [
    {
      'text': 'Fantastic coin design, exactly what we envisioned. Delivered fast with great communication!',
      'author': 'Security Forces Veteran',
      'rating': 5,
    },
    {
      'text': 'Our team coin was a huge hit at the conference. The designer provided clean vector art and perfect revisions.',
      'author': 'Corporate Buyer',
      'rating': 5,
    },
    {
      'text': 'The designer captured our military unit spirit perfectly in the coin design. Will order again!',
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _starAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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

  void _showOrderDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF2b2d42),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Order Summary',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const Divider(height: 30, color: Colors.white30),

            // Product Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/12.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.image_not_supported, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Custom Challenge Coin Design',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 5),
                      const Text('Professional custom coin design service',
                          style: TextStyle(fontSize: 14, color: Colors.white70)),
                      const SizedBox(height: 10),
                      Text('\$49.00',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent.shade200)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 40, color: Colors.white30),

            // Order Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Design Requirements',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _inputDecoration('Your organization/unit name'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _inputDecoration('Important symbols or elements to include'),
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _inputDecoration('Any specific colors or themes'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    const Text('Contact Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _inputDecoration('Your Name'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _inputDecoration('Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: _inputDecoration('Phone Number'),
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showPaymentSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Confirm & Pay \$49.00',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2b2d42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 60, color: Colors.tealAccent),
              ),
              const SizedBox(height: 25),
              const Text('Order Confirmed!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 15),
              const Text(
                'Your custom coin design order has been placed successfully. Our designer will contact you within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
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
      child: Text(title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white70))),
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
          errorBuilder: (context, error, stackTrace) => Container(
            width: 280,
            color: Colors.grey.shade800,
            child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 40)),
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
        title: const Text('Order Custom Coin', style: TextStyle(color: Colors.white)),
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
                  colors: [const Color(0xFF2b2d42).withOpacity(0.95), const Color(0xFF1e1e2c)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎖️ Custom Challenge Coin Design',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4)),
                  const SizedBox(height: 16),
                  buildStarAnimation(),
                  const SizedBox(height: 20),
                  const Text(
                    'Get a professionally designed custom challenge coin for your unit, organization, or event. Hand-crafted with precision and symbolism.',
                    style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.6),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _showOrderDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                      ),
                      child: const Text('ORDER NOW',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

            // Package
            _sectionTitle("Basic Package"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2e3440), Color(0xFF3b4252)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('1 Coin Design • 3 Days Delivery • 2 Revisions',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 15),
                    Row(
                      children: const [
                        Text('\$49',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                        SizedBox(width: 10),
                        Text('+ applicable taxes', style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showOrderDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Continue to Order',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Secure checkout', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
                    const Divider(height: 30, color: Colors.white30),
                    _infoRow(Icons.verified_user, '100% Satisfaction Guarantee'),
                    const SizedBox(height: 10),
                    _infoRow(Icons.support_agent, '24/7 Customer Support'),
                  ],
                ),
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
                      border: Border(left: BorderSide(color: Colors.tealAccent, width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                          rating: t['rating'].toDouble(),
                          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 20,
                        ),
                        const SizedBox(height: 10),
                        Text('"${t['text']}"',
                            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
                        const SizedBox(height: 10),
                        Text('– ${t['author']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
