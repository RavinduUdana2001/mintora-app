import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'settings/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const CoinDesignerApp(),
    ),
  );
}

class CoinDesignerApp extends StatelessWidget {
  const CoinDesignerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mintora',
      themeMode: themeProvider.themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const LoginPage(),
    );
  }
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.deepPurple,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF2b2d42),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.deepPurple,
      secondary: Colors.tealAccent,
      surface: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF1e1e2c),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2b2d42),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2b2d42),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2b2d42),
      selectedItemColor: Colors.tealAccent,
      unselectedItemColor: Colors.white70,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF2b2d42),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2b2d42),
      secondary: Colors.tealAccent,
      surface: Color(0xFF1e1e2c),
    ),
  );
}