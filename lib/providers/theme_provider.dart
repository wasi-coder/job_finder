import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF1E3A8A), // Dark blue
      primaryColorLight: const Color(0xFF3B82F6), // Bright blue accent
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Light gray background
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E3A8A), // Dark blue header
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6), // Bright blue buttons
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B7280)), // Medium gray
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Color(0xFF111827), // Almost black
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(0xFF111827)),
        bodyMedium: TextStyle(color: Color(0xFF6B7280)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF6B7280)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF3B82F6),
        unselectedItemColor: Color(0xFF6B7280),
        elevation: 8,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: const Color(0xFF3B82F6), // Bright blue
      primaryColorLight: const Color(0xFF60A5FA), // Lighter blue accent
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF111827), // Dark background
      cardColor: const Color(0xFF1F2937), // Dark card
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E3A8A), // Dark blue header
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6), // Bright blue buttons
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF374151),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFF9CA3AF)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF9CA3AF)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1F2937),
        selectedItemColor: Color(0xFF3B82F6),
        unselectedItemColor: Color(0xFF6B7280),
        elevation: 8,
      ),
    );
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;
}