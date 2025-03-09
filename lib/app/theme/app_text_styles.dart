import 'package:flutter/material.dart';
import 'package:dear_diary/app/theme/app_colors.dart';

class AppTextStyles {
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkGrey,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.darkGrey,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGrey,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGrey,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGrey,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGrey,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.darkGrey,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.darkGrey,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AppColors.mediumGrey,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: textTheme.displayLarge!.copyWith(color: Colors.white),
    displayMedium: textTheme.displayMedium!.copyWith(color: Colors.white),
    displaySmall: textTheme.displaySmall!.copyWith(color: Colors.white),
    headlineMedium: textTheme.headlineMedium!.copyWith(color: Colors.white),
    titleLarge: textTheme.titleLarge!.copyWith(color: Colors.white),
    titleMedium: textTheme.titleMedium!.copyWith(color: Colors.white),
    bodyLarge: textTheme.bodyLarge!.copyWith(color: Colors.white),
    bodyMedium: textTheme.bodyMedium!.copyWith(color: Colors.white),
    bodySmall: textTheme.bodySmall!.copyWith(color: AppColors.lightGrey),
  );
}
