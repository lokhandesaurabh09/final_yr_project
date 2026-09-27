import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DiseaseAlertCard extends StatelessWidget {
  const DiseaseAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dangerMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.warning_rounded,
                color: AppColors.danger, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Black Rot spreading',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Detected in 2 recent scans — check neighbouring plants immediately.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textTertiary, size: 20),
        ],
      ),
    );
  }
}
