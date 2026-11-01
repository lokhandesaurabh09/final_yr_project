import 'dart:convert';
 
enum DiseaseSeverity { healthy, mild, moderate, severe }
 
class Prediction {
  final String diseaseId;
  final double score; // 0..1
 
  const Prediction(this.diseaseId, this.score);
 
  Map<String, dynamic> toJson() => {'id': diseaseId, 'score': score};
 
  factory Prediction.fromJson(Map<String, dynamic> j) =>
      Prediction(j['id'] as String, (j['score'] as num).toDouble());
}
 
/// One classification of one leaf image.
class ScanResult {
  final int? id; // null until saved to the database
  final String diseaseId;
  final double confidence; // 0..1
  final DiseaseSeverity severity;
  final List<Prediction> topPredictions;
  final DateTime createdAt;
  final String? imagePath;
 
  /// true when produced by the mock classifier or the demo seed data.
  final bool isSample;
 
  const ScanResult({
    this.id,
    required this.diseaseId,
    required this.confidence,
    required this.severity,
    required this.topPredictions,
    required this.createdAt,
    this.imagePath,
    this.isSample = false,
  });
 
  bool get isHealthy => severity == DiseaseSeverity.healthy;
 
  ScanResult copyWith({int? id}) => ScanResult(
        id: id ?? this.id,
        diseaseId: diseaseId,
        confidence: confidence,
        severity: severity,
        topPredictions: topPredictions,
        createdAt: createdAt,
        imagePath: imagePath,
        isSample: isSample,
      );
 
  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'disease_id': diseaseId,
        'confidence': confidence,
        'severity': severity.name,
        'top_json': jsonEncode(topPredictions.map((p) => p.toJson()).toList()),
        'created_at': createdAt.millisecondsSinceEpoch,
        'image_path': imagePath,
        'is_sample': isSample ? 1 : 0,
      };
 
  factory ScanResult.fromMap(Map<String, Object?> m) => ScanResult(
        id: m['id'] as int?,
        diseaseId: m['disease_id'] as String,
        confidence: (m['confidence'] as num).toDouble(),
        severity: DiseaseSeverity.values.byName(m['severity'] as String),
        topPredictions: (jsonDecode(m['top_json'] as String) as List)
            .map((e) => Prediction.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
        imagePath: m['image_path'] as String?,
        isSample: (m['is_sample'] as int? ?? 0) == 1,
      );
}
 