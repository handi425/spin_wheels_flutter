import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/data/models/prize_model.dart';
import 'package:spin_wheels/data/models/user_model.dart';
import 'package:spin_wheels/presentation/providers/prize_provider.dart';
import 'package:spin_wheels/presentation/providers/user_provider.dart';
import 'package:spin_wheels/presentation/widgets/spin_result_widget.dart';
import 'package:spin_wheels/presentation/widgets/spin_wheel_widget.dart';

/// Layar beranda aplikasi
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _selectedUser;
  Prize? _selectedPrize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpinWheels'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserSelector(),
              const SizedBox(height: 24),
              _buildSpinWheel(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk memilih pengguna
  Widget _buildUserSelector() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (userProvider.users.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.people,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada pengguna',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan pengguna terlebih dahulu untuk memulai',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigasi ke halaman Pengguna
                      final NavigationBar navigationBar = context
                          .findAncestorWidgetOfExactType<NavigationBar>()!;
                      navigationBar
                          .onDestinationSelected!(1); // Index halaman Pengguna
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Pengguna'),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: -0.2, end: 0, duration: 400.ms);
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Pengguna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<User>(
                  value: _selectedUser,
                  decoration: const InputDecoration(
                    labelText: 'Pengguna',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  items: userProvider.users.map((user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(user.name),
                    );
                  }).toList(),
                  onChanged: (User? value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ).animate().fadeIn().slideY(begin: -0.2, end: 0, duration: 400.ms);
      },
    );
  }

  // Widget untuk roda putar
  Widget _buildSpinWheel() {
    return Expanded(
      child: Consumer2<PrizeProvider, UserProvider>(
        builder: (context, prizeProvider, userProvider, child) {
          if (prizeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final availablePrizes = prizeProvider.availablePrizes;

          if (availablePrizes.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada hadiah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tambahkan hadiah terlebih dahulu untuk memulai',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigasi ke halaman Hadiah
                        final NavigationBar navigationBar = context
                            .findAncestorWidgetOfExactType<NavigationBar>()!;
                        navigationBar
                            .onDestinationSelected!(2); // Index halaman Hadiah
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Hadiah'),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0, duration: 400.ms);
          }

          if (_selectedUser == null) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_search,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Pengguna',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih pengguna terlebih dahulu untuk memulai',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0, duration: 400.ms);
          }

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Selamat Datang, ${_selectedUser!.name}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Putar roda untuk mendapatkan hadiah',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SpinWheelWidget(
                      selectedUser: _selectedUser!,
                      prizes: availablePrizes,
                      onSpinComplete: _onSpinComplete,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0, duration: 400.ms);
        },
      ),
    );
  }

  // Callback saat putaran selesai
  void _onSpinComplete(Prize prize) {
    setState(() {
      _selectedPrize = prize;
    });

    // Tampilkan dialog hasil
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SpinResultWidget(
        prize: prize,
        user: _selectedUser!,
        onClose: () {
          Navigator.pop(context);
          setState(() {
            _selectedPrize = null;
          });
        },
        onSpinAgain: () {
          // Tidak melakukan apa-apa, karena dialog sudah ditutup
          // dan pengguna bisa memutar lagi
        },
      ),
    );
  }
}
