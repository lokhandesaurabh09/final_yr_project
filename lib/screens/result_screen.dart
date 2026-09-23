import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Scan Result'),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Leaf image placeholder
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                      ),
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      size: 100,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  // Disease highlight overlay chip
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_rounded,
                              color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Disease Detected',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease name & confidence
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
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Erysiphe necator',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Confidence badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.mintBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '94%',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accentGreen,
                              ),
                            ),
                            Text(
                              'confidence',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Severity bar
                  const _SeverityIndicator(severity: 0.55, label: 'Moderate'),

                  const SizedBox(height: 24),

                  // About section
                  _SectionCard(
                    title: 'About This Disease',
                    icon: Icons.info_rounded,
                    child: const Text(
                      'Powdery Mildew is a fungal disease affecting grapevines, causing white powdery patches on leaves and shoots. It thrives in warm, dry conditions with high humidity and can significantly reduce grape quality if left untreated.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Symptoms
                  _SectionCard(
                    title: 'Visible Symptoms',
                    icon: Icons.search_rounded,
                    child: Column(
                      children: [
                        _BulletPoint('White powdery coating on leaf surface'),
                        _BulletPoint('Yellowing and curling of leaves'),
                        _BulletPoint('Stunted shoot growth'),
                        _BulletPoint('Infected berries may crack or split'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Treatment
                  _SectionCard(
                    title: 'Recommended Treatment',
                    icon: Icons.healing_rounded,
                    iconColor: AppColors.accentGreen,
                    child: Column(
                      children: [
                        _TreatmentStep(
                          step: '1',
                          text: 'Apply sulfur-based fungicide every 7–10 days',
                        ),
                        _TreatmentStep(
                          step: '2',
                          text: 'Improve air circulation by pruning dense foliage',
                        ),
                        _TreatmentStep(
                          step: '3',
                          text: 'Avoid overhead irrigation to reduce humidity',
                        ),
                        _TreatmentStep(
                          step: '4',
                          text: 'Monitor neighboring plants for spread',
                        ),
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
                          icon: const Icon(Icons.save_alt_rounded),
                          label: const Text('Save Result'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                                color: AppColors.accentGreen, width: 1.5),
                            foregroundColor: AppColors.accentGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.camera_alt_rounded),
                          label: const Text('Scan Again'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityIndicator extends StatelessWidget {
  final double severity; // 0.0 to 1.0
  final String label;

  const _SeverityIndicator({required this.severity, required this.label});

  Color get _color {
    if (severity < 0.35) return AppColors.healthyGreen;
    if (severity < 0.65) return AppColors.warningAmber;
    return AppColors.diseaseRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Disease Severity',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: severity,
            backgroundColor: const Color(0xFFE8F5E9),
            valueColor: AlwaysStoppedAnimation<Color>(_color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Color? iconColor;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 18,
                    color: iconColor ?? AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentStep extends StatelessWidget {
  final String step;
  final String text;
  const _TreatmentStep({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.mintBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
