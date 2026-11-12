import 'package:flutter/material.dart';
 
import 'scan_image.dart';
 
/// Placeholder leaf thumbnail until real scan photos are stored.
/// [spot] = colour of the disease spots (null for a healthy leaf).
/// When [imagePath] is set the real photo is shown instead of the drawing.
class LeafThumb extends StatelessWidget {
  final double size;
  final Color? spot;
  final double radius;
  final String? imagePath;
 
  const LeafThumb({
    super.key,
    this.size = 56,
    this.spot,
    this.radius = 14,
    this.imagePath,
  });
 
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: imagePath != null
            ? ScanImage(
                path: imagePath!,
                fallback: CustomPaint(painter: _LeafThumbPainter(spot: spot)),
              )
            : CustomPaint(painter: _LeafThumbPainter(spot: spot)),
      ),
    );
  }
}
 
class _LeafThumbPainter extends CustomPainter {
  final Color? spot;
  const _LeafThumbPainter({this.spot});
 
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rect = Offset.zero & size;
 
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDDE9D4), Color(0xFFBFD5B4)],
        ).createShader(rect),
    );
 
    final leaf = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..cubicTo(w * 0.88, h * 0.2, w * 0.92, h * 0.7, w * 0.5, h * 0.92)
      ..cubicTo(w * 0.08, h * 0.7, w * 0.12, h * 0.2, w * 0.5, h * 0.1)
      ..close();
    canvas.drawPath(
      leaf,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF52B788), Color(0xFF2D6A4F)],
        ).createShader(rect),
    );
    canvas.drawLine(
      Offset(w * 0.5, h * 0.88),
      Offset(w * 0.5, h * 0.16),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
 
    if (spot != null) {
      final p = Paint()..color = spot!.withValues(alpha: 0.8);
      canvas.drawCircle(Offset(w * 0.42, h * 0.4), w * 0.08, p);
      canvas.drawCircle(Offset(w * 0.62, h * 0.55), w * 0.1, p);
    }
  }
 
  @override
  bool shouldRepaint(covariant _LeafThumbPainter old) => old.spot != spot;
}