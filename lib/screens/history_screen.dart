import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
 
import '../data/disease_catalog.dart';
import '../models/scan_result.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/indicators/confidence_bar.dart';
import '../widgets/indicators/severity_chip.dart';
import '../widgets/leaf_thumb.dart';
import 'result_screen.dart';
import 'scan_screen.dart';
 
// TODO(l10n): move strings into the .arb files (en + mr).
 
enum _Filter { all, diseased, healthy }
 
/// Display row built from a stored [ScanResult].
class _Item {
  final ScanResult result;
  final String name;
  final Severity severity;
  final String severityName;
  final String group;
  final String time;
  final int confidence;
 
  const _Item({
    required this.result,
    required this.name,
    required this.severity,
    required this.severityName,
    required this.group,
    required this.time,
    required this.confidence,
  });
 
  bool get healthy => severity == Severity.healthy;
  int get id => result.id ?? -1;
 
  factory _Item.from(ScanResult r, String lang) => _Item(
        result: r,
        name: DiseaseCatalog.byId(r.diseaseId).name(lang),
        severity: toUiSeverity(r.severity),
        severityName: severityLabel(r.severity),
        group: dayGroupLabel(r.createdAt),
        time: timeLabel(r.createdAt),
        confidence: (r.confidence * 100).round(),
      );
}
 
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
 
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}
 
class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _search = TextEditingController();
  _Filter _filter = _Filter.all;
 
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }
 
  List<_Item> _visible(List<ScanResult> scans, String lang) {
    final q = _search.text.trim().toLowerCase();
    return scans
        .map((r) => _Item.from(r, lang))
        .where((i) {
          final okFilter = switch (_filter) {
            _Filter.all => true,
            _Filter.diseased => !i.healthy,
            _Filter.healthy => i.healthy,
          };
          return okFilter && (q.isEmpty || i.name.toLowerCase().contains(q));
        })
        .toList();
  }
 
  void _delete(_Item item) {
    HapticFeedback.lightImpact();
    final scans = context.read<ScanProvider>();
    final messenger = ScaffoldMessenger.of(context);
    scans.delete(item.result);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} removed'),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.primaryGlow,
            onPressed: () => scans.restore(item.result),
          ),
        ),
      );
  }
 
  void _openScan() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScanScreen()),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final scans = context.watch<ScanProvider>();
    final lang = Localizations.localeOf(context).languageCode;
    final visible = _visible(scans.scans, lang);
 
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Scan History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.large,
                    AppSpacing.large,
                    AppSpacing.large,
                    AppSpacing.small,
                  ),
                  child: _OverviewCard(
                    total: scans.total,
                    diseased: scans.diseasedCount,
                    healthy: scans.healthyCount,
                    showSample: scans.hasSampleData,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.large,
                    vertical: AppSpacing.small,
                  ),
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search by disease name',
                      hintStyle:
                          const TextStyle(color: AppColors.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textSecondary),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () =>
                                  setState(() => _search.clear()),
                            ),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.large,
                    AppSpacing.xSmall,
                    AppSpacing.large,
                    AppSpacing.small,
                  ),
                  child: Row(
                    children: [
                      _FilterPill(
                        label: 'All',
                        selected: _filter == _Filter.all,
                        onTap: () => setState(() => _filter = _Filter.all),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      _FilterPill(
                        label: 'Diseased',
                        selected: _filter == _Filter.diseased,
                        onTap: () =>
                            setState(() => _filter = _Filter.diseased),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      _FilterPill(
                        label: 'Healthy',
                        selected: _filter == _Filter.healthy,
                        onTap: () =>
                            setState(() => _filter = _Filter.healthy),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildList(scans, visible)),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildList(ScanProvider scans, List<_Item> visible) {
    if (!scans.loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (scans.total == 0) {
      return EmptyState(
        icon: Icons.eco_rounded,
        title: 'No detections yet',
        message: 'Scan a grape leaf to get started and save your results here.',
        actionLabel: 'Scan Leaf',
        onAction: _openScan,
      );
    }
    if (visible.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No matching scans',
        message: 'Try a different name or switch the filter to All.',
      );
    }
 
    final children = <Widget>[];
    String? lastGroup;
    for (final item in visible) {
      if (item.group != lastGroup) {
        lastGroup = item.group;
        children.add(_GroupHeader(item.group));
      }
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.small),
          child: Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _delete(item),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.xLarge),
              decoration: BoxDecoration(
                color: AppColors.dangerMuted,
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
            ),
            child: _HistoryEntry(
              item: item,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ResultScreen(result: item.result),
                ),
              ),
            ),
          ),
        ),
      );
    }
 
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.large,
        0,
        AppSpacing.large,
        AppSpacing.xLarge,
      ),
      children: children,
    );
  }
}
 
// ---------------------------------------------------------------------------
 
class _OverviewCard extends StatelessWidget {
  final int total, diseased, healthy;
  final bool showSample;
  const _OverviewCard({
    required this.total,
    required this.diseased,
    required this.healthy,
    required this.showSample,
  });
 
  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : healthy / total;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.large),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Overview', style: AppTypography.sectionTitle),
              ),
              if (showSample)
                Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small, vertical: AppSpacing.xSmall),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(AppRadii.small),
                ),
                child: const Text(
                  'SAMPLE RECORDS',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              _Stat('$total', 'Total', AppColors.textPrimary),
              _Stat('$diseased', 'Diseased', AppColors.danger),
              _Stat('$healthy', 'Healthy', AppColors.success),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          ConfidenceBar(value: ratio, color: AppColors.success, height: 8),
          const SizedBox(height: 6),
          Text(
            '${(ratio * 100).round()}% of scans are healthy',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
 
class _Stat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _Stat(this.value, this.label, this.color);
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: color),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
 
class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: selected ? AppColors.brandGradient : null,
            color: selected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
 
class _GroupHeader extends StatelessWidget {
  final String text;
  const _GroupHeader(this.text);
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.medium,
        bottom: AppSpacing.small,
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
 
class _HistoryEntry extends StatelessWidget {
  final _Item item;
  final VoidCallback onTap;
  const _HistoryEntry({required this.item, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    final color = item.severity.color;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              children: [
                LeafThumb(
                  size: 58,
                  spot: item.healthy ? null : color,
                  imagePath: item.result.imagePath,
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
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
                        spacing: AppSpacing.small,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SeverityChip(
                            label: item.severityName,
                            severity: item.severity,
                          ),
                          Text(
                            item.time,
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
                const SizedBox(width: AppSpacing.small),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.confidence}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const Text(
                      'confidence',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}