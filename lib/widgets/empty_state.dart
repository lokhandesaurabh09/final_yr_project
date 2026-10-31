import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'buttons/primary_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  color: AppColors.primaryMuted, shape: BoxShape.circle),
              child: Icon(icon, size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                  width: 200,
                  child:
                      PrimaryButton(label: actionLabel!, onPressed: onAction)),
            ],
          ],
        ),
      ),
    );
  }
}