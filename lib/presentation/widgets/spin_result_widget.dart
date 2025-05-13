import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/core/utils.dart';
import 'package:spin_wheels/data/models/prize_model.dart';
import 'package:spin_wheels/data/models/user_model.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';

/// Widget untuk menampilkan hasil putaran roda
class SpinResultWidget extends StatelessWidget {
  final Prize prize;
  final User user;
  final VoidCallback onClose;
  final VoidCallback onSpinAgain;

  const SpinResultWidget({
    super.key,
    required this.prize,
    required this.user,
    required this.onClose,
    required this.onSpinAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selamat ${user.name}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ).animate().slideY(
                  begin: -1,
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: prize.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: prize.imagePath != null
                    ? Image.asset(
                        prize.imagePath!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 40,
                      ),
              ),
            ).animate().scale(
                  delay: 200.ms,
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 20),
            Text(
              'Anda mendapatkan',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              prize.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: prize.color,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms).scale(
                  delay: 400.ms,
                  duration: 500.ms,
                ),
            if (prize.description != null) ...[
              const SizedBox(height: 8),
              Text(
                prize.description!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (prize.value != null) ...[
              const SizedBox(height: 8),
              Text(
                'Nilai: ${Utils.formatCurrency(prize.value!)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final spinHistoryProvider =
                        Provider.of<SpinHistoryProvider>(context, listen: false);
                    // Memuat ulang data untuk memastikan kita mendapatkan ID terbaru
                    spinHistoryProvider.loadSpinHistories().then((_) {
                      if (spinHistoryProvider.spinHistories.isNotEmpty) {
                        // Menandai hadiah terakhir sebagai sudah dikirim
                        final lastSpin = spinHistoryProvider.spinHistories.first;
                        if (lastSpin.userId == user.id && lastSpin.prizeId == prize.id) {
                          spinHistoryProvider.markAsSent(lastSpin.id!);
                        }
                      }
                    });
                    
                    // Tampilkan notifikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hadiah ditandai sebagai sudah dikirim'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kirim Hadiah'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    onClose();
                    onSpinAgain();
                  },
                  child: const Text('Putar Lagi'),
                ),
              ],
            ).animate().slideY(
                  delay: 600.ms,
                  begin: 1,
                  duration: 500.ms,
                ),
          ],
        ),
      ),
    );
  }
}
