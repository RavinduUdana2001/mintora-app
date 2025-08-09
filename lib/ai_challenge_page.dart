import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIChallengeCoinPage extends StatelessWidget {
  const AIChallengeCoinPage({Key? key}) : super(key: key);

  // Function to store the "Notify Me!" preference
  Future<void> _storeNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify_me', true); // Store preference
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2c), // Dark background for consistency
      appBar: AppBar(
        title: const Text('Mintora AI', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2b2d42),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_border_purple500_sharp,
                color: Colors.tealAccent,
                size: 100.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Stay tuned for the exciting Mintora AI.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Notify Me Button with a better design
              InkWell(
                onTap: () async {
                  // Store the notification preference when the button is clicked
                  await _storeNotificationPreference();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("You will be notified when it's ready!")),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.tealAccent, Colors.deepPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  child: const Text(
                    'Notify Me!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
