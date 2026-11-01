import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_locale.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cards/app_card.dart';
import '../widgets/grape_logo.dart';

/// Keep in sync with `version:` in pubspec.yaml.
const String _appVersion = '1.0.0';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmThen(
    BuildContext context,
    String message,
    Future<void> Function() action,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await action();
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.done)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scans = context.watch<ScanProvider>();
    final controller = context.read<AppLocaleController>();
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.settings),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.large,
                AppSpacing.large,
                AppSpacing.xxLarge,
              ),
              children: [
                _SectionLabel(l10n.appSettings),
                _Group(children: [
                  _Row(
                    icon: Icons.translate_rounded,
                    title: l10n.language,
                    trailing: _LangSegment(
                      isEnglish: isEnglish,
                      onChanged: (en) => controller
                          .setLocale(Locale(en ? 'en' : 'mr')),
                    ),
                  ),
                  _Row(
                    icon: Icons.palette_outlined,
                    title: l10n.theme,
                    subtitle: l10n.darkModeSoon,
                    trailing: _ValueText(l10n.themeLight),
                  ),
                ]),
                const SizedBox(height: AppSpacing.xLarge),
                _SectionLabel(l10n.modelAndData),
                _Group(children: [
                  _Row(
                    icon: Icons.memory_rounded,
                    title: l10n.modelName,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (scans.classifier.isMock) ...[
                          const _DemoChip(),
                          const SizedBox(width: 8),
                        ],
                        _ValueText(scans.classifier.modelName),
                      ],
                    ),
                  ),
                  _Row(
                    icon: Icons.bookmarks_outlined,
                    title: l10n.savedScans,
                    trailing: _ValueText('${scans.total}'),
                  ),
                  _Row(
                    icon: Icons.science_outlined,
                    title: l10n.sampleRecords,
                    trailing: _ValueText('${scans.sampleCount}'),
                  ),
                ]),
                if (scans.classifier.isMock) ...[
                  const SizedBox(height: AppSpacing.medium),
                  _NoteCard(text: l10n.demoModelNote),
                ],
                const SizedBox(height: AppSpacing.medium),
                _Group(children: [
                  if (scans.sampleCount > 0)
                    _Row(
                      icon: Icons.cleaning_services_outlined,
                      title: l10n.removeSamples,
                      onTap: () => _confirmThen(
                        context,
                        l10n.removeSamplesWarning,
                        scans.removeSamples,
                      ),
                    )
                  else
                    _Row(
                      icon: Icons.add_circle_outline_rounded,
                      title: l10n.addSamples,
                      onTap: scans.addSamples,
                    ),
                  if (scans.total > 0)
                    _Row(
                      icon: Icons.delete_outline_rounded,
                      title: l10n.deleteAllScans,
                      danger: true,
                      onTap: () => _confirmThen(
                        context,
                        l10n.deleteAllWarning,
                        scans.removeAll,
                      ),
                    ),
                ]),
                const SizedBox(height: AppSpacing.xLarge),
                _SectionLabel(l10n.aboutApp),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const GrapeLogo(size: 46),
                          const SizedBox(width: AppSpacing.medium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GrapeCare AI',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                Text(
                                  '${l10n.appVersion} $_appVersion',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      Text(
                        l10n.projectTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.medium),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lock_outline_rounded,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: Text(
                              l10n.privacyNote,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.small),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Rounded card that stacks rows with hairline dividers.
class _Group extends StatelessWidget {
  final List<Widget> children;
  const _Group({required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) {
        rows.add(const Divider(height: 1, indent: 64));
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  const _Row({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            danger ? AppColors.danger : AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ] else if (onTap != null)
                const Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  final String text;
  const _ValueText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  const _DemoChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warningMuted,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Text(
        'DEMO',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: AppColors.warning,
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String text;
  const _NoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
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
          const Icon(Icons.info_outline_rounded,
              size: 18, color: AppColors.warning),
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

class _LangSegment extends StatelessWidget {
  final bool isEnglish;
  final ValueChanged<bool> onChanged; // true = English
  const _LangSegment({required this.isEnglish, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget pill(String label, bool en) {
      final selected = isEnglish == en;
      return Semantics(
        button: true,
        selected: selected,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(en),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.brandGradient : null,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [pill('English', true), pill('मराठी', false)],
      ),
    );
  }
}
