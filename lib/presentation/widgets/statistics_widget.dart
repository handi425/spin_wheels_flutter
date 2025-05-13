import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/presentation/providers/spin_history_provider.dart';

/// Widget untuk menampilkan statistik
class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinHistoryProvider>(
      builder: (context, spinHistoryProvider, child) {
        if (spinHistoryProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (spinHistoryProvider.statistics.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bar_chart,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada data statistik',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => spinHistoryProvider.loadStatistics(),
                  child: const Text('Muat Statistik'),
                ),
              ],
            ),
          );
        }

        final totalSpins = spinHistoryProvider.statistics['totalCount'] ?? 0;
        final sentCount = spinHistoryProvider.statistics['sentCount'] ?? 0;
        final unsentCount = spinHistoryProvider.statistics['unsentCount'] ?? 0;
        final prizeDistribution = spinHistoryProvider.statistics['prizeDistribution'] as List<dynamic>? ?? [];
        final userSpinCount = spinHistoryProvider.statistics['userSpinCount'] as List<dynamic>? ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statisticsCard(
                        context: context,
                        icon: Icons.casino,
                        value: totalSpins.toString(),
                        label: 'Total Spin',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      _statisticsCard(
                        context: context,
                        icon: Icons.check_circle,
                        value: sentCount.toString(),
                        label: 'Terkirim',
                        color: Colors.green,
                      ),
                      _statisticsCard(
                        context: context,
                        icon: Icons.schedule,
                        value: unsentCount.toString(),
                        label: 'Belum Terkirim',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Distribusi Hadiah'),
                Tab(text: 'Spin per Pengguna'),
                Tab(text: 'Status Pengiriman'),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPrizeDistributionChart(context, prizeDistribution),
                  _buildUserSpinCountChart(context, userSpinCount),
                  _buildSentStatusChart(context, sentCount, unsentCount),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget untuk kartu statistik
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
          radius: 25,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // Widget untuk chart distribusi hadiah
  Widget _buildPrizeDistributionChart(BuildContext context, List<dynamic> prizeDistribution) {
    if (prizeDistribution.isEmpty) {
      return const Center(
        child: Text('Belum ada data distribusi hadiah'),
      );
    }

    final sections = <PieChartSectionData>[];
    final legends = <Widget>[];
    
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];

    int totalCount = 0;
    for (final item in prizeDistribution) {
      totalCount += (item['count'] as int);
    }

    for (int i = 0; i < prizeDistribution.length; i++) {
      final item = prizeDistribution[i];
      final name = item['name'] as String;
      final count = item['count'] as int;
      final percentage = (count / totalCount) * 100;
      final color = colors[i % colors.length];

      sections.add(
        PieChartSectionData(
          color: color,
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );

      legends.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$name (${count}x)',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribusi Hadiah',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: legends,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk chart jumlah spin per pengguna
  Widget _buildUserSpinCountChart(BuildContext context, List<dynamic> userSpinCount) {
    if (userSpinCount.isEmpty) {
      return const Center(
        child: Text('Belum ada data spin per pengguna'),
      );
    }

    // Urutkan berdasarkan jumlah spin tertinggi
    userSpinCount.sort((a, b) => (b['count'] as int) - (a['count'] as int));

    // Batasi jumlah pengguna yang ditampilkan jika terlalu banyak
    final limitedUserSpinCount = userSpinCount.length > 10
        ? userSpinCount.sublist(0, 10)
        : userSpinCount;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (limitedUserSpinCount.first['count'] as int) * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final user = limitedUserSpinCount[groupIndex]['name'] as String;
                final count = limitedUserSpinCount[groupIndex]['count'] as int;
                return BarTooltipItem(
                  '$user\n$count spin',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value >= limitedUserSpinCount.length) {
                    return const SizedBox.shrink();
                  }
                  
                  final user = limitedUserSpinCount[value.toInt()]['name'] as String;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      user.length > 8 ? '${user.substring(0, 8)}...' : user,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          barGroups: List.generate(
            limitedUserSpinCount.length,
            (index) {
              final count = limitedUserSpinCount[index]['count'] as int;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: count.toDouble(),
                    width: 20,
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              );
            },
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget untuk chart status pengiriman
  Widget _buildSentStatusChart(BuildContext context, int sentCount, int unsentCount) {
    if (sentCount == 0 && unsentCount == 0) {
      return const Center(
        child: Text('Belum ada data status pengiriman'),
      );
    }

    final sections = <PieChartSectionData>[
      PieChartSectionData(
        color: Colors.green,
        value: sentCount.toDouble(),
        title: '${sentCount > 0 ? ((sentCount / (sentCount + unsentCount)) * 100).toStringAsFixed(1) : 0}%',
        radius: 100,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: unsentCount.toDouble(),
        title: '${unsentCount > 0 ? ((unsentCount / (sentCount + unsentCount)) * 100).toStringAsFixed(1) : 0}%',
        radius: 100,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ];

    final legends = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Text(
              'Terkirim ($sentCount)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              'Belum Terkirim ($unsentCount)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Pengiriman',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...legends,
                const SizedBox(height: 16),
                Text(
                  'Total: ${sentCount + unsentCount}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
