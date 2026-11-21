import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_snapshot.dart';
import '../services/disease_risk.dart';
import '../services/weather_service.dart';

enum WeatherStatus { loading, ready, error }

/// Loads weather for the vineyard, caches it, and exposes the risk estimate.
class WeatherProvider extends ChangeNotifier {
  WeatherProvider({
    required this.service,
    this.prefs,
    this.latitude = 19.9975, // Nashik
    this.longitude = 73.7898,
    this.placeName = 'Nashik, MH',
  });

  static const String _cacheKey = 'weather_cache';
  static const Duration _freshFor = Duration(minutes: 30);

  final WeatherService service;
  final SharedPreferences? prefs;
  final double latitude;
  final double longitude;
  final String placeName;

  WeatherSnapshot? _data;
  WeatherStatus _status = WeatherStatus.loading;
  bool _stale = false;

  WeatherSnapshot? get data => _data;
  WeatherStatus get status => _status;

  /// true when showing saved data because the network request failed.
  bool get isStale => _stale;

  Map<String, int> get risks =>
      _data == null ? const {} : DiseaseRisk.estimate(_data!);

  Future<void> load({bool force = false}) async {
    _data ??= _readCache();

    final fresh = _data != null &&
        DateTime.now().difference(_data!.fetchedAt) < _freshFor;
    if (fresh && !force) {
      _status = WeatherStatus.ready;
      _stale = false;
      notifyListeners();
      return;
    }

    _status = _data == null ? WeatherStatus.loading : WeatherStatus.ready;
    notifyListeners();

    try {
      final snap = await service.fetch(latitude: latitude, longitude: longitude);
      _data = snap;
      _stale = false;
      _status = WeatherStatus.ready;
      await prefs?.setString(_cacheKey, jsonEncode(snap.toJson()));
    } catch (_) {
      if (_data == null) {
        _status = WeatherStatus.error;
      } else {
        _stale = true; // keep showing the last good reading
        _status = WeatherStatus.ready;
      }
    }
    notifyListeners();
  }

  WeatherSnapshot? _readCache() {
    final raw = prefs?.getString(_cacheKey);
    if (raw == null) return null;
    try {
      return WeatherSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
