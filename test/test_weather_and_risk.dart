// Copy to test/weather_test.dart
import 'package:flutter_application_1/models/weather_snapshot.dart';
import 'package:flutter_application_1/services/disease_risk.dart';
import 'package:flutter_application_1/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _sample = '''
{
  "current": {
    "temperature_2m": 27.4, "relative_humidity_2m": 71,
    "apparent_temperature": 29.1, "weather_code": 2, "wind_speed_10m": 11.5
  },
  "daily": {"precipitation_sum": [1.5, 3.0, 0.0]}
}
''';

WeatherSnapshot _w({double t = 25, double h = 70, double rain = 0}) =>
    WeatherSnapshot(
      temperatureC: t,
      apparentC: t,
      humidity: h,
      windKmh: 5,
      weatherCode: 0,
      rain48hMm: rain,
      fetchedAt: DateTime(2026, 1, 1),
    );

void main() {
  test('parses an Open-Meteo response', () {
    final s = OpenMeteoWeatherService.parse(_sample);
    expect(s.temperatureC, 27.4);
    expect(s.humidity, 71);
    expect(s.rain48hMm, 4.5); // 1.5 + 3.0, today is not counted
    expect(s.kind, WeatherKind.partlyCloudy);
  });

  test('bad JSON becomes a WeatherException', () {
    expect(() => OpenMeteoWeatherService.parse('{"oops": 1}'),
        throwsA(isA<WeatherException>()));
  });

  test('service fetches through an injected client', () async {
    final client = MockClient((req) async {
      expect(req.url.host, 'api.open-meteo.com');
      return http.Response(_sample, 200);
    });
    final s = await OpenMeteoWeatherService(client: client)
        .fetch(latitude: 19.99, longitude: 73.79);
    expect(s.windKmh, 11.5);
  });

  test('non-200 response throws', () async {
    final client = MockClient((_) async => http.Response('no', 500));
    expect(
      () => OpenMeteoWeatherService(client: client)
          .fetch(latitude: 0, longitude: 0),
      throwsA(isA<WeatherException>()),
    );
  });

  test('all risk scores stay within 0..100', () {
    for (var t = -5.0; t <= 45; t += 5) {
      for (var h = 0.0; h <= 100; h += 20) {
        for (final rain in [0.0, 5.0, 20.0, 80.0]) {
          final r = DiseaseRisk.estimate(_w(t: t, h: h, rain: rain));
          for (final v in r.values) {
            expect(v, inInclusiveRange(0, 100));
          }
          expect(r.keys.toSet(), DiseaseRisk.ids.toSet());
        }
      }
    }
  });

  test('wet mild weather raises downy mildew; dry hot air lowers it', () {
    final wet = DiseaseRisk.estimate(_w(t: 22, h: 95, rain: 15));
    final dry = DiseaseRisk.estimate(_w(t: 38, h: 30, rain: 0));
    expect(wet['downy_mildew']!, greaterThan(60));
    expect(dry['downy_mildew']!, 0);
  });

  test('ranked() puts the highest risk first', () {
    final top = DiseaseRisk.ranked({'a': 10, 'b': 80, 'c': 40}).first;
    expect(top.key, 'b');
  });
}
