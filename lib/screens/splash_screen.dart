import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle green glow top-left
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.07),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: AnimatedBuilder(
                animation: _slideAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _slideAnim.value),
                  child: child,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo mark
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryMuted,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.grain_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'VineGuard',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Grape Disease Intelligence',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 56),
                    // Loading indicator
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Version tag bottom
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
