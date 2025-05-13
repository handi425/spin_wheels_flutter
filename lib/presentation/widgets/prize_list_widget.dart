import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/core/utils.dart';
import 'package:spin_wheels/data/models/prize_model.dart';
import 'package:spin_wheels/presentation/providers/prize_provider.dart';
import 'package:spin_wheels/presentation/widgets/add_prize_dialog.dart';

/// Widget untuk menampilkan daftar hadiah
class PrizeListWidget extends StatelessWidget {
  final Function(Prize)? onPrizeTap;
  final bool isSelectable;

  const PrizeListWidget({
    super.key,
    this.onPrizeTap,
    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PrizeProvider>(
      builder: (context, prizeProvider, child) {
        if (prizeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (prizeProvider.prizes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Belum ada hadiah',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddPrizeDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Hadiah'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: prizeProvider.prizes.length,
          itemBuilder: (context, index) {
            final prize = prizeProvider.prizes[index];
            return Slidable(
              key: ValueKey(prize.id),
              enabled: !isSelectable,
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed:
                        (context) => _showEditPrizeDialog(context, prize),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) => _confirmDeletePrize(context, prize),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              child: GestureDetector(
                onTap:
                    isSelectable && onPrizeTap != null
                        ? () => onPrizeTap!(prize)
                        : () => _showPrizeDetailDialog(context, prize),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prize.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (prize.value != null)
                                Text(
                                  Utils.formatCurrency(prize.value!),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2,
                                    size: 16,
                                    color:
                                        prize.availableCount > 0
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Stok: ${prize.availableCount}',
                                    style: TextStyle(
                                      color:
                                          prize.availableCount > 0
                                              ? Colors.green
                                              : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Menampilkan dialog konfirmasi hapus hadiah
  void _confirmDeletePrize(BuildContext context, Prize prize) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Hadiah'),
            content: Text('Apakah Anda yakin ingin menghapus ${prize.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Hapus hadiah
                  final prizeProvider = Provider.of<PrizeProvider>(
                    context,
                    listen: false,
                  );
                  prizeProvider.deletePrize(prize.id!).then((success) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Hadiah berhasil dihapus'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            prizeProvider.error ?? 'Gagal menghapus hadiah',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Menampilkan dialog tambah hadiah
  void _showAddPrizeDialog(BuildContext context) {
    showAddEditPrizeDialog(context: context);
  }

  // Menampilkan dialog edit hadiah
  void _showEditPrizeDialog(BuildContext context, Prize prize) {
    showAddEditPrizeDialog(context: context, prize: prize);
  }

  // Menampilkan dialog detail hadiah
  void _showPrizeDetailDialog(BuildContext context, Prize prize) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prize.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (prize.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          prize.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Nilai: ${prize.value != null ? Utils.formatCurrency(prize.value!) : 'Tidak ada'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color:
                                prize.availableCount > 0
                                    ? Colors.green
                                    : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tersedia: ${prize.availableCount}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color:
                                  prize.availableCount > 0
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (prize.probability != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.percent,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Probabilitas: ${(prize.probability! * 100).toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
              if (!isSelectable)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditPrizeDialog(context, prize);
                  },
                  child: const Text('Edit'),
                ),
            ],
          ),
    );
  }
}
