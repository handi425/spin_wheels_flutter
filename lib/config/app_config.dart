import 'package:flutter/material.dart';

/// Konfigurasi aplikasi SpinWheels
class AppConfig {
  // Nama aplikasi
  static const String appName = 'SpinWheels';
  
  // Versi aplikasi
  static const String appVersion = '1.0.0';
  
  // Skema warna utama
  static const MaterialColor primarySwatch = Colors.deepOrange;
  
  // Warna utama
  static const Color primaryColor = Color(0xFFFF5722);
  
  // Warna sekunder
  static const Color secondaryColor = Color(0xFF2196F3);
  
  // Warna aksen
  static const Color accentColor = Color(0xFFFFC107);
  
  // Durasi default untuk animasi
  static const Duration defaultAnimationDuration = Duration(milliseconds: 500);
  
  // Durasi putaran roda
  static const Duration spinDuration = Duration(seconds: 5);

  // Nama Database
  static const String databaseName = 'spin_wheels.db';
  
  // Versi Database
  static const int databaseVersion = 1;
}

/// Konstanta untuk tabel dan kolom database
class DatabaseConstants {
  // Nama tabel
  static const String usersTable = 'users';
  static const String prizesTable = 'prizes';
  static const String spinHistoryTable = 'spin_history';
  
  // Kolom umum
  static const String colId = 'id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  
  // Kolom tabel users
  static const String colUserName = 'name';
  static const String colUserEmail = 'email';
  static const String colUserPhone = 'phone';
  
  // Kolom tabel prizes
  static const String colPrizeName = 'name';
  static const String colPrizeDescription = 'description';
  static const String colPrizeValue = 'value';
  static const String colPrizeColor = 'color';
  static const String colPrizeProbability = 'probability';
  static const String colPrizeAvailableCount = 'available_count';
  static const String colPrizeImagePath = 'image_path';
  
  // Kolom tabel spin_history
  static const String colSpinHistoryUserId = 'user_id';
  static const String colSpinHistoryPrizeId = 'prize_id';
  static const String colSpinHistoryIsSent = 'is_sent';
  static const String colSpinHistorySentAt = 'sent_at';
  static const String colSpinHistoryNotes = 'notes';
}

/// Theme data untuk aplikasi
class AppTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppConfig.primaryColor,
      secondary: AppConfig.secondaryColor,
      tertiary: AppConfig.accentColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: AppConfig.primaryColor,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppConfig.primaryColor,
      secondary: AppConfig.secondaryColor,
      tertiary: AppConfig.accentColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF121212),
      foregroundColor: AppConfig.primaryColor,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
