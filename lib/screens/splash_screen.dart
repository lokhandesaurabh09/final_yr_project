import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import '../theme/app_theme.dart';
import '../widgets/grape_logo.dart';
import 'onboarding_screen.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  Timer? _navigationTimer;
 
  Animation<double> _interval(double a, double b,
          [Curve curve = Curves.easeOut]) =>
      CurvedAnimation(parent: _c, curve: Interval(a, b, curve: curve));
 
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();
 
    _navigationTimer = Timer(const Duration(milliseconds: 3400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }
 
  @override
  void dispose() {
    _navigationTimer?.cancel();
    _c.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final logoScale = Tween<double>(begin: 0.7, end: 1).animate(
      _interval(0.0, 0.2, Curves.easeOutBack),
    );
    final logoFade = _interval(0.0, 0.12);
    final logoBuild = _interval(0.05, 0.55, Curves.easeInOut);
    final logoShine = _interval(0.58, 0.82, Curves.easeInOut);
    final textFade = _interval(0.42, 0.72);
    final textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(_interval(0.42, 0.72));
    final loaderFade = _interval(0.7, 1.0);
 
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0B1F15),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1F15),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.35),
                  radius: 1.25,
                  colors: [
                    AppColors.primaryLight,
                    AppColors.primaryDark,
                    Color(0xFF0B1F15),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
            // Soft decorative rings
            Positioned(
              top: -90,
              right: -70,
              child: _Ring(size: 260, alpha: 0.06),
            ),
            Positioned(
              bottom: -110,
              left: -80,
              child: _Ring(size: 300, alpha: 0.05),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxLarge,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: logoFade,
                        child: ScaleTransition(
                          scale: logoScale,
                          child: Container(
                            width: 128,
                            height: 128,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.22),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: GrapeLogo(
                              size: 92,
                              onDark: true,
                              animation: logoBuild,
                              shine: logoShine,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xLarge),
                      FadeTransition(
                        opacity: textFade,
                        child: SlideTransition(
                          position: textSlide,
                          child: Column(
                            children: [
                              const Text(
                                'VineGuard',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 34,
                                  height: 1.1,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.medium),
                              Text(
                                'Healthy Grapes  |  Better Harvests',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeTransition(
                        opacity: loaderFade,
                        child: const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            strokeCap: StrokeCap.round,
                            color: AppColors.primaryGlow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xLarge),
                  child: FadeTransition(
                    opacity: loaderFade,
                    child: Text(
                      'EXPLAINABLE AI  ·  GRAPE LEAF DISEASE DETECTION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
class _Ring extends StatelessWidget {
  final double size;
  final double alpha;
  const _Ring({required this.size, required this.alpha});
 
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: alpha),
            width: 28,
          ),
        ),
      ),
    );
  }
}