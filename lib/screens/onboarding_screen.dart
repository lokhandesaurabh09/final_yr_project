import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class _OBPage {
  final String tag;
  final String title;
  final String body;
  final IconData icon;
  final Color accent;

  const _OBPage({
    required this.tag,
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _page = 0;

  final List<_OBPage> _pages = const [
    _OBPage(
      tag: '01 — SCAN',
      title: 'Point.\nDetect.\nAct.',
      body: 'Capture any grape leaf with your camera. Our model identifies disease in under two seconds — right in the field.',
      icon: Icons.document_scanner_rounded,
      accent: AppColors.primary,
    ),
    _OBPage(
      tag: '02 — DIAGNOSE',
      title: 'AI-powered\ndiagnosis.',
      body: 'Identifies Powdery Mildew, Black Rot, Leaf Blight, Downy Mildew and more with high confidence scores.',
      icon: Icons.biotech_rounded,
      accent: AppColors.weatherBlue,
    ),
    _OBPage(
      tag: '03 — PROTECT',
      title: 'Stop spread\nbefore it starts.',
      body: 'Track disease history, get treatment plans, and monitor vineyard health — all in one place.',
      icon: Icons.shield_rounded,
      accent: AppColors.warning,
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _pc.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_page];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Accent glow
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: 60,
            right: _page % 2 == 0 ? -60 : 60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.accent.withValues(alpha: 0.06),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryMuted,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.grain_rounded,
                                size: 16, color: AppColors.primary),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'VineGuard',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _next,
                        child: const Text(
                          'Skip →',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pc,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final p = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            // Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: p.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: p.accent.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                p.tag,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: p.accent,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            // Icon
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: p.accent.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: p.accent.withValues(alpha: 0.15)),
                              ),
                              child: Icon(p.icon, color: p.accent, size: 30),
                            ),
                            const SizedBox(height: 32),
                            // Title
                            Text(
                              p.title,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.1,
                                letterSpacing: -1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Body
                            Text(
                              p.body,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                height: 1.65,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
                  child: Row(
                    children: [
                      // Dots
                      Row(
                        children: List.generate(_pages.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            width: _page == i ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _page == i
                                  ? AppColors.primary
                                  : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      // Next button
                      GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _page == _pages.length - 1
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
