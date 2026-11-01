import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
 
import '../models/scan_result.dart';
 
abstract class ScanRepository {
  Future<List<ScanResult>> all(); // newest first
  Future<ScanResult> insert(ScanResult result);
  Future<void> delete(int id);
}
 
/// Used on web / desktop (sqflite only supports Android and iOS).
/// Data is lost when the app restarts.
class InMemoryScanRepository implements ScanRepository {
  final List<ScanResult> _rows = [];
  int _nextId = 1;
 
  @override
  Future<List<ScanResult>> all() async {
    final copy = List.of(_rows)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return copy;
  }
 
  @override
  Future<ScanResult> insert(ScanResult result) async {
    final saved = result.copyWith(id: _nextId++);
    _rows.add(saved);
    return saved;
  }
 
  @override
  Future<void> delete(int id) async => _rows.removeWhere((r) => r.id == id);
}
 
class SqfliteScanRepository implements ScanRepository {
  Database? _db;
 
  Future<Database> get _database async => _db ??= await _open();
 
  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    return openDatabase(
      p.join(dir, 'grapecare.db'),
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE scans(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          disease_id TEXT NOT NULL,
          confidence REAL NOT NULL,
          severity TEXT NOT NULL,
          top_json TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          image_path TEXT,
          is_sample INTEGER NOT NULL DEFAULT 0
        )
      '''),
    );
  }
 
  @override
  Future<List<ScanResult>> all() async {
    final db = await _database;
    final rows = await db.query('scans', orderBy: 'created_at DESC');
    return rows.map(ScanResult.fromMap).toList();
  }
 
  @override
  Future<ScanResult> insert(ScanResult result) async {
    final db = await _database;
    final id = await db.insert('scans', result.toMap());
    return result.copyWith(id: id);
  }
 
  @override
  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }
}
 
/// SQLite on phones, in-memory everywhere else.
ScanRepository createScanRepository() {
  final isMobile = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  return isMobile ? SqfliteScanRepository() : InMemoryScanRepository();
}
 