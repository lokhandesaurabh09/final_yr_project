import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item('Powdery Mildew', 'Moderate', 'Today, 9:42 AM', false,
          AppColors.warning, 94),
      _Item('Healthy Leaf', 'No disease', 'Today, 9:15 AM', true,
          AppColors.primary, 99),
      _Item('Black Rot', 'Severe', 'Yesterday, 3:00 PM', false,
          AppColors.danger, 91),
      _Item('Healthy Leaf', 'No disease', 'Yesterday, 11:00 AM', true,
          AppColors.primary, 97),
      _Item('Downy Mildew', 'Mild', 'Sep 21, 2:30 PM', false,
          AppColors.warning, 88),
      _Item('Leaf Blight', 'Moderate', 'Sep 20, 10:10 AM', false,
          AppColors.warning, 85),
    ];

    final diseased = items.where((i) => !i.healthy).length;
    final healthy = items.where((i) => i.healthy).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Scan History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded,
                color: AppColors.textSecondary, size: 20),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // Summary row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: AppColors.surface,
            child: Row(
              children: [
                _SummaryChip(
                    value: '${items.length}',
                    label: 'Total',
                    color: AppColors.textSecondary),
                const SizedBox(width: 10),
                _SummaryChip(
                    value: '$diseased',
                    label: 'Diseased',
                    color: AppColors.danger),
                const SizedBox(width: 10),
                _SummaryChip(
                    value: '$healthy',
                    label: 'Healthy',
                    color: AppColors.primary),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'This week',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          item.healthy
                              ? Icons.eco_rounded
                              : Icons.coronavirus_rounded,
                          color: item.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        item.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    item.severity,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: item.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.date,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item.confidence}%',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: item.color,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Text(
                            'conf',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textTertiary, size: 18),
                    ],
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

class _Item {
  final String name, severity, date;
  final bool healthy;
  final Color color;
  final int confidence;

  _Item(this.name, this.severity, this.date, this.healthy, this.color,
      this.confidence);
}

class _SummaryChip extends StatelessWidget {
  final String value, label;
  final Color color;
  const _SummaryChip(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
