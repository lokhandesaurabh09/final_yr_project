import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import '../data/disease_catalog.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_locale.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/indicators/severity_chip.dart';
import '../widgets/disease_alert_card.dart';
import '../widgets/disease_risk_card.dart';
import '../widgets/recent_scan_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/weather_card.dart';
import 'history_screen.dart';
import 'scan_screen.dart';
 
void _openScan(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const ScanScreen()),
  );
}
 
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
 
class _Dashboard extends StatelessWidget {
  final VoidCallback onViewAll;
  const _Dashboard({required this.onViewAll});
 
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scans = context.watch<ScanProvider>();
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final gutter = viewportWidth < 600 ? 16.0 : 32.0;
 
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.background,
          titleSpacing: gutter,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.grain_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'GrapeCare AI',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          actions: [
            const _LanguageToggle(),
            const _DemoPill(),
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textSecondary,
                size: 22,
              ),
              onPressed: () {},
            ),
            SizedBox(width: gutter > 16 ? 16 : 4),
          ],
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCard(
                      greeting: l10n.goodMorning,
                      title: l10n.vineyardHealth,
                      scansLabel: l10n.scans,
                      diseasesLabel: l10n.diseases,
                      healthyLabel: l10n.healthy,
                      scanLabel: l10n.scanNow,
                      total: scans.total,
                      diseased: scans.diseasedCount,
                      healthy: scans.healthyCount,
                      onScan: () => _openScan(context),
                    ),
                    const SizedBox(height: 20),
                    const WeatherCard(),
                    const SizedBox(height: 16),
                    const DiseaseRiskCard(),
                    const SizedBox(height: 16),
                    const DiseaseAlertCard(),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: l10n.recentScans,
                      actionLabel: l10n.viewAll,
                      onAction: onViewAll,
                    ),
                    ..._recentTiles(context, scans),
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
 
/// Gradient hero: greeting, 3 stats and the main "scan" button.
class _HeroCard extends StatelessWidget {
  final String greeting;
  final String title;
  final String scansLabel;
  final String diseasesLabel;
  final String healthyLabel;
  final String scanLabel;
  final int total;
  final int diseased;
  final int healthy;
  final VoidCallback onScan;
 
  const _HeroCard({
    required this.greeting,
    required this.title,
    required this.scansLabel,
    required this.diseasesLabel,
    required this.healthyLabel,
    required this.scanLabel,
    required this.total,
    required this.diseased,
    required this.healthy,
    required this.onScan,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppRadii.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting 👋',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  value: '$total',
                  label: scansLabel,
                  icon: Icons.qr_code_scanner_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroStat(
                  value: '$diseased',
                  label: diseasesLabel,
                  icon: Icons.warning_amber_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroStat(
                  value: '$healthy',
                  label: healthyLabel,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onScan,
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: Flexible(
                child: Text(
                  scanLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryDark,
                elevation: 0,
                minimumSize: const Size.fromHeight(52),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _HeroStat({
    required this.value,
    required this.label,
    required this.icon,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              height: 1,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _DemoPill extends StatelessWidget {
  const _DemoPill();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.successMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, size: 6, color: AppColors.primary),
          SizedBox(width: 5),
          Text(
            'Demo',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
 
class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();
 
  @override
  Widget build(BuildContext context) {
    final localeController = context.read<AppLocaleController>();
    final currentLocale = Localizations.localeOf(context);
 
    return Semantics(
      button: true,
      label: 'Change language',
      child: GestureDetector(
        onTap: () {
          final newLocale = currentLocale.languageCode == 'en'
              ? const Locale('mr')
              : const Locale('en');
          localeController.setLocale(newLocale);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            currentLocale.languageCode == 'en' ? 'मराठी' : 'EN',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
 
 
/// Latest scans as tiles (or a short hint when there are none yet).
List<Widget> _recentTiles(BuildContext context, ScanProvider scans) {
  final lang = Localizations.localeOf(context).languageCode;
  final recent = scans.recent(3);
  if (recent.isEmpty) {
    return const [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No scans yet. Tap the camera button to scan your first leaf.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ),
    ];
  }
  return [
    for (final r in recent)
      RecentScanTile(
        diseaseName: DiseaseCatalog.byId(r.diseaseId).name(lang),
        severity: severityLabel(r.severity),
        date: '${dayGroupLabel(r.createdAt)}, ${timeLabel(r.createdAt)}',
        isHealthy: r.isHealthy,
        confidence: (r.confidence * 100).round(),
        accent: toUiSeverity(r.severity).color,
      ),
  ];
}