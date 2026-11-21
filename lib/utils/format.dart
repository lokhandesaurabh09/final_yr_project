import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/scan_result.dart';
import '../widgets/indicators/severity_chip.dart';

/// "Today", "Yesterday" or a short date, in the app language.
String dayGroupLabel(DateTime d, AppLocalizations l10n) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return l10n.today;
  if (diff == 1) return l10n.yesterday;
  return DateFormat('MMM d', l10n.localeName).format(d);
}

String timeLabel(DateTime d, [String? locale]) =>
    DateFormat('h:mm a', locale).format(d);

String severityText(AppLocalizations l10n, DiseaseSeverity s) => switch (s) {
      DiseaseSeverity.healthy => l10n.noDisease,
      DiseaseSeverity.mild => l10n.mild,
      DiseaseSeverity.moderate => l10n.moderate,
      DiseaseSeverity.severe => l10n.severe,
    };

/// Model enum -> UI enum (same names, kept separate so models never import widgets).
Severity toUiSeverity(DiseaseSeverity s) => Severity.values.byName(s.name);
