import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching WhatsApp link
import 'gallery.dart'; // Import the gallery page

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductPage({super.key, required this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedImageIndex = 0;

  // Function to open WhatsApp with product details
  Future<void> _launchWhatsApp(String message) async {
    final String phoneNumber = '+94717777017'; // Add your WhatsApp number here
    final String url =
        'https://wa.me/$phoneNumber?text=$message'; // Construct the WhatsApp URL

    // Check if WhatsApp is installed
    if (await canLaunch(url)) {
      await launch(url); // Launch WhatsApp
    } else {
      // If WhatsApp is not installed, show a dialog to guide the user to download it
      _showWhatsAppDownloadDialog();
    }
  }

  // Show a dialog to tell the user to download WhatsApp
  void _showWhatsAppDownloadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WhatsApp Not Found'),
          content: const Text(
            'It seems you don\'t have WhatsApp installed. Would you like to download it?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // Launch the Play Store or App Store to download WhatsApp
                const String url =
                    'https://play.google.com/store/apps/details?id=com.whatsapp'; // Google Play Store link
                if (await canLaunch(url)) {
                  await launch(url); // Open the Play Store
                } else {
                  throw 'Could not open Play Store';
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Navigate to the GalleryScreen page
  void _navigateToGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GalleryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images =
        widget.product['image'] is String
            ? List<String>.from(jsonDecode(widget.product['image'] ?? '[]'))
            : List<String>.from(widget.product['image'] ?? []);
    final title = widget.product['title'] ?? '';
    final price = widget.product['price'] ?? '';
    final description =
        (widget.product['description']?.toString().trim().isNotEmpty ?? false)
            ? widget.product['description']
            : 'No description available.';

    final String message =
        'I am interested in buying the "$title" for \$${price}. Details: $description';

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
                      errorBuilder:
                          (context, error, stackTrace) => Container(
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
                                  color:
                                      _selectedImageIndex == index
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
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
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

                  // Full Description
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
                // Left button (Navigate to Gallery)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _navigateToGallery, // Navigate to the gallery
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text(
                      "View Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
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

                // Right button (Buy Now)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _launchWhatsApp(message); // Open WhatsApp with message
                    },
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    label: const Text(
                      "Buy Now",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf72585),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
