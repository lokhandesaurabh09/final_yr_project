import 'package:flutter/material.dart';
 
import '../theme/app_theme.dart';
 
/// VineGuard mark: a shield (protection) holding a grape cluster and leaves.
/// Drawn in code, so it stays sharp at any size and needs no asset file.
///
/// Pass [animation] (0..1) to play the build-up: the shield outline draws,
/// the fill fades in, grapes pop in one by one, then the leaves unfurl.
/// Pass [shine] (0..1) for a light sweep across the shield.
/// With no animation the logo is fully drawn.
class GrapeLogo extends StatelessWidget {
  final double size;
 
  /// true = lighter shield with a white border, for dark backgrounds.
  final bool onDark;
  final Animation<double>? animation;
  final Animation<double>? shine;
 
  const GrapeLogo({
    super.key,
    this.size = 64,
    this.onDark = false,
    this.animation,
    this.shine,
  });
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'VineGuard logo',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _LogoPainter(onDark: onDark, build: animation, shine: shine),
        ),
      ),
    );
  }
}
 
class _LogoPainter extends CustomPainter {
  final bool onDark;
  final Animation<double>? build;
  final Animation<double>? shine;
 
  _LogoPainter({required this.onDark, this.build, this.shine})
      : super(repaint: Listenable.merge([build, shine]));
 
  static Path _shield() => Path()
    ..moveTo(50, 5)
    ..cubicTo(64, 12, 78, 15, 90, 16)
    ..lineTo(90, 50)
    ..cubicTo(90, 72, 72, 86, 50, 95)
    ..cubicTo(28, 86, 10, 72, 10, 50)
    ..lineTo(10, 16)
    ..cubicTo(22, 15, 36, 12, 50, 5)
    ..close();
 
  static Path _leaf({required bool right}) {
    final m = right ? 1.0 : -1.0;
    double x(double v) => 50 + (v - 50) * m;
    return Path()
      ..moveTo(x(51), 37)
      ..cubicTo(x(58), 37, x(69), 31, x(67), 20)
      ..cubicTo(x(58), 20, x(50), 27, x(51), 37)
      ..close();
  }
 
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
 
    final t = build?.value ?? 1.0;
    double seg(double a, double b) => ((t - a) / (b - a)).clamp(0.0, 1.0);
 
    final shield = _shield();
    const box = Rect.fromLTWH(0, 0, 100, 100);
 
    // 1. Outline traces itself
    final outline = Curves.easeInOut.transform(seg(0.0, 0.45));
    final fillAlpha = Curves.easeOut.transform(seg(0.2, 0.55));
    final strokeAlpha = onDark ? 1.0 : (1 - fillAlpha);
    if (outline > 0 && strokeAlpha > 0) {
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = (onDark ? Colors.white : AppColors.primaryLight)
            .withValues(alpha: strokeAlpha);
      for (final metric in shield.computeMetrics()) {
        canvas.drawPath(metric.extractPath(0, metric.length * outline), stroke);
      }
    }
 
    // 2. Fill fades in
    if (fillAlpha > 0) {
      canvas.saveLayer(
        box,
        Paint()..color = Colors.white.withValues(alpha: fillAlpha),
      );
      canvas.drawPath(
        shield,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: onDark
                ? const [AppColors.primaryGlow, AppColors.primaryLight]
                : const [AppColors.primaryLight, AppColors.primaryDark],
          ).createShader(box),
      );
      canvas.restore();
    }
 
    // 3. Grapes pop in (rows of 4, 3, 2, 1)
    const rows = [4, 3, 2, 1];
    var index = 0;
    for (var r = 0; r < rows.length; r++) {
      final count = rows[r];
      final y = 42.0 + r * 11.6;
      for (var i = 0; i < count; i++) {
        final cx = 50 + (i - (count - 1) / 2) * 11.6;
        final local = ((t - (0.45 + index * 0.032)) / 0.18).clamp(0.0, 1.0);
        index++;
        if (local <= 0) continue;
        final radius = 5.6 * Curves.easeOutBack.transform(local);
        if (radius < 0.05) continue;
        final center = Offset(cx, y);
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..shader = const RadialGradient(
              center: Alignment(-0.35, -0.4),
              colors: [Colors.white, Color(0xFFD3EADB)],
            ).createShader(Rect.fromCircle(center: center, radius: radius)),
        );
      }
    }
 
    // 4. Leaves unfurl from the stem
    final leafGrow = Curves.easeOutBack.transform(seg(0.72, 1.0));
    if (leafGrow > 0.01) {
      canvas.save();
      canvas.translate(50, 38);
      canvas.scale(leafGrow);
      canvas.translate(-50, -38);
      final leafPaint = Paint()
        ..color = onDark ? const Color(0xFFEAF8EF) : AppColors.primaryGlow;
      canvas.drawPath(_leaf(right: true), leafPaint);
      canvas.drawPath(
        _leaf(right: false),
        leafPaint..color = leafPaint.color.withValues(alpha: 0.78),
      );
      canvas.restore();
    }
 
    // 5. Light sweep across the shield
    final s = shine?.value ?? 0.0;
    if (shine != null && s > 0 && s < 1) {
      canvas.save();
      canvas.clipPath(shield);
      final x = -40 + 180 * s;
      final band = Path()
        ..moveTo(x, 0)
        ..lineTo(x + 22, 0)
        ..lineTo(x - 8, 100)
        ..lineTo(x - 30, 100)
        ..close();
      canvas.drawPath(
        band,
        Paint()
          ..shader = LinearGradient(colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0),
          ]).createShader(Rect.fromLTWH(x - 30, 0, 52, 100)),
      );
      canvas.restore();
    }
  }
 
  @override
  bool shouldRepaint(covariant _LogoPainter old) => old.onDark != onDark;
}