import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/quick_stat_card.dart';
import '../widgets/disease_alert_card.dart';
import '../widgets/recent_scan_tile.dart';
import 'scan_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _HomeContent(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScanScreen()),
          );
        },
        backgroundColor: AppColors.accentGreen,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt_rounded, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        notchMargin: 10,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              const SizedBox(width: 64), // FAB notch spacer
              _NavItem(
                icon: Icons.history_rounded,
                label: 'History',
                selected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.accentGreen : AppColors.textLight,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.accentGreen : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App bar
        SliverAppBar(
          expandedHeight: 140,
          pinned: true,
          backgroundColor: AppColors.primaryGreen,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VineGuard',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Vineyard health at a glance',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB7E4C7),
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_rounded, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Disease Alert Banner
                const DiseaseAlertCard(),

                const SizedBox(height: 24),

                // Quick Stats
                const Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                      child: QuickStatCard(
                        label: 'Scans',
                        value: '14',
                        icon: Icons.qr_code_scanner_rounded,
                        color: AppColors.accentGreen,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: QuickStatCard(
                        label: 'Detected',
                        value: '3',
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.warningAmber,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: QuickStatCard(
                        label: 'Healthy',
                        value: '11',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.healthyGreen,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Scan prompt
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF40916C), Color(0xFF1B4332)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scan a Leaf',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap the camera button below to detect disease instantly',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFB7E4C7),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Recent scans
                const Text(
                  'Recent Scans',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                const RecentScanTile(
                  diseaseName: 'Powdery Mildew',
                  severity: 'Moderate',
                  date: 'Today, 9:42 AM',
                  isHealthy: false,
                  severityColor: AppColors.warningAmber,
                ),
                const RecentScanTile(
                  diseaseName: 'Healthy Leaf',
                  severity: 'No disease',
                  date: 'Today, 9:15 AM',
                  isHealthy: true,
                  severityColor: AppColors.healthyGreen,
                ),
                const RecentScanTile(
                  diseaseName: 'Black Rot',
                  severity: 'Severe',
                  date: 'Yesterday, 3:00 PM',
                  isHealthy: false,
                  severityColor: AppColors.diseaseRed,
                ),

                const SizedBox(height: 100), // bottom padding for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }
}
