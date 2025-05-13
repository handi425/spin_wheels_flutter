import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider untuk mengatur tema aplikasi
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _useSystemTheme = true;
  bool _playSounds = true;
  double _spinSpeed = 5.0; // Dalam detik

  /// Konstruktor
  ThemeProvider() {
    _loadPreferences();
  }

  /// Getter untuk mode gelap
  bool get isDarkMode => _isDarkMode;
  
  /// Getter untuk menggunakan tema sistem
  bool get useSystemTheme => _useSystemTheme;
  
  /// Getter untuk suara
  bool get playSounds => _playSounds;
  
  /// Getter untuk kecepatan putar
  double get spinSpeed => _spinSpeed;
  
  /// Getter untuk durasi spin (dalam milliseconds)
  Duration get spinDuration => Duration(milliseconds: (_spinSpeed * 1000).round());

  /// Memuat preferensi dari shared preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    _playSounds = prefs.getBool('playSounds') ?? true;
    _spinSpeed = prefs.getDouble('spinSpeed') ?? 5.0;
    notifyListeners();
  }

  /// Menyimpan preferensi ke shared preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('useSystemTheme', _useSystemTheme);
    await prefs.setBool('playSounds', _playSounds);
    await prefs.setDouble('spinSpeed', _spinSpeed);
  }

  /// Mengatur mode tema (gelap/terang)
  void setDarkMode(bool value) {
    _isDarkMode = value;
    _useSystemTheme = false;
    _savePreferences();
    notifyListeners();
  }

  /// Mengatur apakah menggunakan tema sistem
  void setUseSystemTheme(bool value) {
    _useSystemTheme = value;
    _savePreferences();
    notifyListeners();
  }

  /// Mengatur apakah suara diaktifkan
  void setPlaySounds(bool value) {
    _playSounds = value;
    _savePreferences();
    notifyListeners();
  }

  /// Mengatur kecepatan putar
  void setSpinSpeed(double value) {
    _spinSpeed = max(1.0, min(10.0, value));
    _savePreferences();
    notifyListeners();
  }

  /// Mendapatkan mode tema saat ini untuk ThemeMode
  ThemeMode getThemeMode(Brightness platformBrightness) {
    if (_useSystemTheme) {
      return ThemeMode.system;
    }
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
