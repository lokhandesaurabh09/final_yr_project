import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  bool _analyzing = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResultScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera placeholder
          Positioned.fill(
            child: Container(
              color: const Color(0xFF050A07),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_rounded,
                        size: 60,
                        color: Colors.white.withValues(alpha: 0.08)),
                    const SizedBox(height: 12),
                    Text(
                      'Camera Preview',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.15),
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scan frame
          Positioned.fill(
            child: CustomPaint(painter: _FramePainter(pulse: _pulseAnim)),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Scan Leaf',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.flash_off_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Center instruction
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 320),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _analyzing
                      ? const Column(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Analyzing leaf...',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Center a grape leaf in the frame',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.transparent
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SideBtn(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      onTap: _scan),
                  // Main shutter
                  GestureDetector(
                    onTap: _analyzing ? null : _scan,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, child) => Transform.scale(
                        scale: _analyzing ? 1.0 : _pulseAnim.value,
                        child: child,
                      ),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _analyzing ? AppColors.primaryDim : AppColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: _analyzing
                            ? const Padding(
                                padding: EdgeInsets.all(22),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(Icons.camera_rounded,
                                color: Colors.black, size: 32),
                      ),
                    ),
                  ),
                  _SideBtn(
                      icon: Icons.flip_camera_ios_rounded,
                      label: 'Flip',
                      onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SideBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  final Animation<double> pulse;
  _FramePainter({required this.pulse}) : super(repaint: pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.7 * pulse.value)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2 - 40;
    const half = 120.0;
    const corner = 24.0;

    final l = cx - half;
    final r = cx + half;
    final t = cy - half;
    final b = cy + half;

    canvas.drawLine(Offset(l, t + corner), Offset(l, t), paint);
    canvas.drawLine(Offset(l, t), Offset(l + corner, t), paint);
    canvas.drawLine(Offset(r - corner, t), Offset(r, t), paint);
    canvas.drawLine(Offset(r, t), Offset(r, t + corner), paint);
    canvas.drawLine(Offset(l, b - corner), Offset(l, b), paint);
    canvas.drawLine(Offset(l, b), Offset(l + corner, b), paint);
    canvas.drawLine(Offset(r - corner, b), Offset(r, b), paint);
    canvas.drawLine(Offset(r, b), Offset(r, b - corner), paint);
  }

  @override
  bool shouldRepaint(_FramePainter old) => false;
}
