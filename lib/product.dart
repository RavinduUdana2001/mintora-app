import 'dart:convert';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductPage({required this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.product['image'] is String
        ? List<String>.from(jsonDecode(widget.product['image'] ?? '[]'))
        : List<String>.from(widget.product['image'] ?? []);

    final title = widget.product['title'] ?? '';
    final price = widget.product['price'] ?? '';
    final description = (widget.product['description']?.toString().trim().isNotEmpty ?? false)
        ? widget.product['description']
        : 'No description available.';

    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://apps.aichallengecoin.com/${images[_selectedImageIndex]}',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Thumbnails
                  if (images.length > 1)
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedImageIndex == index
                                      ? Colors.tealAccent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  'https://apps.aichallengecoin.com/${images[index]}',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade800,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (images.length > 1) const SizedBox(height: 16),

                  // Product Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Price
                  Text(
                    "\$${price.toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Buttons with Bottom Margin
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            color: const Color(0xFF2b2d42),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add to cart logic
                    },
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                    label: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ecdc4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Buy now logic
                    },
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    label: const Text("Buy Now", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf72585),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
            )],
              ),
            ),
          ],
        ),
      );
    }
  }