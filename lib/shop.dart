import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mintora/product.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  final String _apiUrl = 'https://apps.aichallengecoin.com/app/shop.php';

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch data initially when the page loads
  }

  // Fetch products from the API
  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _products = data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Hero Image
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/1234.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
            child: Center(
              child: Text(
                'Premium Challenge Coins',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Description
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Our custom challenge coins are crafted with precision and quality materials to honor achievements, commemorate events, or represent your organization with pride.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
        ),

        // Feature Points
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF2b2d42).withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildFeaturePoint(
                Icons.local_shipping,
                'Fast Shipping',
                'Delivered in 3-5 business days',
              ),
              Divider(color: Colors.white24, height: 20),
              _buildFeaturePoint(
                Icons.verified_user,
                'Premium Quality',
                'Made with durable materials',
              ),
              Divider(color: Colors.white24, height: 20),
              _buildFeaturePoint(
                Icons.star,
                'Custom Designs',
                'Tailored to your specifications',
              ),
              Divider(color: Colors.white24, height: 20),
              _buildFeaturePoint(
                Icons.thumb_up,
                '1000+ Orders',
                'Trusted by customers worldwide',
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Shop Now',
          style: TextStyle(
            color: Colors.tealAccent,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFeaturePoint(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      body: RefreshIndicator(
        onRefresh: _fetchProducts,  // The function to call when pull-to-refresh is triggered
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            _isLoading
                ? SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : _products.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Text(
                            "No products available.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 260,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final product = _products[index];
                            final images = jsonDecode(product['image'] ?? '[]');
                            final imageUrl =
                                images.isNotEmpty ? 'https://apps.aichallengecoin.com/${images[0]}' : 'https://apps.aichallengecoin.com/uploads/default.jpg';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductPage(
                                      product: {
                                        ...product,
                                        'image': product['image'] is String
                                            ? jsonDecode(product['image'] ?? '[]')
                                            : product['image'],
                                        'description': product['description']?.toString() ?? '',
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2e3440), Color(0xFF3b4252)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 130,
                                          color: Colors.grey.shade800,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['title'] ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "\$${product['price']}",
                                            style: const TextStyle(
                                              color: Colors.tealAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product['description'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, childCount: _products.length),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
