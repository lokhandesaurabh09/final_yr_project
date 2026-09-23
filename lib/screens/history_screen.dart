import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyItems = [
      _HistoryItem('Powdery Mildew', 'Moderate', 'Today, 9:42 AM', false,
          AppColors.warningAmber, 94),
      _HistoryItem('Healthy Leaf', 'No disease', 'Today, 9:15 AM', true,
          AppColors.healthyGreen, 99),
      _HistoryItem('Black Rot', 'Severe', 'Yesterday, 3:00 PM', false,
          AppColors.diseaseRed, 91),
      _HistoryItem('Healthy Leaf', 'No disease', 'Yesterday, 11:00 AM', true,
          AppColors.healthyGreen, 97),
      _HistoryItem('Downy Mildew', 'Mild', 'Sep 21, 2:30 PM', false,
          AppColors.warningAmber, 88),
      _HistoryItem('Leaf Blight', 'Moderate', 'Sep 20, 10:10 AM', false,
          AppColors.warningAmber, 85),
    ];

    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      appBar: AppBar(
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary strip
          Container(
            color: AppColors.primaryGreen,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryStat(
                    value: historyItems.length.toString(), label: 'Total Scans'),
                _SummaryStat(
                  value: historyItems
                      .where((i) => !i.isHealthy)
                      .length
                      .toString(),
                  label: 'Diseases Found',
                ),
                _SummaryStat(
                  value: historyItems
                      .where((i) => i.isHealthy)
                      .length
                      .toString(),
                  label: 'Healthy',
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: historyItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.severityColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.isHealthy
                            ? Icons.check_circle_rounded
                            : Icons.warning_amber_rounded,
                        color: item.severityColor,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.severityColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.severity,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: item.severityColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${item.confidence}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentGreen,
                          ),
                        ),
                        const Text(
                          'conf.',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem {
  final String name, severity, date;
  final bool isHealthy;
  final Color severityColor;
  final int confidence;

  _HistoryItem(this.name, this.severity, this.date, this.isHealthy,
      this.severityColor, this.confidence);
}

class _SummaryStat extends StatelessWidget {
  final String value, label;
  const _SummaryStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
