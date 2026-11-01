import 'dart:math' as math;
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import '../data/disease_catalog.dart';
import '../l10n/app_localizations.dart';
import '../models/scan_result.dart';
import '../providers/app_locale.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/grape_logo.dart';
import '../widgets/indicators/severity_chip.dart';
import '../widgets/leaf_thumb.dart';
import '../widgets/section_header.dart';
import 'history_screen.dart';
import 'result_screen.dart';
import 'scan_screen.dart';
 
// TODO(l10n): a few English-only strings below (weather text, advisory).
// TODO(weather): replace the demo weather / risk numbers with real data.
 
void _openScan(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const ScanScreen()),
  );
}
 
void _openResult(BuildContext context, ScanResult r) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ResultScreen(result: r)),
  );
}
 
String _sevText(AppLocalizations l, DiseaseSeverity s) => switch (s) {
      DiseaseSeverity.healthy => l.noDisease,
      DiseaseSeverity.mild => l.mild,
      DiseaseSeverity.moderate => l.moderate,
      DiseaseSeverity.severe => l.severe,
    };
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
 
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _Dashboard(onViewAll: () => setState(() => _selectedIndex = 1)),
          const HistoryScreen(),
        ],
      ),
      floatingActionButton: Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.brandGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _openScan(context),
            child: Tooltip(
              message: l10n.scanNow,
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: AppColors.primaryDark.withValues(alpha: 0.15),
        height: 68,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(
              child: _NavBtn(
                icon: Icons.dashboard_rounded,
                label: l10n.dashboard,
                active: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
            ),
            const SizedBox(width: 84), // space for the centre camera button
            Expanded(
              child: _NavBtn(
                icon: Icons.history_rounded,
                label: l10n.history,
                active: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
class _NavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
 
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textTertiary;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryMuted : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
 
// ===========================================================================
// Dashboard
// ===========================================================================
 
class _Dashboard extends StatelessWidget {
  final VoidCallback onViewAll;
  const _Dashboard({required this.onViewAll});
 
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scans = context.watch<ScanProvider>();
    final lang = Localizations.localeOf(context).languageCode;
    final gutter = MediaQuery.sizeOf(context).width < 600 ? 16.0 : 32.0;
 
    // Most recent scan that needs action.
    final attention = scans.scans
        .where((s) =>
            s.severity == DiseaseSeverity.severe ||
            s.severity == DiseaseSeverity.moderate)
        .firstOrNull;
 
    const gap = SizedBox(height: 18);
 
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, 12, gutter, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Reveal(
                    index: 0,
                    child: _Header(
                      greeting: l10n.goodMorning,
                      hasAlert: attention != null,
                      onBell: () {
                        if (attention != null) {
                          _openResult(context, attention);
                        } else {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(const SnackBar(
                                content: Text('No new alerts')));
                        }
                      },
                    ),
                  ),
                  gap,
                  _Reveal(
                    index: 1,
                    child: _HeroCard(
                      title: l10n.scanNow,
                      subtitle: l10n.centerLeaf,
                      scanLabel: l10n.scanLeaf,
                      galleryLabel: l10n.gallery,
                      showDemo: scans.classifier.isMock,
                      onScan: () => _openScan(context),
                      onGallery: () => _openScan(context), // TODO(image_picker)
                    ),
                  ),
                  gap,
                  _Reveal(
                    index: 2,
                    child: scans.loaded
                        ? _HealthCard(
                            title: l10n.vineyardHealth,
                            healthyLabel: l10n.healthy,
                            diseasedLabel: l10n.diseased,
                            totalLabel: l10n.total,
                            total: scans.total,
                            healthy: scans.healthyCount,
                            diseased: scans.diseasedCount,
                          )
                        : const _Skeleton(height: 170),
                  ),
                  if (attention != null) ...[
                    gap,
                    _Reveal(
                      index: 3,
                      child: _AttentionCard(
                        title: l10n.diseaseDetected,
                        name: DiseaseCatalog.byId(attention.diseaseId)
                            .name(lang),
                        detail: '${_sevText(l10n, attention.severity)}  ·  '
                            '${dayGroupLabel(attention.createdAt)}, '
                            '${timeLabel(attention.createdAt)}',
                        severe: attention.severity == DiseaseSeverity.severe,
                        onTap: () => _openResult(context, attention),
                      ),
                    ),
                  ],
                  gap,
                  _Reveal(
                    index: 4,
                    child: _ConditionsCard(l10n: l10n, lang: lang),
                  ),
                  const SizedBox(height: 24),
                  _Reveal(
                    index: 5,
                    child: SectionHeader(
                      title: l10n.recentScans,
                      actionLabel: l10n.viewAll,
                      onAction: onViewAll,
                    ),
                  ),
                  _Reveal(
                    index: 6,
                    child: _RecentList(
                      scans: scans,
                      l10n: l10n,
                      lang: lang,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 
/// Fade + slide-up entrance, slightly later for each [index].
class _Reveal extends StatelessWidget {
  final int index;
  final Widget child;
  const _Reveal({required this.index, required this.child});
 
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 18 * (1 - v)), child: child),
      ),
      child: child,
    );
  }
}
 
class _Skeleton extends StatelessWidget {
  final double height;
  const _Skeleton({required this.height});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------
 
class _Header extends StatelessWidget {
  final String greeting;
  final bool hasAlert;
  final VoidCallback onBell;
  const _Header({
    required this.greeting,
    required this.hasAlert,
    required this.onBell,
  });
 
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const GrapeLogo(size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const Text(
                'GrapeCare AI',
                style: TextStyle(
                  fontSize: 22,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
        const _LanguageToggle(),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Alerts',
          child: Material(
            color: AppColors.surface,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.border),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBell,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_none_rounded,
                        size: 23, color: AppColors.textPrimary),
                    if (hasAlert)
                      Positioned(
                        top: 10,
                        right: 11,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.surface, width: 1.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
 
class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();
 
  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppLocaleController>();
    final current = Localizations.localeOf(context);
    final isEn = current.languageCode == 'en';
 
    return Semantics(
      button: true,
      label: 'Change language',
      child: Material(
        color: AppColors.primaryMuted,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () =>
              controller.setLocale(isEn ? const Locale('mr') : const Locale('en')),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.translate_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  isEn ? 'मराठी' : 'EN',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Hero
// ---------------------------------------------------------------------------
 
class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String scanLabel;
  final String galleryLabel;
  final bool showDemo;
  final VoidCallback onScan;
  final VoidCallback onGallery;
 
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.scanLabel,
    required this.galleryLabel,
    required this.showDemo,
    required this.onScan,
    required this.onGallery,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -26,
            bottom: -30,
            child: Opacity(
              opacity: 0.14,
              child: const GrapeLogo(size: 200, onDark: true),
            ),
          ),
          Positioned(
            top: -70,
            left: -50,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'AI LEAF SCAN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (showDemo)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: AppColors.amber.withValues(alpha: 0.7)),
                        ),
                        child: const Text(
                          'DEMO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: AppColors.amber,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _HeroButton(
                        label: scanLabel,
                        icon: Icons.camera_alt_rounded,
                        filled: true,
                        onTap: onScan,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _HeroButton(
                        label: galleryLabel,
                        icon: Icons.photo_library_outlined,
                        filled: false,
                        onTap: onGallery,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 
class _HeroButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  const _HeroButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final fg = filled ? AppColors.primaryDark : Colors.white;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: filled ? Colors.white : Colors.white.withValues(alpha: 0.16),
        shape: StadiumBorder(
          side: filled
              ? BorderSide.none
              : BorderSide(color: Colors.white.withValues(alpha: 0.32)),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Vineyard health (donut + legend)
// ---------------------------------------------------------------------------
 
class _HealthCard extends StatelessWidget {
  final String title;
  final String healthyLabel;
  final String diseasedLabel;
  final String totalLabel;
  final int total;
  final int healthy;
  final int diseased;
 
  const _HealthCard({
    required this.title,
    required this.healthyLabel,
    required this.diseasedLabel,
    required this.totalLabel,
    required this.total,
    required this.healthy,
    required this.diseased,
  });
 
  @override
  Widget build(BuildContext context) {
    final hf = total == 0 ? 0.0 : healthy / total;
    final df = total == 0 ? 0.0 : diseased / total;
 
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 118,
                height: 118,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (_, t, __) => CustomPaint(
                    painter: _DonutPainter(
                      healthyFraction: hf,
                      diseasedFraction: df,
                      progress: t,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(hf * 100 * t).round()}%',
                            style: const TextStyle(
                              fontSize: 26,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            healthyLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  children: [
                    _LegendRow(
                      color: AppColors.success,
                      label: healthyLabel,
                      value: '$healthy',
                    ),
                    const SizedBox(height: 14),
                    _LegendRow(
                      color: AppColors.amber,
                      label: diseasedLabel,
                      value: '$diseased',
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),
                    _LegendRow(
                      color: AppColors.textTertiary,
                      label: totalLabel,
                      value: '$total',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });
 
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
 
class _DonutPainter extends CustomPainter {
  final double healthyFraction;
  final double diseasedFraction;
  final double progress;
 
  const _DonutPainter({
    required this.healthyFraction,
    required this.diseasedFraction,
    required this.progress,
  });
 
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.shortestSide / 2 - stroke / 2,
    );
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
 
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      base..color = AppColors.primaryMuted,
    );
 
    if (healthyFraction + diseasedFraction == 0) return;
 
    final both = healthyFraction > 0 && diseasedFraction > 0;
    final gap = both ? 0.10 : 0.0;
    const full = math.pi * 2;
    final cap = both ? StrokeCap.butt : StrokeCap.round;
 
    final hSweep = full * healthyFraction * progress;
    final dSweep = full * diseasedFraction * progress;
 
    if (healthyFraction > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + gap / 2,
        math.max(0.001, hSweep - gap),
        false,
        base
          ..color = AppColors.success
          ..strokeCap = cap,
      );
    }
    if (diseasedFraction > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + hSweep + gap / 2,
        math.max(0.001, dSweep - gap),
        false,
        base
          ..color = AppColors.amber
          ..strokeCap = cap,
      );
    }
  }
 
  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.healthyFraction != healthyFraction ||
      old.diseasedFraction != diseasedFraction ||
      old.progress != progress;
}
 
// ---------------------------------------------------------------------------
// Needs attention
// ---------------------------------------------------------------------------
 
class _AttentionCard extends StatelessWidget {
  final String title;
  final String name;
  final String detail;
  final bool severe;
  final VoidCallback onTap;
 
  const _AttentionCard({
    required this.title,
    required this.name,
    required this.detail,
    required this.severe,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final color = severe ? AppColors.danger : AppColors.warning;
    final bg = severe ? AppColors.dangerMuted : AppColors.warningMuted;
 
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.large),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.warning_amber_rounded, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Conditions: weather + disease risk (demo values)
// ---------------------------------------------------------------------------
 
class _ConditionsCard extends StatelessWidget {
  final AppLocalizations l10n;
  final String lang;
  const _ConditionsCard({required this.l10n, required this.lang});
 
  // Demo values. Replace with live weather + rule-based risk later.
  static const _risks = [
    ('powdery_mildew', 72),
    ('black_rot', 45),
    ('downy_mildew', 28),
    ('leaf_blight', 18),
  ];
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.wb_sunny_rounded,
                    size: 19, color: AppColors.warning),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.vineyardWeather,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Nashik, MH',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningMuted,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'DEMO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '28',
                style: TextStyle(
                  fontSize: 56,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                  color: AppColors.textPrimary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8, left: 2),
                child: Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Partly cloudy',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Good for field work',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.water_drop_rounded,
                  value: '72%',
                  label: l10n.humidity,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  icon: Icons.air_rounded,
                  value: '12 km/h',
                  label: l10n.wind,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  icon: Icons.thermostat_rounded,
                  value: '31°C',
                  label: l10n.feelsLike,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 18),
          Text(
            l10n.diseaseRiskIndex,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _risks.length; i += 2) ...[
            Row(
              children: [
                Expanded(child: _RiskRow(id: _risks[i].$1, pct: _risks[i].$2, lang: lang)),
                const SizedBox(width: 18),
                Expanded(
                  child: _RiskRow(
                      id: _risks[i + 1].$1, pct: _risks[i + 1].$2, lang: lang),
                ),
              ],
            ),
            if (i + 2 < _risks.length) const SizedBox(height: 14),
          ],
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryExtraMuted,
              borderRadius: BorderRadius.circular(AppRadii.control),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 18, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo advice: high humidity favours powdery mildew. '
                    'Inspect your vines today. Values are illustrative, not '
                    'live weather.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
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
 
class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.control),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.weatherBlue),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
 
class _RiskRow extends StatelessWidget {
  final String id;
  final int pct;
  final String lang;
  const _RiskRow({required this.id, required this.pct, required this.lang});
 
  @override
  Widget build(BuildContext context) {
    final color = SeverityStyle.forPercent(pct.toDouble());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DiseaseCatalog.byId(id).name(lang),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: pct / 100),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              minHeight: 7,
              color: color,
              backgroundColor: AppColors.border,
            ),
          ),
        ),
      ],
    );
  }
}
 
// ---------------------------------------------------------------------------
// Recent scans
// ---------------------------------------------------------------------------
 
class _RecentList extends StatelessWidget {
  final ScanProvider scans;
  final AppLocalizations l10n;
  final String lang;
  const _RecentList({
    required this.scans,
    required this.l10n,
    required this.lang,
  });
 
  @override
  Widget build(BuildContext context) {
    if (!scans.loaded) {
      return const Column(
        children: [
          _Skeleton(height: 76),
          SizedBox(height: 10),
          _Skeleton(height: 76),
        ],
      );
    }
    final recent = scans.recent(3);
    if (recent.isEmpty) {
      return AppCard(
        shadow: false,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.eco_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                l10n.tapCamera,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final r in recent)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ScanTile(result: r, l10n: l10n, lang: lang),
          ),
      ],
    );
  }
}
 
class _ScanTile extends StatelessWidget {
  final ScanResult result;
  final AppLocalizations l10n;
  final String lang;
  const _ScanTile({
    required this.result,
    required this.l10n,
    required this.lang,
  });
 
  @override
  Widget build(BuildContext context) {
    final ui = toUiSeverity(result.severity);
    final color = ui.color;
 
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () => _openResult(context, result),
      child: Row(
        children: [
          LeafThumb(size: 56, spot: result.isHealthy ? null : color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DiseaseCatalog.byId(result.diseaseId).name(lang),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SeverityChip(
                      label: _sevText(l10n, result.severity),
                      severity: ui,
                    ),
                    Text(
                      '${dayGroupLabel(result.createdAt)}, '
                      '${timeLabel(result.createdAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(result.confidence * 100).round()}%',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              if (result.isSample)
                const Text(
                  'sample',
                  style: TextStyle(
                      fontSize: 10.5, color: AppColors.textTertiary),
                ),
            ],
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 20, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}