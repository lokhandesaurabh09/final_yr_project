import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentScanTile extends StatelessWidget {
  final String diseaseName;
  final String severity;
  final String date;
  final bool isHealthy;
  final int confidence;
  final Color accent;

  const RecentScanTile({
    super.key,
    required this.diseaseName,
    required this.severity,
    required this.date,
    required this.isHealthy,
    required this.confidence,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isHealthy ? Icons.eco_rounded : Icons.coronavirus_rounded,
              color: accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diseaseName,
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
                        color: accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        severity,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Confidence
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$confidence%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: accent,
                  letterSpacing: -0.3,
                ),
              ),
              const Text(
                'conf',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textTertiary, size: 18),
        ],
      ),
    );
  }
}
