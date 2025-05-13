import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/data/models/prize_model.dart';
import 'package:spin_wheels/data/models/spin_history_model.dart';
import 'package:spin_wheels/data/models/user_model.dart';
import 'package:spin_wheels/presentation/providers/prize_provider.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';
import 'package:spin_wheels/presentation/providers/theme_provider.dart';

/// Widget untuk roda putar (spin wheel)
class SpinWheelWidget extends StatefulWidget {
  final User selectedUser;
  final List<Prize> prizes;
  final Function(Prize) onSpinComplete;

  const SpinWheelWidget({
    super.key,
    required this.selectedUser,
    required this.prizes,
    required this.onSpinComplete,
  });

  @override
  State<SpinWheelWidget> createState() => _SpinWheelWidgetState();
}

class _SpinWheelWidgetState extends State<SpinWheelWidget> {
  late StreamController<int> _controller;
  bool _isSpinning = false;
  int _selectedPrizeIndex = 0;
  bool _showResult = false;
  Prize? _selectedPrize;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<int>.broadcast();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  // Memulai putaran roda
  void _spin() {
    // Jika tidak ada hadiah atau sedang berputar, tidak melakukan apa-apa
    if (widget.prizes.isEmpty || _isSpinning) {
      return;
    }

    setState(() {
      _isSpinning = true;
      _showResult = false;
    });
    
    // Tentukan hadiah pemenang berdasarkan probabilitas (jika ada)
    final prizeWithProbabilities = widget.prizes.where((prize) => prize.probability != null).toList();
    
    // Inisialisasi dengan nilai default 0
    int selectedIndex = 0;
    if (prizeWithProbabilities.isNotEmpty) {
      // Gunakan probabilitas untuk menentukan hadiah
      final random = Random().nextDouble();
      double cumulativeProbability = 0.0;
      
      for (int i = 0; i < widget.prizes.length; i++) {
        final prize = widget.prizes[i];
        final probability = prize.probability ?? (1.0 / widget.prizes.length);
        
        cumulativeProbability += probability;
        if (random <= cumulativeProbability) {
          selectedIndex = i;
          break;
        }
      }
    } else {
      // Gunakan random jika tidak ada probabilitas yang didefinisikan
      selectedIndex = Random().nextInt(widget.prizes.length);
    }
    
    _selectedPrizeIndex = selectedIndex;
    _selectedPrize = widget.prizes[selectedIndex];

    // Kirim event ke stream untuk memicu putaran roda
    _controller.add(selectedIndex);

    // Tentukan durasi putaran dari provider tema
    final spinDuration = Provider.of<ThemeProvider>(context, listen: false).spinDuration;

    // Tunggu hingga putaran selesai, lalu tampilkan hasil
    Future.delayed(spinDuration, () {
      setState(() {
        _isSpinning = false;
        _showResult = true;
      });

      // Simpan hasil ke database
      _saveSpinHistory();

      // Callback untuk hasil putaran
      widget.onSpinComplete(_selectedPrize!);
    });
  }

  // Menyimpan hasil putaran ke database
  void _saveSpinHistory() {
    if (_selectedPrize != null) {
      final spinHistoryProvider = Provider.of<SpinHistoryProvider>(context, listen: false);
      final prizeProvider = Provider.of<PrizeProvider>(context, listen: false);

      // Kurangi jumlah hadiah yang tersedia
      prizeProvider.decrementPrizeCount(_selectedPrize!.id!);

      // Simpan riwayat putaran
      final spinHistory = SpinHistory(
        userId: widget.selectedUser.id!,
        prizeId: _selectedPrize!.id!,
      );

      spinHistoryProvider.saveSpinHistory(spinHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fortuneItems = widget.prizes.map((prize) {
      return FortuneItem(
        child: Text(
          prize.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: FortuneItemStyle(
          color: prize.color,
          borderColor: Colors.white,
          borderWidth: 3,
        ),
      );
    }).toList();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Roda putar
            SizedBox(
              height: 300,
              child: fortuneItems.isEmpty
                  ? const Center(
                      child: Text('Tidak ada hadiah yang tersedia'),
                    )
                  : FortuneWheel(
                      animateFirst: false,
                      physics: CircularPanPhysics(
                        duration: themeProvider.spinDuration,
                        curve: Curves.easeOutExpo,
                      ),
                      selected: _controller.stream,
                      items: fortuneItems,
                      onAnimationEnd: () {
                        // Tidak melakukan apa-apa di sini, sudah ditangani oleh Future.delayed
                      },
                    ),
            ),
            
            // Indikator (panah)
            Positioned(
              top: 0,
              child: Transform.rotate(
                angle: pi,
                child: Icon(
                  Icons.arrow_drop_down_circle,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            
            // Animasi saat roda berputar
            if (_isSpinning)
              // Lottie.asset(
              //   'assets/animations/spinning.json',
              //   width: 200,
              //   height: 200,
              //   repeat: true,
              // ).animate().fadeIn(),
            
            // Penanda hadiah sudah terpilih
            if (_showResult)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Selamat!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedPrize?.name ?? 'Hadiah',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().scale(
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _isSpinning ? null : _spin,
          icon: const Icon(Icons.casino),
          label: Text(_isSpinning ? 'Berputar...' : 'PUTAR!'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate(target: _isSpinning ? 0 : 1).shake(
              duration: 500.ms,
              hz: 2,
            ),
      ],
    );
  }
}
