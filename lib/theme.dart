import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF2B8CEE);
  static const primaryAlt = Color(0xFF007AFF);
  static const accentOrange = Color(0xFFFFA500);
  static const backgroundLight = Color(0xFFF6F7F8);
  static const backgroundDark = Color(0xFF101922);
  static const charcoal = Color(0xFF212529);
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
    surface: AppColors.backgroundLight,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
  fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
  ),
  // cardTheme: Card styling can be applied per-widget or added here if needed for your SDK version.
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
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
  fillColor: const Color.fromRGBO(255, 255, 255, 0.03),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white10)),
  ),
  // cardTheme: Card styling can be applied per-widget or added here if needed for your SDK version.
);
