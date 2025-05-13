import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';
import 'package:spin_wheels/presentation/widgets/statistics_widget.dart';

/// Layar statistik
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    
    // Memuat statistik
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpinHistoryProvider>(context, listen: false).loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final spinHistoryProvider = Provider.of<SpinHistoryProvider>(context, listen: false);
              spinHistoryProvider.loadStatistics();
            },
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      body: const StatisticsWidget(),
    );
  }
}
