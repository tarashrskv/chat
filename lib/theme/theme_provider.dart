import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeModeNotifier() {
    _getThemeMode();
  }

  ThemeMode get themeMode => _themeMode ?? ThemeMode.light;

  void toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveThemeMode();

    notifyListeners();
  }

  Future<void> _getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getString("themeMode") == 'dark' ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("themeMode", _themeMode!.name);
  }
}