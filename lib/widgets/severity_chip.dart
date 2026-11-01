import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum Severity { healthy, mild, moderate, severe }

extension SeverityStyle on Severity {
  Color get color => switch (this) {
        Severity.healthy => AppColors.success,
        Severity.mild || Severity.moderate => AppColors.warning,
        Severity.severe => AppColors.danger,
      };
  Color get background => switch (this) {
        Severity.healthy => AppColors.successMuted,
        Severity.mild || Severity.moderate => AppColors.warningMuted,
        Severity.severe => AppColors.dangerMuted,
      };

  /// Maps a 0-100 risk value to a colour (for risk bars): colour follows value.
  static Color forPercent(double p) => p >= 60
      ? AppColors.danger
      : (p >= 30 ? AppColors.warning : AppColors.success);
}

/// Small pill showing a severity label. Pass a localized [label].
class SeverityChip extends StatelessWidget {
  final String label;
  final Severity severity;
  const SeverityChip({super.key, required this.label, required this.severity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: severity.background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(label,
          style: TextStyle(
              color: severity.color,
              fontSize: 12,
              fontWeight: FontWeight.w700)),
    );
  }
}
