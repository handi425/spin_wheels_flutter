import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/presentation/providers/prize_provider.dart';
import 'package:spin_wheels/presentation/widgets/add_prize_dialog.dart';
import 'package:spin_wheels/presentation/widgets/prize_list_widget.dart';

/// Layar hadiah
class PrizesScreen extends StatefulWidget {
  const PrizesScreen({super.key});

  @override
  State<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Memuat data hadiah
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrizeProvider>(context, listen: false).loadPrizes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mencari hadiah
  void _searchPrizes(String query) {
    final prizeProvider = Provider.of<PrizeProvider>(context, listen: false);
    prizeProvider.searchPrizes(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadiah'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final prizeProvider = Provider.of<PrizeProvider>(
                context,
                listen: false,
              );
              prizeProvider.loadPrizes();
            },
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Hadiah',
                prefixIcon: const Icon(Icons.search),
                suffix: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchPrizes('');
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: _searchPrizes,
            ),
          ),
          Consumer<PrizeProvider>(
            builder: (context, prizeProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Hadiah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prizeProvider.prizes.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Card(
                        color: Colors.green,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tersedia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prizeProvider.availablePrizes.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(child: PrizeListWidget()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditPrizeDialog(context: context),
        tooltip: 'Tambah Hadiah',
        child: const Icon(Icons.add),
      ),
    );
  }
}
