import 'package:flutter/material.dart';
 
import '../theme/app_theme.dart';
 
/// Simple grape-cluster + leaf mark drawn in code (no image asset needed).
/// Replace with your team's official logo file when you have it.
class GrapeLogo extends StatelessWidget {
  final double size;
 
  /// true = white grapes for dark/gradient backgrounds.
  final bool onDark;
 
  const GrapeLogo({super.key, this.size = 64, this.onDark = false});
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'GrapeCare AI logo',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _GrapeLogoPainter(onDark: onDark)),
      ),
    );
  }
}
 
class _GrapeLogoPainter extends CustomPainter {
  final bool onDark;
  const _GrapeLogoPainter({required this.onDark});
 
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
 
    // Leaves
    final leafColor = onDark ? AppColors.primaryGlow : AppColors.primaryLight;
    final leaf = Paint()..color = leafColor;
    canvas.drawPath(
      Path()
        ..moveTo(49, 34)
        ..cubicTo(28, 34, 20, 14, 38, 5)
        ..cubicTo(52, 10, 58, 24, 49, 34)
        ..close(),
      leaf,
    );
    canvas.drawPath(
      Path()
        ..moveTo(52, 34)
        ..cubicTo(66, 30, 78, 18, 74, 6)
        ..cubicTo(60, 6, 50, 18, 52, 34)
        ..close(),
      Paint()..color = leafColor.withValues(alpha: 0.75),
    );
 
    // Grapes (rows of 4, 3, 2, 1)
    const r = 8.6;
    const counts = [4, 3, 2, 1];
    for (var row = 0; row < counts.length; row++) {
      final c = counts[row];
      final y = 40.0 + row * 15;
      for (var i = 0; i < c; i++) {
        final x = 50 + (i - (c - 1) / 2) * 17;
        final center = Offset(x, y);
        final rect = Rect.fromCircle(center: center, radius: r);
        canvas.drawCircle(
          center,
          r,
          Paint()
            ..shader = RadialGradient(
              center: const Alignment(-0.35, -0.4),
              colors: onDark
                  ? const [Colors.white, Color(0xFFCFE8D6)]
                  : const [AppColors.primaryLight, AppColors.primaryDark],
            ).createShader(rect),
        );
      }
    }
  }
 
  @override
  bool shouldRepaint(covariant _GrapeLogoPainter old) => old.onDark != onDark;
}