import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DiseaseRiskCard extends StatelessWidget {
  const DiseaseRiskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Disease Risk Index',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningMuted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'DEMO PROFILE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.large),

          // Risk bars
          _RiskBar(
            label: 'Powdery Mildew',
            risk: 0.72,
            color: AppColors.warning,
          ),
          const SizedBox(height: 10),
          _RiskBar(label: 'Black Rot', risk: 0.45, color: AppColors.danger),
          const SizedBox(height: 10),
          _RiskBar(label: 'Downy Mildew', risk: 0.28, color: AppColors.primary),
          const SizedBox(height: 10),
          _RiskBar(label: 'Leaf Blight', risk: 0.18, color: AppColors.primary),

          const SizedBox(height: AppSpacing.medium),

          const Text(
            'Illustrative values only; not calculated from live weather or scan history.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskBar extends StatelessWidget {
  final String label;
  final double risk;
  final Color color;

  const _RiskBar({
    required this.label,
    required this.risk,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(risk * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Semantics(
          label: '$label risk ${(risk * 100).toInt()} percent',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: risk,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
