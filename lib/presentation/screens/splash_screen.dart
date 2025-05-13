import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spin_wheels/config/app_config.dart';
import 'package:spin_wheels/presentation/screens/main_screen.dart';

/// Layar splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Navigasi ke layar utama setelah beberapa detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConfig.primaryColor.withOpacity(0.8),
              AppConfig.secondaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.casino,
                  size: 70,
                  color: AppConfig.primaryColor,
                ),
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                    delay: 300.ms,
                  ),
              
              // Judul aplikasi
              const SizedBox(height: 24),
              Text(
                AppConfig.appName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(
                    duration: 600.ms,
                    delay: 900.ms,
                  ),
              
              // Subtitle
              const SizedBox(height: 8),
              const Text(
                'Putar & Dapatkan Hadiah',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ).animate().fadeIn(
                    duration: 600.ms,
                    delay: 1200.ms,
                  ),
              
              // Loading indicator
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
              ).animate().fadeIn(
                    duration: 600.ms,
                    delay: 1500.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
