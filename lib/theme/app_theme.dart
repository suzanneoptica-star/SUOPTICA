
import 'package:flutter/material.dart';

class SuOpticaTheme {
  static const Color primaryColor = Color(0xFF009B77); // Verde Esmeralda (Aproximado)
  static const Color secondaryColor = Colors.white;
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris Ultra-claro
  static const Color accentColor = Colors.black;

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
      secondary: primaryColor,
      surface: secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: secondaryColor,
      foregroundColor: accentColor,
      elevation: 0,
      iconTheme: IconThemeData(color: accentColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: accentColor),
      bodyMedium: TextStyle(color: accentColor),
    ),
    /*
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    */
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: primaryColor),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
