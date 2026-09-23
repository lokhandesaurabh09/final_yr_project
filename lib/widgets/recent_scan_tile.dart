import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentScanTile extends StatelessWidget {
  final String diseaseName;
  final String severity;
  final String date;
  final bool isHealthy;
  final Color severityColor;

  const RecentScanTile({
    super.key,
    required this.diseaseName,
    required this.severity,
    required this.date,
    required this.isHealthy,
    required this.severityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isHealthy
                ? Icons.eco_rounded
                : Icons.coronavirus_rounded,
            color: severityColor,
            size: 24,
          ),
        ),
        title: Text(
          diseaseName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                severity,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: severityColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                date,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textLight),
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
