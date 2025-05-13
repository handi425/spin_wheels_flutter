import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/core/utils.dart';
import 'package:spin_wheels/data/models/spin_history_model.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';

/// Widget untuk menampilkan tabel riwayat spin
class SpinHistoryTableWidget extends StatelessWidget {
  const SpinHistoryTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinHistoryProvider>(
      builder: (context, spinHistoryProvider, child) {
        if (spinHistoryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (spinHistoryProvider.spinHistories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Belum ada riwayat spin',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statisticsCard(
                        context: context,
                        icon: Icons.casino,
                        value:
                            spinHistoryProvider.statistics['totalCount']
                                ?.toString() ??
                            '0',
                        label: 'Total Spin',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      _statisticsCard(
                        context: context,
                        icon: Icons.check_circle,
                        value:
                            spinHistoryProvider.statistics['sentCount']
                                ?.toString() ??
                            '0',
                        label: 'Terkirim',
                        color: Colors.green,
                      ),
                      _statisticsCard(
                        context: context,
                        icon: Icons.schedule,
                        value:
                            spinHistoryProvider.statistics['unsentCount']
                                ?.toString() ??
                            '0',
                        label: 'Belum Terkirim',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: WidgetStateProperty.all(
                      Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.3),
                    ),
                    columns: const [
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Pengguna')),
                      DataColumn(label: Text('Hadiah')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows:
                        spinHistoryProvider.spinHistories.map((history) {
                          final userName =
                              history.userData != null
                                  ? history.userData!['name']
                                  : 'Unknown';
                          final prizeName =
                              history.prizeData != null
                                  ? history.prizeData!['name']
                                  : 'Unknown';

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  Utils.formatDate(
                                    history.createdAt,
                                    format: 'dd/MM/yyyy HH:mm',
                                  ),
                                ),
                              ),
                              DataCell(Text(userName)),
                              DataCell(Text(prizeName)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        history.isSent
                                            ? Colors.green
                                            : Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    history.isSent
                                        ? 'Terkirim'
                                        : 'Belum Terkirim',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!history.isSent)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.send,
                                          color: Colors.green,
                                        ),
                                        onPressed:
                                            () => _markAsSent(context, history),
                                        tooltip: 'Tandai Terkirim',
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info,
                                        color: Colors.blue,
                                      ),
                                      onPressed:
                                          () => _showDetailDialog(
                                            context,
                                            history,
                                          ),
                                      tooltip: 'Detail',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget kartu statistik
  Widget _statisticsCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  // Menandai hadiah sebagai terkirim
  void _markAsSent(BuildContext context, SpinHistory history) {
    final TextEditingController notesController = TextEditingController();
    final TextEditingController trackingNumberController =
        TextEditingController();

    // Mengambil nomor telepon pengguna jika tersedia
    final userPhone =
        history.userData != null ? history.userData!['phone'] : null;
    final userName =
        history.userData != null ? history.userData!['name'] : 'Pelanggan';
    final prizeName =
        history.prizeData != null ? history.prizeData!['name'] : 'Hadiah';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tandai Hadiah Terkirim'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Silakan isi informasi pengiriman hadiah.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: trackingNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Resi Pengiriman',
                    prefixIcon: Icon(Icons.local_shipping),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Pengiriman (opsional)',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              if (userPhone != null && userPhone.isNotEmpty)
                ElevatedButton.icon(
                  icon: const Icon(Icons.message, color: Colors.green),
                  label: const Text('Kirim WA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // Format pesan WhatsApp
                    final waMessage =
                        'Halo $userName, '
                        'hadiah Anda $prizeName telah dikirim dengan nomor resi ${trackingNumberController.text}';

                    // Buka WhatsApp dengan pesan yang sudah disiapkan
                    Utils.openWhatsapp(phone: userPhone, message: waMessage);
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Tandai hadiah sebagai terkirim
                  final spinHistoryProvider = Provider.of<SpinHistoryProvider>(
                    context,
                    listen: false,
                  );
                  spinHistoryProvider
                      .markAsSent(
                        history.id!,
                        notes:
                            notesController.text.isEmpty
                                ? null
                                : notesController.text,
                        trackingNumber:
                            trackingNumberController.text.isEmpty
                                ? null
                                : trackingNumberController.text,
                      )
                      .then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Hadiah berhasil ditandai terkirim',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                spinHistoryProvider.error ??
                                    'Gagal menandai hadiah terkirim',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                },
                child: const Text('Tandai Terkirim'),
              ),
            ],
          ),
    );
  }

  // Menampilkan dialog detail riwayat spin
  void _showDetailDialog(BuildContext context, SpinHistory history) {
    final userName =
        history.userData != null ? history.userData!['name'] : 'Unknown';
    final userEmail =
        history.userData != null ? history.userData!['email'] : null;
    final prizeName =
        history.prizeData != null ? history.prizeData!['name'] : 'Unknown';
    final prizeValue =
        history.prizeData != null ? history.prizeData!['value'] : null;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detail Riwayat Spin'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailItem(
                  context: context,
                  icon: Icons.event,
                  label: 'Tanggal Spin',
                  value: Utils.formatDate(
                    history.createdAt,
                    format: 'dd MMMM yyyy, HH:mm',
                  ),
                ),
                const SizedBox(height: 12),
                _detailItem(
                  context: context,
                  icon: Icons.person,
                  label: 'Pengguna',
                  value: userName,
                ),
                if (userEmail != null) ...[
                  const SizedBox(height: 12),
                  _detailItem(
                    context: context,
                    icon: Icons.email,
                    label: 'Email',
                    value: userEmail,
                  ),
                ],
                const SizedBox(height: 12),
                _detailItem(
                  context: context,
                  icon: Icons.card_giftcard,
                  label: 'Hadiah',
                  value: prizeName,
                ),
                if (prizeValue != null) ...[
                  const SizedBox(height: 12),
                  _detailItem(
                    context: context,
                    icon: Icons.attach_money,
                    label: 'Nilai',
                    value: Utils.formatCurrency(prizeValue),
                  ),
                ],
                const SizedBox(height: 12),
                _detailItem(
                  context: context,
                  icon: history.isSent ? Icons.check_circle : Icons.schedule,
                  label: 'Status',
                  value: history.isSent ? 'Terkirim' : 'Belum Terkirim',
                  valueColor: history.isSent ? Colors.green : Colors.orange,
                ),
                if (history.isSent && history.sentAt != null) ...[
                  const SizedBox(height: 12),
                  _detailItem(
                    context: context,
                    icon: Icons.send,
                    label: 'Tanggal Kirim',
                    value: Utils.formatDate(
                      history.sentAt!,
                      format: 'dd MMMM yyyy, HH:mm',
                    ),
                  ),
                ],
                if (history.notes != null && history.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _detailItem(
                    context: context,
                    icon: Icons.note,
                    label: 'Catatan',
                    value: history.notes!,
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
              if (!history.isSent)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _markAsSent(context, history);
                  },
                  child: const Text('Tandai Terkirim'),
                ),
            ],
          ),
    );
  }

  // Widget untuk item detail
  Widget _detailItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: valueColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
