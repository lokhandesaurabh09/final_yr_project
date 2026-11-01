import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Animated horizontal bar. [value] is 0..1.
class ConfidenceBar extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  final bool showLabel;

  const ConfidenceBar({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    final c = color ?? AppColors.primaryGlow;
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: v),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (_, anim, __) => LinearProgressIndicator(
          value: anim,
          minHeight: height,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation(c),
        ),
      ),
    );
    if (!showLabel) return bar;
    return Row(children: [
      Expanded(child: bar),
      const SizedBox(width: 10),
      Text('${(v * 100).round()}%',
          style:
              TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 13)),
    ]);
  }
}
