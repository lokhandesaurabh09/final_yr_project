import '../models/weather_snapshot.dart';

/// Rule-based disease RISK estimate (0-100) from the weather.
///
/// IMPORTANT: these are simple textbook-style heuristics (each disease has a
/// favourable temperature band, plus humidity / recent-rain conditions).
/// They are NOT trained or validated on field data, and they do not use the
/// user's scans. Present them as an "estimate". Have an agriculture expert
/// review the thresholds before claiming more.
class DiseaseRisk {
  /// Keys match the ids in the disease catalog.
  static const List<String> ids = [
    'powdery_mildew',
    'downy_mildew',
    'black_rot',
    'leaf_blight',
  ];

  /// 0 below [a], rises to 1 at [b], stays 1 until [c], falls to 0 at [d].
  static double _band(double x, double a, double b, double c, double d) {
    if (x <= a || x >= d) return 0;
    if (x >= b && x <= c) return 1;
    return x < b ? (x - a) / (b - a) : (d - x) / (d - c);
  }

  static double _c01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

  static int _pct(double v) => (_c01(v) * 100).round();

  static Map<String, int> estimate(WeatherSnapshot w) {
    final t = w.temperatureC;
    final h = w.humidity;
    final rain = w.rain48hMm;

    // Powdery mildew: warm, humid but not very wet (rain washes spores off).
    final powdery =
        _band(t, 10, 20, 27, 33) * _band(h, 40, 60, 85, 101) * (rain > 15 ? 0.6 : 1.0);

    // Downy mildew: mild-warm and wet (recent rain or very humid air).
    final wet = _c01((rain / 10) > ((h - 70) / 25) ? rain / 10 : (h - 70) / 25);
    final downy = _band(t, 8, 18, 26, 32) * wet;

    // Black rot: warm and prolonged wetness.
    final black = _band(t, 10, 20, 28, 34) *
        (_c01(rain / 12) * 0.7 + _c01((h - 75) / 20) * 0.3);

    // Leaf blight: warm to hot and humid.
    final blight = _band(t, 18, 24, 30, 36) * _c01((h - 65) / 25);

    return {
      'powdery_mildew': _pct(powdery),
      'downy_mildew': _pct(downy),
      'black_rot': _pct(black),
      'leaf_blight': _pct(blight),
    };
  }

  /// Highest risk first.
  static List<MapEntry<String, int>> ranked(Map<String, int> scores) {
    final list = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }
}
