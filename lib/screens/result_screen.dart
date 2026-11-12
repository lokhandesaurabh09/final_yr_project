import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
 
import '../data/disease_catalog.dart';
import '../l10n/app_localizations.dart';
import '../models/scan_result.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/indicators/confidence_bar.dart';
import '../widgets/indicators/severity_chip.dart';
import '../widgets/scan_image.dart';
import 'home_screen.dart';
 
// TODO(l10n): move all strings below into the .arb files (en + mr).
 
/// Below this confidence we ask the user to retake the photo.
const double _lowConfidence = 0.70;
 
class ResultScreen extends StatefulWidget {
  final ScanResult result;
  const ResultScreen({super.key, required this.result});
 
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}
 
class _ResultScreenState extends State<ResultScreen> {
  bool _showHeatmap = false;
  double _heatOpacity = 0.75;
  late bool _saved = widget.result.id != null; // opened from history
  bool _saving = false;
 
  Future<void> _save() async {
    if (_saved || _saving) return;
    HapticFeedback.selectionClick();
    final scans = context.read<ScanProvider>();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    await scans.save(widget.result);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saved = true;
    });
    messenger.showSnackBar(const SnackBar(content: Text('Saved to history')));
  }
 
  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final lang = Localizations.localeOf(context).languageCode;
    final disease = DiseaseCatalog.byId(r.diseaseId);
    const gap = SizedBox(height: AppSpacing.large);
 
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
                if (r.isSample) ...[
                  _SampleNotice(hasPhoto: r.imagePath != null),
                  gap,
                ],
                if (r.confidence < _lowConfidence) ...[
                  const _LowConfidenceNotice(),
                  gap,
                ],
                _DiagnosisCard(
                  name: disease.name(lang),
                  scientificName: disease.scientificName,
                  severity: r.severity,
                  confidence: r.confidence,
                ),
                gap,
                _ExplainCard(
                  imagePath: r.imagePath,
                  showHeatmap: _showHeatmap,
                  opacity: _heatOpacity,
                  onToggle: (v) => setState(() => _showHeatmap = v),
                  onOpacity: (v) => setState(() => _heatOpacity = v),
                ),
                gap,
                _PredictionsCard(predictions: r.topPredictions, lang: lang),
                gap,
                _TreatmentCard(
                  title: disease.isHealthy
                      ? 'Care tips'
                      : 'Treatment recommendation',
                  steps: disease.treatment,
                ),
                gap,
                _InfoSection(
                  icon: Icons.info_outline_rounded,
                  title: 'About this leaf',
                  child: Text(disease.about, style: _bodyStyle),
                ),
                if (disease.symptoms.isNotEmpty) ...[
                  gap,
                  _InfoSection(
                    icon: Icons.search_rounded,
                    title: 'Symptoms to look for',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final s in disease.symptoms) _Bullet(s),
                      ],
                    ),
                  ),
                ],
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
                          onPressed: (_saved || _saving) ? null : _save,
                          icon: Icon(
                            _saved
                                ? Icons.check_rounded
                                : Icons.bookmark_add_outlined,
                            size: 18,
                          ),
                          label: Text(_saved ? 'Saved' : 'Save'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              color: _saved
                                  ? AppColors.border
                                  : AppColors.primary,
                              width: 1.4,
                            ),
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
  final bool hasPhoto;
  const _SampleNotice({required this.hasPhoto});
 
  @override
  Widget build(BuildContext context) {
    final text = hasPhoto
        ? AppLocalizations.of(context)!.demoPhotoNote
        : 'Demo result from the sample classifier. It is not a real '
            'diagnosis, and the heatmap below is a placeholder.';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.warningMuted,
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.science_outlined, size: 18, color: AppColors.warning),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
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
 
class _LowConfidenceNotice extends StatelessWidget {
  const _LowConfidenceNotice();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.dangerMuted,
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.danger),
          SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              'The model is not very sure about this leaf. Retake the photo '
              'in good light with the leaf filling the frame.',
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
  final String name;
  final String scientificName;
  final DiseaseSeverity severity;
  final double confidence;
 
  const _DiagnosisCard({
    required this.name,
    required this.scientificName,
    required this.severity,
    required this.confidence,
  });
 
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
                SeverityChip(
                  label: severityLabel(severity),
                  severity: toUiSeverity(severity),
                ),
                const SizedBox(height: AppSpacing.medium),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                if (scientificName.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(
                    scientificName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
  final String? imagePath;
  final bool showHeatmap;
  final double opacity;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onOpacity;
 
  const _ExplainCard({
    this.imagePath,
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
                  if (imagePath != null)
                    ScanImage(path: imagePath!, fit: BoxFit.cover)
                  else
                    const CustomPaint(painter: _LeafPainter()),
                  if (imagePath == null)
                    AnimatedOpacity(
                      opacity: showHeatmap ? opacity : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const CustomPaint(painter: _HeatPainter()),
                    )
                  else if (showHeatmap)
                    const Positioned.fill(child: _HeatmapUnavailable()),
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
                        showHeatmap
                            ? 'GRAD-CAM${imagePath == null ? ' (SAMPLE)' : ''}'
                            : 'ORIGINAL${imagePath == null ? ' (SAMPLE)' : ''}',
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
          if (showHeatmap && imagePath == null) ...[
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
 
/// Shown over a real photo: we must not draw a fake heatmap on it.
class _HeatmapUnavailable extends StatelessWidget {
  const _HeatmapUnavailable();
 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.layers_clear_rounded, color: Colors.white, size: 34),
          const SizedBox(height: AppSpacing.small),
          Text(
            AppLocalizations.of(context)!.heatmapNeedsModel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w600,
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
  final List<Prediction> predictions;
  final String lang;
  const _PredictionsCard({required this.predictions, required this.lang});
 
  @override
  Widget build(BuildContext context) {
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
          for (var i = 0; i < predictions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DiseaseCatalog.byId(predictions[i].diseaseId).name(lang),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ConfidenceBar(
                    value: predictions[i].score,
                    color: i == 0 ? AppColors.primary : AppColors.textTertiary,
                    showLabel: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
 
class _TreatmentCard extends StatelessWidget {
  final String title;
  final List<String> steps;
  const _TreatmentCard({required this.title, required this.steps});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.primaryExtraMuted,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: Icons.healing_rounded, title: title),
          const SizedBox(height: AppSpacing.medium),
          for (var i = 0; i < steps.length; i++) _Step('${i + 1}', steps[i]),
          const SizedBox(height: AppSpacing.xSmall),
          const Text(
            'General guidance only. Confirm products and doses with the '
            'label and your local agriculture officer.',
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