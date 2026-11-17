import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_snapshot.dart';

class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);
  @override
  String toString() => 'WeatherException: $message';
}

abstract class WeatherService {
  Future<WeatherSnapshot> fetch({
    required double latitude,
    required double longitude,
  });
}

/// Open-Meteo: free, no API key. https://open-meteo.com
class OpenMeteoWeatherService implements WeatherService {
  final http.Client _client;
  OpenMeteoWeatherService({http.Client? client})
      : _client = client ?? http.Client();

  @override
  Future<WeatherSnapshot> fetch({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'weather_code,wind_speed_10m',
      'daily': 'precipitation_sum',
      'past_days': '2',
      'forecast_days': '1',
      'timezone': 'auto',
    });

    final res = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw WeatherException('HTTP ${res.statusCode}');
    }
    return parse(res.body);
  }

  /// Public so it can be unit-tested without a network.
  static WeatherSnapshot parse(String body, {DateTime? now}) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final cur = json['current'] as Map<String, dynamic>;

      // daily.precipitation_sum = [two days ago, yesterday, today]
      final daily = (json['daily'] as Map<String, dynamic>?)?['precipitation_sum']
          as List<dynamic>?;
      double rain = 0;
      if (daily != null) {
        for (final v in daily.take(2)) {
          rain += (v as num?)?.toDouble() ?? 0;
        }
      }

      return WeatherSnapshot(
        temperatureC: (cur['temperature_2m'] as num).toDouble(),
        apparentC: (cur['apparent_temperature'] as num).toDouble(),
        humidity: (cur['relative_humidity_2m'] as num).toDouble(),
        windKmh: (cur['wind_speed_10m'] as num).toDouble(),
        weatherCode: (cur['weather_code'] as num).toInt(),
        rain48hMm: rain,
        fetchedAt: now ?? DateTime.now(),
      );
    } catch (e) {
      throw WeatherException('Unexpected response: $e');
    }
  }
}