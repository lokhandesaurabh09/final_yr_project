import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary, size: 18),
              ),
            ),
            title: const Text('Scan Result'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surface,
                child: Stack(
                  children: [
                    // Leaf image placeholder
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.warningMuted,
                              AppColors.background,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.eco_rounded,
                          size: 80,
                          color: AppColors.warning.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    // Bottom badges
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Row(
                        children: [
                          _Badge(
                              label: 'Disease Detected',
                              color: AppColors.warning),
                          const SizedBox(width: 8),
                          _Badge(
                              label: '94% confidence',
                              color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Disease name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Powdery Mildew',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.8,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Erysiphe necator',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Severity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.warningMuted,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.2)),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'MODERATE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.warning,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'severity',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Severity bar
                _SeverityBar(value: 0.55),

                const SizedBox(height: 20),

                // About
                _InfoCard(
                  title: 'About',
                  icon: Icons.info_outline_rounded,
                  child: const Text(
                    'Powdery Mildew is a fungal disease caused by Erysiphe necator. It creates white powdery patches on leaves and shoots, thriving in warm dry conditions with high humidity. It can significantly reduce grape quality if untreated.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.65,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Symptoms
                _InfoCard(
                  title: 'Symptoms',
                  icon: Icons.search_rounded,
                  child: Column(
                    children: [
                      _Bullet('White powdery coating on leaf surface'),
                      _Bullet('Yellowing and curling of leaves'),
                      _Bullet('Stunted shoot growth'),
                      _Bullet('Infected berries may crack or split'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Treatment
                _InfoCard(
                  title: 'Treatment',
                  icon: Icons.healing_rounded,
                  accentColor: AppColors.primary,
                  child: Column(
                    children: [
                      _Step('1', 'Apply sulfur-based fungicide every 7–10 days'),
                      _Step('2', 'Improve airflow by pruning dense foliage'),
                      _Step('3', 'Avoid overhead irrigation to reduce humidity'),
                      _Step('4', 'Monitor neighbouring plants for spread'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save_alt_rounded, size: 16),
                        label: const Text('Save'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                              color: AppColors.border, width: 1),
                          foregroundColor: AppColors.textSecondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        icon: const Icon(Icons.home_rounded,
                            size: 16, color: Colors.black),
                        label: const Text('Back to Dashboard'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _SeverityBar extends StatelessWidget {
  final double value;
  const _SeverityBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Severity',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            Text('55%',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.warning),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Color? accentColor;
  const _InfoCard(
      {required this.title,
      required this.icon,
      required this.child,
      this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 15,
                  color: accentColor ?? AppColors.textSecondary),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String step;
  final String text;
  const _Step(this.step, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Text(step,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}
