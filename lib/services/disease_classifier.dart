import '../models/scan_result.dart';
 
/// Anything that can turn a leaf image into a [ScanResult].
///
/// The UI only talks to this interface. To plug in the trained model, create
/// `TfliteDiseaseClassifier implements DiseaseClassifier` and swap it in
/// `main.dart`. No screen code has to change.
abstract class DiseaseClassifier {
  String get modelName;
 
  /// true while results are demo data, not real model output.
  bool get isMock;
 
  Future<ScanResult> classify({String? imagePath});
}
 
class _Sample {
  final String id;
  final double confidence;
  final DiseaseSeverity severity;
  final List<Prediction> top;
  const _Sample(this.id, this.confidence, this.severity, this.top);
}
 
/// Cycles through fixed sample outputs so every screen can be demoed.
class MockDiseaseClassifier implements DiseaseClassifier {
  int _next = 0;
 
  static const List<_Sample> _samples = [
    _Sample('powdery_mildew', 0.94, DiseaseSeverity.moderate, [
      Prediction('powdery_mildew', 0.94),
      Prediction('downy_mildew', 0.04),
      Prediction('healthy', 0.02),
    ]),
    _Sample('healthy', 0.97, DiseaseSeverity.healthy, [
      Prediction('healthy', 0.97),
      Prediction('powdery_mildew', 0.02),
      Prediction('leaf_blight', 0.01),
    ]),
    _Sample('black_rot', 0.91, DiseaseSeverity.severe, [
      Prediction('black_rot', 0.91),
      Prediction('leaf_blight', 0.06),
      Prediction('downy_mildew', 0.03),
    ]),
    _Sample('downy_mildew', 0.88, DiseaseSeverity.mild, [
      Prediction('downy_mildew', 0.88),
      Prediction('powdery_mildew', 0.07),
      Prediction('leaf_blight', 0.05),
    ]),
    _Sample('leaf_blight', 0.85, DiseaseSeverity.moderate, [
      Prediction('leaf_blight', 0.85),
      Prediction('black_rot', 0.09),
      Prediction('downy_mildew', 0.06),
    ]),
  ];
 
  @override
  String get modelName => 'Demo classifier';
 
  @override
  bool get isMock => true;
 
  @override
  Future<ScanResult> classify({String? imagePath}) async {
    final s = _samples[_next % _samples.length];
    _next++;
    return ScanResult(
      diseaseId: s.id,
      confidence: s.confidence,
      severity: s.severity,
      topPredictions: s.top,
      createdAt: DateTime.now(),
      imagePath: imagePath,
      isSample: true,
    );
  }
}
 