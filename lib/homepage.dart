import 'package:flutter/material.dart';
import 'package:mintora/ai/mintora_ai_page.dart';
import 'package:mintora/contact_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'shop.dart';
import 'gallery.dart';
import 'ordernow.dart';
import 'profile.dart';
import 'support.dart';
import 'privacy_policy.dart';
import 'about_us.dart';
import 'settings.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  String _userEmail = '';
  String _profileImage = '';
  int _selectedIndex = 0;
  String _createdAt = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _userEmail = prefs.getString('userEmail') ?? 'Email not found';
      _profileImage = prefs.getString('profileImage') ?? '';
      _createdAt = prefs.getString('createdAt') ?? ''; // ✅ add this line
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void _launchURL(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      OrderNowPage(),
      const MintoraAIPage(), // AI page
      GalleryScreen(),
      ShopPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b2d42),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true, // Ensures title is centered even with drawer icon
        leading: Padding(padding: EdgeInsets.all(6),
         child: Image.asset(
            'assets/mintorav.png', // Your logo asset
             height: 20,
              width: 20,
          ),),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.waving_hand_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              ' Welcome $_userName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      // Use `endDrawer` instead of `drawer` to move the menu to the right side
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF2b2d42),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF3a506b)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: ClipOval(
                      child:
                          (_profileImage.isNotEmpty &&
                                  _profileImage != 'null' &&
                                  _profileImage.startsWith("http") &&
                                  !_profileImage.contains(
                                    "default.png",
                                  )) // Avoid known 404 URLs
                              ? FadeInImage.assetNetwork(
                                placeholder:
                                    'assets/user.png', // Show immediately
                                image: _profileImage,
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/user.png',
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Image.asset(
                                'assets/user.png',
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                              ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Profile
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.tealAccent),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.blue),
              title: const Text(
                'Help & Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.purple),
              title: const Text(
                'About Us',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Colors.red,
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                );
              },
            ),

            const Divider(color: Colors.white24),

          ListTile(
  leading: const Icon(Icons.phone, color: Colors.blueAccent),
  title: const Text(
    'Contact Us',
    style: TextStyle(color: Colors.white),
  ),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContactUsPage()),
    );
  },
),


            // Divider for separation
            const Divider(color: Colors.white24),

            // Logout
           
          ],
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF2b2d42),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'AI',
          ), // "AI" menu
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
}
