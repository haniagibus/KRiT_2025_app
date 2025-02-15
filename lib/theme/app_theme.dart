import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.text_primary),
      bodyMedium: TextStyle(color: AppColors.text_secondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, // Navigation bar background
      selectedItemColor: AppColors.accent, // Selected item color
      unselectedItemColor: AppColors.text_secondary, // Unselected item color
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      showUnselectedLabels: true, // Show labels for unselected items
    ),
    // buttonTheme: ButtonThemeData(
    //   buttonColor: AppColors.accent, // Define the default button color
    //   textTheme: ButtonTextTheme.primary,
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.button_background
      ),
    ),
  );
}
