import 'package:intl/intl.dart';
 
import '../models/scan_result.dart';
import '../widgets/indicators/severity_chip.dart';
 
// TODO(l10n): localize these labels and the date formats for Marathi.
 
String dayGroupLabel(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('MMM d').format(d);
}
 
String timeLabel(DateTime d) => DateFormat('h:mm a').format(d);
 
String severityLabel(DiseaseSeverity s) => switch (s) {
      DiseaseSeverity.healthy => 'No disease',
      DiseaseSeverity.mild => 'Mild',
      DiseaseSeverity.moderate => 'Moderate',
      DiseaseSeverity.severe => 'Severe',
    };
 
/// Model enum -> UI enum (same names, kept separate so models never import widgets).
Severity toUiSeverity(DiseaseSeverity s) => Severity.values.byName(s.name);
 