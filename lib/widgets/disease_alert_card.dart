import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DiseaseAlertCard extends StatelessWidget {
  const DiseaseAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.diseaseRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.diseaseRed.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.diseaseRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.diseaseRed,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Black Rot Alert',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.diseaseRed,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Detected in 2 recent scans. Check neighboring plants.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textLight,
          ),
        ],
      ),
    );
  }
}
