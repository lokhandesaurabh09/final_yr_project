import 'package:flutter/foundation.dart';
 
import '../models/scan_result.dart';
import '../repositories/scan_repository.dart';
import '../services/disease_classifier.dart';
 
/// Single source of truth for scans: Dashboard, History and Result all read
/// from here, so their numbers can never disagree.
class ScanProvider extends ChangeNotifier {
  ScanProvider({
    required this.repository,
    required this.classifier,
    this.seedDemoData = true,
  });
 
  final ScanRepository repository;
  final DiseaseClassifier classifier;
 
  /// When the database is empty, add sample records (flagged isSample) so the
  /// app looks populated in a demo. Set to false for real use.
  final bool seedDemoData;
 
  List<ScanResult> _scans = [];
  bool _loaded = false;
 
  List<ScanResult> get scans => List.unmodifiable(_scans);
  bool get loaded => _loaded;
  int get total => _scans.length;
  int get healthyCount => _scans.where((s) => s.isHealthy).length;
  int get diseasedCount => total - healthyCount;
  bool get hasSampleData => _scans.any((s) => s.isSample);
  List<ScanResult> recent([int n = 3]) => _scans.take(n).toList();
 
  Future<void> load() async {
    _scans = await repository.all();
    if (_scans.isEmpty && seedDemoData) {
      for (final s in _demoRecords()) {
        await repository.insert(s);
      }
      _scans = await repository.all();
    }
    _loaded = true;
    notifyListeners();
  }
 
  /// Runs the classifier. Does NOT save: the user presses Save on Result.
  Future<ScanResult> classify({String? imagePath}) =>
      classifier.classify(imagePath: imagePath);
 
  Future<ScanResult> save(ScanResult result) async {
    final saved = await repository.insert(result);
    _scans = await repository.all();
    notifyListeners();
    return saved;
  }
 
  Future<void> delete(ScanResult result) async {
    final id = result.id;
    if (id == null) return;
    // Remove from the list first so Dismissible (swipe) sees it gone at once.
    _scans = _scans.where((s) => s.id != id).toList();
    notifyListeners();
    await repository.delete(id);
  }
 
  /// Undo for delete.
  Future<void> restore(ScanResult result) => save(result);
 
  List<ScanResult> _demoRecords() {
    final now = DateTime.now();
    ScanResult r(String id, double c, DiseaseSeverity sev, Duration ago,
            List<Prediction> top) =>
        ScanResult(
          diseaseId: id,
          confidence: c,
          severity: sev,
          topPredictions: top,
          createdAt: now.subtract(ago),
          isSample: true,
        );
    return [
      r('powdery_mildew', 0.94, DiseaseSeverity.moderate,
          const Duration(minutes: 20), const [
        Prediction('powdery_mildew', 0.94),
        Prediction('downy_mildew', 0.04),
        Prediction('healthy', 0.02),
      ]),
      r('healthy', 0.99, DiseaseSeverity.healthy,
          const Duration(minutes: 50), const [
        Prediction('healthy', 0.99),
        Prediction('powdery_mildew', 0.01),
      ]),
      r('black_rot', 0.91, DiseaseSeverity.severe,
          const Duration(days: 1, hours: 3), const [
        Prediction('black_rot', 0.91),
        Prediction('leaf_blight', 0.06),
        Prediction('downy_mildew', 0.03),
      ]),
      r('healthy', 0.97, DiseaseSeverity.healthy,
          const Duration(days: 1, hours: 6), const [
        Prediction('healthy', 0.97),
        Prediction('powdery_mildew', 0.03),
      ]),
      r('downy_mildew', 0.88, DiseaseSeverity.mild,
          const Duration(days: 3), const [
        Prediction('downy_mildew', 0.88),
        Prediction('powdery_mildew', 0.07),
        Prediction('leaf_blight', 0.05),
      ]),
      r('leaf_blight', 0.85, DiseaseSeverity.moderate,
          const Duration(days: 4), const [
        Prediction('leaf_blight', 0.85),
        Prediction('black_rot', 0.09),
        Prediction('downy_mildew', 0.06),
      ]),
    ];
  }
}
 