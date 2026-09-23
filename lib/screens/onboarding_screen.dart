import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class _OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      title: 'Scan Your Grapevines',
      subtitle:
          'Point your camera at any grape leaf and instantly detect signs of disease — right in the vineyard.',
      icon: Icons.camera_alt_rounded,
      iconBg: Color(0xFF40916C),
    ),
    _OnboardingPage(
      title: 'Instant AI Diagnosis',
      subtitle:
          'Our model identifies diseases like Powdery Mildew, Black Rot, and Leaf Blight with high accuracy.',
      icon: Icons.biotech_rounded,
      iconBg: Color(0xFF1B4332),
    ),
    _OnboardingPage(
      title: 'Act Before It Spreads',
      subtitle:
          'Get treatment recommendations and track disease history across your entire vineyard.',
      icon: Icons.local_florist_rounded,
      iconBg: Color(0xFFB7410E),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: _goToHome,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: page.iconBg.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 72,
                            color: page.iconBg,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textLight,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots + Button
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 0, 36, 40),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.accentGreen
                              : AppColors.mintBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
