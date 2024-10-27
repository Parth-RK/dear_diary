// theme.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const primaryColor = Colors.green;
  static const primaryColorLight = Colors.white;
  static const primaryColorDark = Colors.black;
  
  // Text colors
  static const primaryTextLight = Colors.white;
  static const primaryTextDark = Colors.black;
  static const secondaryTextLight = Colors.white70;
  static const secondaryTextDark = Colors.black87;
  
  // UI element colors
  static const dividerColorLight = Color(0xFFE0E0E0);
  static const dividerColorDark = Color(0xFF424242);
  static const cardBackgroundLight = Colors.white;
  static const cardBackgroundDark = Colors.black;
  
  // Action colors
  static const deleteColor = Colors.red;
  static const actionButtonColor = Colors.green;
  
  // Navigation colors
  static const navigationSelectedLight = Colors.black;
  static const navigationUnselectedLight = Colors.grey;
  static const navigationSelectedDark = Colors.white;
  static const navigationUnselectedDark = Colors.grey;
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.primaryColorDark,
    scaffoldBackgroundColor: AppColors.primaryColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColorDark,
      titleTextStyle: TextStyle(color: AppColors.primaryTextLight),
      iconTheme: IconThemeData(color: AppColors.primaryTextLight),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.actionButtonColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColorDark,
      selectedItemColor: AppColors.navigationSelectedDark,
      unselectedItemColor: AppColors.navigationUnselectedDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryTextLight),
      bodyMedium: TextStyle(color: AppColors.primaryTextLight),
      titleMedium: TextStyle(color: AppColors.secondaryTextLight),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerColorDark,
    ),
    cardTheme: const CardTheme(
      color: AppColors.cardBackgroundDark,
    ),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColors.primaryColorLight,
    scaffoldBackgroundColor: AppColors.primaryColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColorLight,
      titleTextStyle: TextStyle(color: AppColors.primaryTextDark),
      iconTheme: IconThemeData(color: AppColors.primaryTextDark),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.actionButtonColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColorLight,
      selectedItemColor: AppColors.navigationSelectedLight,
      unselectedItemColor: AppColors.navigationUnselectedLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryTextDark),
      bodyMedium: TextStyle(color: AppColors.primaryTextDark),
      titleMedium: TextStyle(color: AppColors.secondaryTextDark),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerColorLight,
    ),
    cardTheme: const CardTheme(
      color: AppColors.cardBackgroundLight,
    ),
  );
}