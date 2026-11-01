import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import '../theme/app_theme.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/grape_logo.dart';
import 'home_screen.dart';
 
// TODO(l10n): move all strings below into the .arb files (en + mr).
 
class _OBPage {
  final String tag;
  final String title;
  final String body;
  final IconData icon;
  final List<(IconData, String)> chips;
 
  const _OBPage({
    required this.tag,
    required this.title,
    required this.body,
    required this.icon,
    required this.chips,
  });
}
 
const List<_OBPage> _pages = [
  _OBPage(
    tag: 'DETECT',
    title: 'Spot leaf diseases early',
    body: 'Scan a grape leaf with your camera or pick a photo from your '
        'gallery and get a likely diagnosis.',
    icon: Icons.document_scanner_rounded,
    chips: [
      (Icons.photo_camera_outlined, 'Camera or gallery'),
      (Icons.bolt_rounded, 'Fast analysis'),
    ],
  ),
  _OBPage(
    tag: 'UNDERSTAND',
    title: 'See why the AI decided',
    body: 'Explainable heatmaps highlight the parts of the leaf the model '
        'focused on, so you can check the result yourself.',
    icon: Icons.insights_rounded,
    chips: [
      (Icons.layers_rounded, 'Heatmap overlay'),
      (Icons.leaderboard_rounded, 'Top predictions'),
    ],
  ),
  _OBPage(
    tag: 'CARE',
    title: 'Get clear treatment tips',
    body: 'Receive simple, step-by-step guidance for each disease and keep '
        'a history of every scan.',
    icon: Icons.healing_rounded,
    chips: [
      (Icons.checklist_rounded, 'Step-by-step care'),
      (Icons.translate_rounded, 'Marathi & English'),
    ],
  ),
];
 
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
 
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
 
class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _page = 0;
 
  bool get _isLast => _page == _pages.length - 1;
 
  void _goHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
 
  void _next() {
    if (_isLast) {
      _goHome();
    } else {
      _pc.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }
 
  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlay,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryMuted, AppColors.background],
              stops: [0.0, 0.5],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.large,
                        vertical: AppSpacing.small,
                      ),
                      child: Row(
                        children: [
                          const GrapeLogo(size: 36),
                          const SizedBox(width: AppSpacing.small),
                          const Text(
                            'GrapeCare AI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          AnimatedOpacity(
                            opacity: _isLast ? 0 : 1,
                            duration: const Duration(milliseconds: 200),
                            child: IgnorePointer(
                              ignoring: _isLast,
                              child: TextButton(
                                onPressed: _goHome,
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pc,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemCount: _pages.length,
                        itemBuilder: (context, i) => _PageContent(page: _pages[i]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xLarge,
                        AppSpacing.small,
                        AppSpacing.xLarge,
                        AppSpacing.xLarge,
                      ),
                      child: Row(
                        children: [
                          Semantics(
                            label: 'Page ${_page + 1} of ${_pages.length}',
                            child: Row(
                              children: List.generate(_pages.length, (i) {
                                final active = _page == i;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(
                                      right: AppSpacing.small),
                                  width: active ? 26 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppColors.primary
                                        : AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 176,
                            child: PrimaryButton(
                              label: _isLast ? 'Get Started' : 'Continue',
                              icon: _isLast
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded,
                              onPressed: _next,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 
class _PageContent extends StatelessWidget {
  final _OBPage page;
  const _PageContent({required this.page});
 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.large,
        vertical: AppSpacing.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Hero(page: page),
          const SizedBox(height: AppSpacing.xLarge),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.xSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              page.tag,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(page.title, style: AppTypography.headline),
          const SizedBox(height: AppSpacing.medium),
          Text(page.body, style: AppTypography.bodySecondary),
          const SizedBox(height: AppSpacing.large),
        ],
      ),
    );
  }
}
 
class _Hero extends StatelessWidget {
  final _OBPage page;
  const _Hero({required this.page});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppRadii.large + 6),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: _Circle(size: 190, alpha: 0.08),
          ),
          Positioned(
            bottom: -70,
            left: -40,
            child: _Circle(size: 210, alpha: 0.07),
          ),
          Center(
            child: _Float(
              child: Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                ),
                child: Icon(page.icon, size: 62, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 18,
            child: _FloatChip(icon: page.chips[0].$1, label: page.chips[0].$2),
          ),
          Positioned(
            right: 16,
            bottom: 18,
            child: _FloatChip(icon: page.chips[1].$1, label: page.chips[1].$2),
          ),
        ],
      ),
    );
  }
}
 
class _Circle extends StatelessWidget {
  final double size;
  final double alpha;
  const _Circle({required this.size, required this.alpha});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}
 
class _FloatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FloatChip({required this.icon, required this.label});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
 
/// Gentle up-and-down floating motion.
class _Float extends StatefulWidget {
  final Widget child;
  const _Float({required this.child});
 
  @override
  State<_Float> createState() => _FloatState();
}
 
class _FloatState extends State<_Float> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);
 
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: curve,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -8 + 16 * curve.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}