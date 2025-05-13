import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';
import 'package:spin_wheels/presentation/widgets/spin_history_table_widget.dart';

/// Layar riwayat spin
class SpinHistoryScreen extends StatefulWidget {
  const SpinHistoryScreen({super.key});

  @override
  State<SpinHistoryScreen> createState() => _SpinHistoryScreenState();
}

class _SpinHistoryScreenState extends State<SpinHistoryScreen> {
  @override
  void initState() {
    super.initState();
    
    // Memuat data riwayat spin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpinHistoryProvider>(context, listen: false).loadSpinHistories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Spin'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final spinHistoryProvider = Provider.of<SpinHistoryProvider>(context, listen: false);
              spinHistoryProvider.loadSpinHistories();
              spinHistoryProvider.loadStatistics();
            },
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      body: const SpinHistoryTableWidget(),
    );
  }
}
