import 'dart:math' as math;

import 'dart:ui';
 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
 
import '../l10n/app_localizations.dart';
import '../providers/scan_provider.dart';
import '../services/image_store.dart';
import '../services/photo_quality.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';
 
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
 
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}
 
class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  // TODO(l10n): move these strings into the .arb files (en + mr).
  static const _steps = [
    'Preprocessing image',
    'Feature extraction',
    'Predicting disease',
    'Generating explanation',
  ];
 
  bool _analyzing = false;
  bool _flashOn = false; // visual only until the camera plugin is wired in
  int _step = 0;
  bool _picking = false;
  Uint8List? _bytes; // preview of the chosen photo
  final ImagePicker _picker = ImagePicker();
 
  late final AnimationController _pulse;
  late final AnimationController _scan;
 
  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }
 
  @override
  void dispose() {
    _pulse.dispose();
    _scan.dispose();
    super.dispose();
  }
 
  String _issueText(AppLocalizations l, PhotoIssue i) => switch (i) {
        PhotoIssue.tooDark => l.photoTooDark,
        PhotoIssue.tooBright => l.photoTooBright,
        PhotoIssue.noLeaf => l.photoNoLeaf,
      };
 
  Future<bool> _confirmPhoto(List<PhotoIssue> issues) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.photoCheckTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final i in issues)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_issueText(l10n, i))),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.retake),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.useAnyway),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
 
  /// Opens the camera or gallery, checks the photo, then runs the scan.
  Future<void> _pick(ImageSource source) async {
    if (_analyzing || _picking) return;
    _picking = true;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
 
    try {
      XFile? file;
      try {
        file = await _picker.pickImage(
          source: source,
          maxWidth: 1600,
          imageQuality: 88,
        );
      } catch (_) {
        messenger
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
            content: Text(source == ImageSource.camera
                ? l10n.cameraNotAvailable
                : l10n.pickFailed),
          ));
        return;
      }
      if (file == null || !mounted) return; // user cancelled
 
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => _bytes = bytes);
 
      final issues = await PhotoQuality.check(bytes);
      if (!mounted) return;
      if (issues.isNotEmpty) {
        final proceed = await _confirmPhoto(issues);
        if (!mounted) return;
        if (!proceed) {
          setState(() => _bytes = null);
          return;
        }
      }
 
      final path = await ImageStore.persist(file);
      if (!mounted) return;
      _picking = false;
      await _startScan(imagePath: path);
    } catch (_) {
      if (!mounted) return;
      setState(() => _bytes = null);
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(l10n.pickFailed)));
    } finally {
      _picking = false;
    }
  }
 
  Future<void> _startScan({String? imagePath}) async {
    if (_analyzing) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _analyzing = true;
      _step = 0;
    });
    // The classifier runs while the step animation plays.
    final classification =
        context.read<ScanProvider>().classify(imagePath: imagePath);
    // Step timing is for show; it is not real model progress.
    for (var i = 1; i <= _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() => _step = i);
    }
    final result = await classification;
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0B1F15),
      ),
      child: PopScope(
        canPop: !_analyzing,
        child: Scaffold(
          backgroundColor: const Color(0xFF0B1F15),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Deep forest backdrop
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [
                      AppColors.primaryLight,
                      AppColors.primaryDark,
                      Color(0xFF0B1F15),
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      children: [
                        _TopBar(
                          flashOn: _flashOn,
                          onBack: _analyzing
                              ? null
                              : () => Navigator.of(context).pop(),
                          onFlash: () => setState(() => _flashOn = !_flashOn),
                        ),
                        Expanded(child: _buildFrameArea()),
                        _buildControls(),
                      ],
                    ),
                  ),
                ),
              ),
              if (_analyzing)
                Positioned.fill(
                  child: _AnalyzingOverlay(step: _step, steps: _steps),
                ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildFrameArea() {
    return LayoutBuilder(
      builder: (context, c) {
        final side = math
            .min(c.maxWidth * 0.82, c.maxHeight - 96)
            .clamp(160.0, 420.0)
            .toDouble();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: side,
              height: side,
              child: CustomPaint(
                foregroundPainter: _FramePainter(
                  pulse: _pulse,
                  scan: _scan,
                  analyzing: _analyzing,
                ),
                child: _bytes != null
                    ? Padding(
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.memory(
                            _bytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.large),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                size: 54,
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                              const SizedBox(height: AppSpacing.small),
                              Text(
                                AppLocalizations.of(context)!.noPhotoYet,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)!.takeOrChoose,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.xLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
              child: _Glass(
                radius: 16,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                  vertical: AppSpacing.medium,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.center_focus_strong_rounded,
                        size: 18, color: Colors.white),
                    SizedBox(width: AppSpacing.small),
                    Flexible(
                      child: Text(
                        'Place the leaf within the frame and keep it steady',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.large,
        AppSpacing.medium,
        AppSpacing.large,
        AppSpacing.large,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Glass(
            radius: 32,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xLarge,
              vertical: AppSpacing.large,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SideAction(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () => _pick(ImageSource.gallery),
                ),
                _CaptureButton(
                  pulse: _pulse,
                  analyzing: _analyzing,
                  onTap: () => _pick(ImageSource.camera),
                ),
                const _SideAction(
                  icon: Icons.flip_camera_ios_outlined,
                  label: 'Flip',
                  onTap: null, // enabled once the camera plugin is wired in
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            AppLocalizations.of(context)!.demoPhotoNote,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
 
// ---------------------------------------------------------------------------
// Pieces
// ---------------------------------------------------------------------------
 
class _TopBar extends StatelessWidget {
  final bool flashOn;
  final VoidCallback? onBack;
  final VoidCallback onFlash;
  const _TopBar({
    required this.flashOn,
    required this.onBack,
    required this.onFlash,
  });
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.large,
        AppSpacing.small,
        AppSpacing.large,
        0,
      ),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
            onTap: onBack,
          ),
          const SizedBox(width: AppSpacing.medium),
          const Expanded(
            child: Text(
              'Scan Grape Leaf',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.6)),
            ),
            child: const Text(
              'DEMO',
              style: TextStyle(
                color: AppColors.amber,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          _GlassIconButton(
            icon: flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            tooltip: flashOn ? 'Flash on' : 'Flash off',
            onTap: onFlash,
          ),
        ],
      ),
    );
  }
}
 
/// Frosted-glass container.
class _Glass extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  const _Glass({
    required this.child,
    required this.radius,
    required this.padding,
  });
 
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
 
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48, // 48dp tap target
          child: Center(
            child: _Glass(
              radius: 22,
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon,
                size: 22,
                color: Colors.white.withValues(alpha: onTap == null ? 0.4 : 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 
class _SideAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _SideAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = Colors.white.withValues(alpha: enabled ? 1 : 0.4);
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: enabled ? 0.16 : 0.07),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: AppSpacing.xSmall),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _CaptureButton extends StatelessWidget {
  final Animation<double> pulse;
  final bool analyzing;
  final VoidCallback onTap;
  const _CaptureButton({
    required this.pulse,
    required this.analyzing,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Capture leaf',
      child: GestureDetector(
        onTap: analyzing ? null : onTap,
        child: AnimatedBuilder(
          animation: pulse,
          builder: (context, child) => Transform.scale(
            scale: analyzing ? 1 : 1 + 0.04 * pulse.value,
            child: child,
          ),
          child: Container(
            width: 84,
            height: 84,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryGlow, AppColors.primaryLight],
                ),
              ),
              child: analyzing
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
 
/// Full-screen processing view (kit screen 7), driven by [step].
class _AnalyzingOverlay extends StatelessWidget {
  final int step;
  final List<String> steps;
  const _AnalyzingOverlay({required this.step, required this.steps});
 
  @override
  Widget build(BuildContext context) {
    final progress = step / steps.length;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: const Color(0xFF0B1F15).withValues(alpha: 0.78),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xLarge),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Analyzing…',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xLarge),
                    SizedBox(
                      width: 132,
                      height: 132,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 132,
                            height: 132,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: progress),
                              duration: const Duration(milliseconds: 400),
                              builder: (_, v, __) => CircularProgressIndicator(
                                value: v,
                                strokeWidth: 8,
                                strokeCap: StrokeCap.round,
                                color: AppColors.primaryGlow,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xLarge),
                    for (var i = 0; i < steps.length; i++)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StepIcon(done: i < step, active: i == step),
                            const SizedBox(width: AppSpacing.medium),
                            Text(
                              steps[i],
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: i <= step ? 1 : 0.5,
                                ),
                                fontSize: 15,
                                fontWeight: i == step
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xLarge),
                    Text(
                      'This may take a few seconds.\nPlease keep the leaf steady.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        height: 1.45,
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
 
class _StepIcon extends StatelessWidget {
  final bool done;
  final bool active;
  const _StepIcon({required this.done, required this.active});
 
  @override
  Widget build(BuildContext context) {
    if (done) {
      return const Icon(Icons.check_circle_rounded,
          size: 22, color: AppColors.primaryGlow);
    }
    if (active) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: Colors.white),
        ),
      );
    }
    return Icon(Icons.circle_outlined,
        size: 22, color: Colors.white.withValues(alpha: 0.35));
  }
}
 
/// Rounded corner brackets + animated scan line.
class _FramePainter extends CustomPainter {
  final Animation<double> pulse;
  final Animation<double> scan;
  final bool analyzing;
 
  _FramePainter({
    required this.pulse,
    required this.scan,
    required this.analyzing,
  }) : super(repaint: Listenable.merge([pulse, scan]));
 
  @override
  void paint(Canvas canvas, Size size) {
    const inset = 3.0;
    const r = 26.0;
    final l = inset, t = inset;
    final rt = size.width - inset, b = size.height - inset;
    final len = size.shortestSide * 0.18;
 
    final rrect = RRect.fromLTRBR(l, t, rt, b, const Radius.circular(r));
    canvas.drawRRect(rrect, Paint()..color = Colors.white.withValues(alpha: 0.05));
 
    final tone = analyzing ? Colors.white : AppColors.primaryGlow;
 
    // Scan line (clipped to the frame)
    canvas.save();
    canvas.clipRRect(rrect);
    final y = t + 14 + (b - t - 28) * Curves.easeInOut.transform(scan.value);
    final trail = Rect.fromLTRB(l + 8, y - 70, rt - 8, y);
    canvas.drawRect(
      trail,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tone.withValues(alpha: 0), tone.withValues(alpha: 0.22)],
        ).createShader(trail),
    );
    final line = Rect.fromLTWH(l + 14, y - 1.5, rt - l - 28, 3);
    canvas.drawRect(
      line,
      Paint()
        ..shader = LinearGradient(colors: [
          tone.withValues(alpha: 0),
          tone,
          tone.withValues(alpha: 0),
        ]).createShader(line)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );
    canvas.restore();
 
    // Corner brackets
    final p = Paint()
      ..color = tone.withValues(alpha: analyzing ? 1 : 0.65 + 0.35 * pulse.value)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const d = r * 2;
 
    canvas.drawPath(
      Path()
        ..moveTo(l, t + len)
        ..lineTo(l, t + r)
        ..arcTo(Rect.fromLTWH(l, t, d, d), math.pi, math.pi / 2, false)
        ..lineTo(l + len, t),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rt - len, t)
        ..lineTo(rt - r, t)
        ..arcTo(Rect.fromLTWH(rt - d, t, d, d), -math.pi / 2, math.pi / 2, false)
        ..lineTo(rt, t + len),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rt, b - len)
        ..lineTo(rt, b - r)
        ..arcTo(Rect.fromLTWH(rt - d, b - d, d, d), 0, math.pi / 2, false)
        ..lineTo(rt - len, b),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(l + len, b)
        ..lineTo(l + r, b)
        ..arcTo(Rect.fromLTWH(l, b - d, d, d), math.pi / 2, math.pi / 2, false)
        ..lineTo(l, b - len),
      p,
    );
  }
 
  @override
  bool shouldRepaint(_FramePainter old) => old.analyzing != analyzing;
}