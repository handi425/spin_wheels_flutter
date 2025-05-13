import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/config/app_config.dart';
import 'package:spin_wheels/presentation/providers/prize_provider.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';
import 'package:spin_wheels/presentation/providers/theme_provider.dart';
import 'package:spin_wheels/presentation/providers/user_provider.dart';
import 'package:spin_wheels/presentation/screens/home_screen.dart';
import 'package:spin_wheels/presentation/screens/prizes_screen.dart';
import 'package:spin_wheels/presentation/screens/settings_screen.dart';
import 'package:spin_wheels/presentation/screens/spin_history_screen.dart';
import 'package:spin_wheels/presentation/screens/statistics_screen.dart';
import 'package:spin_wheels/presentation/screens/users_screen.dart';

/// Layar utama aplikasi
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Daftar layar aplikasi
  final List<Widget> _screens = [
    const HomeScreen(),
    const UsersScreen(),
    const PrizesScreen(),
    const SpinHistoryScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  // Daftar item navigasi
  final List<NavigationDestination> _navigationItems = [
    const NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
    const NavigationDestination(icon: Icon(Icons.people), label: 'Pengguna'),
    const NavigationDestination(
      icon: Icon(Icons.card_giftcard),
      label: 'Hadiah',
    ),
    const NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
    const NavigationDestination(
      icon: Icon(Icons.bar_chart),
      label: 'Statistik',
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings),
      label: 'Pengaturan',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Memuat data dari database setelah frame pertama selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Memuat data dari database
  Future<void> _loadData() async {
    // Memuat data pengguna
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUsers();

    // Memuat data hadiah
    final prizeProvider = Provider.of<PrizeProvider>(context, listen: false);
    await prizeProvider.loadPrizes();

    // Memuat data riwayat spin
    final spinHistoryProvider = Provider.of<SpinHistoryProvider>(
      context,
      listen: false,
    );
    await spinHistoryProvider.loadSpinHistories();
    await spinHistoryProvider.loadStatistics();
  }

  // Menangani perubahan indeks navigasi
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Pindah ke halaman yang dipilih
    _pageController.animateToPage(
      index,
      duration: AppConfig.defaultAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan status pengiriman
    final spinHistoryProvider = Provider.of<SpinHistoryProvider>(context);
    final unsentCount = spinHistoryProvider.unsentCount;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: List.generate(_navigationItems.length, (index) {
          // Tambahkan badge pada tab Riwayat jika ada hadiah yang belum terkirim
          if (index == 3 && unsentCount > 0) {
            return NavigationDestination(
              icon: Badge(
                label: Text('$unsentCount'),
                child: _navigationItems[index].icon,
              ),
              label: _navigationItems[index].label,
            );
          }
          return _navigationItems[index];
        }),
      ).animate().fadeIn(duration: 300.ms).moveY(begin: 20, end: 0),
    );
  }
}
