import 'package:flutter_application_1/data/disease_catalog.dart';
import 'package:flutter_application_1/models/scan_result.dart';
import 'package:flutter_application_1/repositories/scan_repository.dart';
import 'package:flutter_application_1/services/disease_classifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock classifier returns a valid, known result', () async {
    final result = await MockDiseaseClassifier().classify();

    expect(result.confidence, inInclusiveRange(0, 1));
    expect(result.topPredictions, isNotEmpty);
    expect(DiseaseCatalog.byId(result.diseaseId).id, isNot('unknown'));
  });

  test('ScanResult survives a database map round-trip', () async {
    final original = await MockDiseaseClassifier().classify();
    final copy = ScanResult.fromMap(original.copyWith(id: 7).toMap());

    expect(copy.id, 7);
    expect(copy.diseaseId, original.diseaseId);
    expect(copy.severity, original.severity);
    expect(copy.topPredictions.length, original.topPredictions.length);
  });

  test('in-memory repository inserts, orders and deletes', () async {
    final repo = InMemoryScanRepository();
    final classifier = MockDiseaseClassifier();

    final a = await repo.insert(await classifier.classify());
    await repo.insert(await classifier.classify());
    expect((await repo.all()).length, 2);

    await repo.delete(a.id!);
    expect((await repo.all()).length, 1);
  });

  test('every catalog disease has treatment text', () {
    for (final d in DiseaseCatalog.all) {
      expect(d.treatment, isNotEmpty, reason: d.id);
    }
  });
}