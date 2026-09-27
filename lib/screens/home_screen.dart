import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_chip.dart';
import '../widgets/disease_alert_card.dart';
import '../widgets/recent_scan_tile.dart';
import '../widgets/weather_card.dart';
import '../widgets/disease_risk_card.dart';
import 'scan_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [_Dashboard(), HistoryScreen()],
      ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ScanScreen())),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.camera_alt_rounded,
              color: Colors.black, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBtn(
                  icon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  active: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                const SizedBox(width: 64),
                _NavBtn(
                  icon: Icons.history_rounded,
                  label: 'History',
                  active: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
          ),
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

  const _NavBtn(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 22,
                color: active ? AppColors.primary : AppColors.textTertiary),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.primary : AppColors.textTertiary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.background,
          titleSpacing: 20,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.grain_rounded,
                    size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              const Text(
                'VineGuard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          actions: [
            // Status pill
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.successMuted,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 6, color: AppColors.primary),
                  SizedBox(width: 5),
                  Text(
                    'Live',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.textSecondary, size: 22),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppColors.border),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Greeting
              const Text(
                'Good morning 👋',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Vineyard health overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 20),

              // ── Stat chips row ──
              const Row(
                children: [
                  Expanded(
                    child: StatChip(
                      label: 'Scans',
                      value: '14',
                      icon: Icons.qr_code_scanner_rounded,
                      accent: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatChip(
                      label: 'Diseases',
                      value: '3',
                      icon: Icons.warning_rounded,
                      accent: AppColors.warning,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatChip(
                      label: 'Healthy',
                      value: '11',
                      icon: Icons.check_circle_rounded,
                      accent: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Weather + Humidity row ──
              const Row(
                children: [
                  Expanded(child: WeatherCard()),
                ],
              ),

              const SizedBox(height: 16),

              // ── Disease Risk Card ──
              const DiseaseRiskCard(),

              const SizedBox(height: 16),

              // ── Active Alert ──
              const DiseaseAlertCard(),

              const SizedBox(height: 20),

              // ── Scan CTA ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'QUICK ACTION',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGlow,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Scan a leaf now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tap the camera button below',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.black, size: 24),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Recent Scans ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Scans',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'View all →',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const RecentScanTile(
                diseaseName: 'Powdery Mildew',
                severity: 'Moderate',
                date: 'Today, 9:42 AM',
                isHealthy: false,
                confidence: 94,
                accent: AppColors.warning,
              ),
              const RecentScanTile(
                diseaseName: 'Healthy Leaf',
                severity: 'No disease',
                date: 'Today, 9:15 AM',
                isHealthy: true,
                confidence: 99,
                accent: AppColors.primary,
              ),
              const RecentScanTile(
                diseaseName: 'Black Rot',
                severity: 'Severe',
                date: 'Yesterday, 3:00 PM',
                isHealthy: false,
                confidence: 91,
                accent: AppColors.danger,
              ),

              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}
