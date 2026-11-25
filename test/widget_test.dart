import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/utils/weather_code.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  test('WeatherModel.fromJson mem-parsing respons Open-Meteo', () {
    final json = {
      'current': {
        'temperature_2m': 28.4,
        'relative_humidity_2m': 80,
        'apparent_temperature': 31.0,
        'precipitation': 0.2,
        'weather_code': 61,
        'wind_speed_10m': 9.5,
      },
      'daily': {
        'time': ['2026-11-25', '2026-11-26'],
        'weather_code': [61, 3],
        'temperature_2m_max': [30.1, 29.0],
        'temperature_2m_min': [23.0, 22.5],
        'precipitation_probability_max': [80, null],
      },
    };

    final model = WeatherModel.fromJson(json);
    expect(model.current.temperature, 28.4);
    expect(model.current.humidity, 80);
    expect(model.daily.length, 2);
    expect(model.daily[1].precipitationProbability, 0);
  });

  test('describeWeatherCode memetakan kode WMO', () {
    expect(describeWeatherCode(0).description, 'Cerah');
    expect(describeWeatherCode(95).description, 'Badai petir');
    expect(describeWeatherCode(999).description, 'Tidak diketahui');
  });
}
