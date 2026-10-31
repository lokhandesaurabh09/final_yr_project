import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import '../theme/app_theme.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/indicators/confidence_bar.dart';
import '../widgets/indicators/severity_chip.dart';
import 'home_screen.dart';
 
// TODO(l10n): move all strings below into the .arb files (en + mr).
// TODO(model): replace the sample constants with a real ScanResult object.
const double _sampleConfidence = 0.94;
 
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});
 
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}
 
class _ResultScreenState extends State<ResultScreen> {
  bool _showHeatmap = false;
  double _heatOpacity = 0.75;
 
  void _save() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving is not connected in this build yet')),
    );
  }
 
  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlay,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text('Result'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.small,
                AppSpacing.large,
                AppSpacing.xLarge,
              ),
              children: [
                const _SampleNotice(),
                const SizedBox(height: AppSpacing.large),
                _DiagnosisCard(confidence: _sampleConfidence),
                const SizedBox(height: AppSpacing.large),
                _ExplainCard(
                  showHeatmap: _showHeatmap,
                  opacity: _heatOpacity,
                  onToggle: (v) => setState(() => _showHeatmap = v),
                  onOpacity: (v) => setState(() => _heatOpacity = v),
                ),
                const SizedBox(height: AppSpacing.large),
                const _PredictionsCard(),
                const SizedBox(height: AppSpacing.large),
                const _TreatmentCard(),
                const SizedBox(height: AppSpacing.large),
                const _InfoSection(
                  icon: Icons.info_outline_rounded,
                  title: 'About this disease',
                  child: Text(
                    'Powdery Mildew is a fungal disease caused by Erysiphe necator. '
                    'It creates white powdery patches on leaves and shoots and '
                    'spreads fastest in warm, humid conditions. Left untreated it '
                    'can reduce grape quality and yield.',
                    style: _bodyStyle,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                const _InfoSection(
                  icon: Icons.search_rounded,
                  title: 'Symptoms to look for',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bullet('White powdery coating on the leaf surface'),
                      _Bullet('Yellowing and curling of leaves'),
                      _Bullet('Stunted shoot growth'),
                      _Bullet('Infected berries may crack or split'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(top: BorderSide(color: AppColors.border)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                          label: const Text('Save'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: const StadiumBorder(),
                            side: const BorderSide(
                                color: AppColors.primary, width: 1.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          label: 'Back to dashboard',
                          icon: Icons.home_rounded,
                          onPressed: _goHome,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 
const TextStyle _bodyStyle = TextStyle(
  fontSize: 14,
  height: 1.6,
  color: AppColors.textSecondary,
);
 
// ---------------------------------------------------------------------------
// Sections
// ---------------------------------------------------------------------------
 
class _SampleNotice extends StatelessWidget {
  const _SampleNotice();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.warningMuted,
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, size: 18, color: AppColors.warning),
          SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              'Sample result. The diagnosis, confidence and heatmap are fixed '
              'demo content, not model output.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _DiagnosisCard extends StatelessWidget {
  final double confidence;
  const _DiagnosisCard({required this.confidence});
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SeverityChip(
                  label: 'Moderate',
                  severity: Severity.moderate,
                ),
                const SizedBox(height: AppSpacing.medium),
                const Text(
                  'Powdery Mildew',
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.xSmall),
                const Text(
                  'Erysiphe necator',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.large),
          _ConfidenceRing(value: confidence),
        ],
      ),
    );
  }
}
 
class _ConfidenceRing extends StatelessWidget {
  final double value;
  const _ConfidenceRing({required this.value});
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Confidence ${(value * 100).round()} percent',
      child: SizedBox(
        width: 84,
        height: 84,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (_, v, __) => CircularProgressIndicator(
                  value: v,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primaryMuted,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'confidence',
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 
/// Explainable-AI card: Original / Grad-CAM toggle + opacity slider.
class _ExplainCard extends StatelessWidget {
  final bool showHeatmap;
  final double opacity;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onOpacity;
 
  const _ExplainCard({
    required this.showHeatmap,
    required this.opacity,
    required this.onToggle,
    required this.onOpacity,
  });
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.insights_rounded,
            title: 'What the AI focused on',
          ),
          const SizedBox(height: AppSpacing.medium),
          _ViewToggle(showHeatmap: showHeatmap, onChanged: onToggle),
          const SizedBox(height: AppSpacing.medium),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.card),
            child: AspectRatio(
              aspectRatio: 1.25,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CustomPaint(painter: _LeafPainter()),
                  AnimatedOpacity(
                    opacity: showHeatmap ? opacity : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const CustomPaint(painter: _HeatPainter()),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        showHeatmap ? 'GRAD-CAM (SAMPLE)' : 'ORIGINAL (SAMPLE)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showHeatmap) ...[
            const SizedBox(height: AppSpacing.small),
            Row(
              children: [
                const Icon(Icons.opacity_rounded,
                    size: 18, color: AppColors.textSecondary),
                Expanded(
                  child: Slider(
                    value: opacity,
                    min: 0.2,
                    max: 1,
                    onChanged: onOpacity,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primaryMuted,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${(opacity * 100).round()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.small),
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
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
                SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    'Warm colours mark the leaf areas that influenced the '
                    'prediction most. Real Grad-CAM heatmaps will appear here '
                    'once the trained model is connected.',
                    style: TextStyle(
                      fontSize: 13,
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
 
class _ViewToggle extends StatelessWidget {
  final bool showHeatmap;
  final ValueChanged<bool> onChanged;
  const _ViewToggle({required this.showHeatmap, required this.onChanged});
 
  @override
  Widget build(BuildContext context) {
    Widget seg(String label, bool heat) {
      final selected = showHeatmap == heat;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          label: label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(heat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: selected ? AppColors.brandGradient : null,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      );
    }
 
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [seg('Original', false), seg('Grad-CAM', true)]),
    );
  }
}
 
class _PredictionsCard extends StatelessWidget {
  const _PredictionsCard();
 
  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Powdery Mildew', 0.94, AppColors.primary),
      ('Downy Mildew', 0.04, AppColors.warning),
      ('Healthy Leaf', 0.02, AppColors.textTertiary),
    ];
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.leaderboard_rounded,
            title: 'Top predictions',
          ),
          const SizedBox(height: AppSpacing.medium),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.$1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ConfidenceBar(value: r.$2, color: r.$3, showLabel: true),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
 
class _TreatmentCard extends StatelessWidget {
  const _TreatmentCard();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraMuted,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.healing_rounded,
            title: 'Treatment recommendation',
          ),
          SizedBox(height: AppSpacing.medium),
          _Step('1', 'Apply a sulfur-based fungicide every 7–10 days'),
          _Step('2', 'Improve airflow by pruning dense foliage'),
          _Step('3', 'Avoid overhead irrigation to reduce humidity'),
          _Step('4', 'Monitor neighbouring plants for spread'),
          SizedBox(height: AppSpacing.xSmall),
          Text(
            'Sample guidance. Confirm doses and products with a local '
            'agriculture officer.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
 
class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.child,
  });
 
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: icon, title: title),
          const SizedBox(height: AppSpacing.medium),
          child,
        ],
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Small pieces
// ---------------------------------------------------------------------------
 
class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _CardTitle({required this.icon, required this.title});
 
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
 
class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(child: Text(text, style: _bodyStyle)),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
            ),
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(text, style: _bodyStyle),
            ),
          ),
        ],
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Placeholder leaf + heatmap (sample visuals until real images exist)
// ---------------------------------------------------------------------------
 
const List<(double, double, double)> _blotches = [
  (0.40, 0.38, 0.13),
  (0.63, 0.52, 0.15),
  (0.45, 0.68, 0.11),
];
 
class _LeafPainter extends CustomPainter {
  const _LeafPainter();
 
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
 
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDDE9D4), Color(0xFFBFD5B4)],
        ).createShader(Offset.zero & size),
    );
 
    final cx = w * 0.5;
    final leaf = Path()
      ..moveTo(cx, h * 0.08)
      ..cubicTo(w * 0.86, h * 0.18, w * 0.92, h * 0.70, cx, h * 0.92)
      ..cubicTo(w * 0.08, h * 0.70, w * 0.14, h * 0.18, cx, h * 0.08)
      ..close();
 
    canvas.drawShadow(leaf, Colors.black, 6, true);
    canvas.drawPath(
      leaf,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF52B788), Color(0xFF2D6A4F)],
        ).createShader(Offset.zero & size),
    );
 
    final vein = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final base = Offset(cx, h * 0.90);
    canvas.drawLine(base, Offset(cx, h * 0.14), vein);
    for (final t in [0.35, 0.5, 0.65]) {
      final y = h * (0.9 - 0.7 * (1 - t));
      canvas.drawLine(Offset(cx, y), Offset(w * 0.24, y - h * 0.16), vein);
      canvas.drawLine(Offset(cx, y), Offset(w * 0.76, y - h * 0.16), vein);
    }
    canvas.drawLine(
      base,
      Offset(cx, h * 0.99),
      vein..strokeWidth = 3,
    );
 
    // Pale powdery patches
    for (final b in _blotches) {
      final c = Offset(w * b.$1, h * b.$2);
      canvas.drawCircle(
        c,
        w * b.$3,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
    }
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
 
class _HeatPainter extends CustomPainter {
  const _HeatPainter();
 
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    for (final b in _blotches) {
      final c = Offset(w * b.$1, h * b.$2);
      final r = w * b.$3 * 2.1;
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = const RadialGradient(
            colors: [
              Color(0xFFE53935),
              Color(0xFFFFB300),
              Color(0xFF7CB342),
              Color(0x0000B0FF),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}