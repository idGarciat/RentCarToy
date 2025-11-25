import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Match Tailwind prototipo
  static const primary = Color(0xFF2B8CEE); // #2b8cee
  static const primaryAlt = Color(0xFF607AFB);
  static const accentOrange = Color(0xFFFFA500); // #FFA500
  static const backgroundLight = Color(0xFFF6F7F8); // #f6f7f8
  static const backgroundDark = Color(0xFF101922); // #101922
  static const charcoal = Color(0xFF212529); // #212529
  static const cardDark = Color(0xFF1C2A38);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  useMaterial3: false,
  textTheme: GoogleFonts.plusJakartaSansTextTheme(),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light).copyWith(
    primary: AppColors.primary,
    secondary: AppColors.accentOrange,
    surface: Colors.white,
    background: AppColors.backgroundLight,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary),
  ),
  cardColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF1F3F5), // light neutral similar to HTML inputs
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF212529)),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: Color(0xFF212529),
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFF212529)),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  useMaterial3: false,
  textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark).copyWith(
    primary: AppColors.primary,
    secondary: AppColors.accentOrange,
    surface: AppColors.cardDark,
    background: AppColors.backgroundDark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF0F1720),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  ),
  cardColor: AppColors.cardDark,
  iconTheme: const IconThemeData(color: Colors.white),
);

