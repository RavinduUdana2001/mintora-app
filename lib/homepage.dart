import 'package:flutter/material.dart';
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

class HomePage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      OrderNowPage(),
      Center(child: Text("Explore AI", style: TextStyle(color: Colors.white))),
      GalleryScreen(),
      ShopPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          'Welcome $_userName',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),

      drawer: Drawer(
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
              leading: const Icon(Icons.person, color: Colors.white),
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

            // Order Details (flat menu item)
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.white),
              title: const Text(
                'Order Details',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Order Details screen
              },
            ),

            // Notifications
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text(
                'Notifications',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Notifications screen
              },
            ),

            // Settings
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
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
                // Navigate to Settings screen
              },
            ),

            // Help
            // In your drawer ListTile for Help & Support:
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
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

            // About Us
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
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

            // Privacy Policy
            ListTile(
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Colors.white,
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

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF2b2d42),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'AI'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Gallery',
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
