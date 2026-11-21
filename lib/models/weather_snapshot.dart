enum WeatherKind { clear, partlyCloudy, cloudy, fog, drizzle, rain, storm }

/// Current conditions for one place, plus recent rain.
class WeatherSnapshot {
  final double temperatureC;
  final double apparentC;
  final double humidity; // percent
  final double windKmh;
  final int weatherCode; // WMO code
  final double rain48hMm; // rain in the previous two days
  final DateTime fetchedAt;

  const WeatherSnapshot({
    required this.temperatureC,
    required this.apparentC,
    required this.humidity,
    required this.windKmh,
    required this.weatherCode,
    required this.rain48hMm,
    required this.fetchedAt,
  });

  WeatherKind get kind {
    final c = weatherCode;
    if (c == 0) return WeatherKind.clear;
    if (c == 1 || c == 2) return WeatherKind.partlyCloudy;
    if (c == 3) return WeatherKind.cloudy;
    if (c == 45 || c == 48) return WeatherKind.fog;
    if (c >= 51 && c <= 57) return WeatherKind.drizzle;
    if ((c >= 61 && c <= 67) || (c >= 80 && c <= 82)) return WeatherKind.rain;
    if (c >= 95) return WeatherKind.storm;
    return WeatherKind.cloudy;
  }

  Map<String, Object?> toJson() => {
        'temperatureC': temperatureC,
        'apparentC': apparentC,
        'humidity': humidity,
        'windKmh': windKmh,
        'weatherCode': weatherCode,
        'rain48hMm': rain48hMm,
        'fetchedAt': fetchedAt.millisecondsSinceEpoch,
      };

  factory WeatherSnapshot.fromJson(Map<String, dynamic> j) => WeatherSnapshot(
        temperatureC: (j['temperatureC'] as num).toDouble(),
        apparentC: (j['apparentC'] as num).toDouble(),
        humidity: (j['humidity'] as num).toDouble(),
        windKmh: (j['windKmh'] as num).toDouble(),
        weatherCode: (j['weatherCode'] as num).toInt(),
        rain48hMm: (j['rain48hMm'] as num).toDouble(),
        fetchedAt: DateTime.fromMillisecondsSinceEpoch(j['fetchedAt'] as int),
      );
}
