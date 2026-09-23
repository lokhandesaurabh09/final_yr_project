import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isAnalyzing = false;

  Future<void> _simulate() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isAnalyzing = false);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera viewfinder placeholder
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0A1A10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Camera Preview',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(Integrate camera_plugin here)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.15),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scanning frame overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _ScanFramePainter(),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: Colors.white,
                  ),
                  const Expanded(
                    child: Text(
                      'Scan Leaf',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.flash_auto_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Instruction text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.17,
            left: 0,
            right: 0,
            child: Text(
              'Center a grape leaf in the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Disease tips
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Color(0xFF74C69D), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Make sure the leaf is well-lit',
                          style: TextStyle(
                            color: Color(0xFF74C69D),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Camera controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery button
                      _RoundButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        onTap: _simulate,
                      ),

                      // Shutter button
                      GestureDetector(
                        onTap: _isAnalyzing ? null : _simulate,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isAnalyzing
                                ? AppColors.accentGreen.withOpacity(0.7)
                                : Colors.white,
                            border: Border.all(
                              color: AppColors.accentGreen,
                              width: 4,
                            ),
                          ),
                          child: _isAnalyzing
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 34,
                                ),
                        ),
                      ),

                      // Flip camera
                      _RoundButton(
                        icon: Icons.flip_camera_ios_rounded,
                        label: 'Flip',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF52B788)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double cx = size.width / 2;
    final double cy = size.height / 2 - 40;
    const double half = 130.0;
    const double corner = 28.0;

    final double l = cx - half;
    final double r = cx + half;
    final double t = cy - half;
    final double b = cy + half;

    // Top-left
    canvas.drawLine(Offset(l, t + corner), Offset(l, t), paint);
    canvas.drawLine(Offset(l, t), Offset(l + corner, t), paint);
    // Top-right
    canvas.drawLine(Offset(r - corner, t), Offset(r, t), paint);
    canvas.drawLine(Offset(r, t), Offset(r, t + corner), paint);
    // Bottom-left
    canvas.drawLine(Offset(l, b - corner), Offset(l, b), paint);
    canvas.drawLine(Offset(l, b), Offset(l + corner, b), paint);
    // Bottom-right
    canvas.drawLine(Offset(r - corner, b), Offset(r, b), paint);
    canvas.drawLine(Offset(r, b), Offset(r, b - corner), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
