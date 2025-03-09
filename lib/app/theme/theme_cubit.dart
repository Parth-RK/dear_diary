import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themePreferenceKey = 'theme_mode';
  
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themePreferenceKey);
      
      if (themeIndex != null) {
        emit(ThemeMode.values[themeIndex]);
      }
    } catch (e) {
      // If there's an error loading the theme, use system default
    }
  }

  Future<void> toggleTheme() async {
    final newThemeMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newThemeMode);
    _saveTheme(newThemeMode);
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    emit(themeMode);
    _saveTheme(themeMode);
  }
  
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, themeMode.index);
    } catch (e) {
      // Error saving theme preference
    }
  }
}
