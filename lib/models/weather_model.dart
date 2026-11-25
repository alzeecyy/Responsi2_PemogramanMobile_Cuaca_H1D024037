/// Cuaca saat ini (field `current` pada Open-Meteo).
class CurrentWeather {
  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
    );
  }
}

/// Prakiraan satu hari.
class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbability,
  });

  final DateTime date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final int precipitationProbability;
}

class WeatherModel {
  const WeatherModel({required this.current, required this.daily});

  final CurrentWeather current;
  final List<DailyForecast> daily;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(
      json['current'] as Map<String, dynamic>,
    );

    final d = json['daily'] as Map<String, dynamic>;
    final times = d['time'] as List<dynamic>;
    final codes = d['weather_code'] as List<dynamic>;
    final maxes = d['temperature_2m_max'] as List<dynamic>;
    final mins = d['temperature_2m_min'] as List<dynamic>;
    final probs = d['precipitation_probability_max'] as List<dynamic>;

    final daily = List<DailyForecast>.generate(times.length, (i) {
      return DailyForecast(
        date: DateTime.parse(times[i] as String),
        weatherCode: (codes[i] as num?)?.toInt() ?? 0,
        tempMax: (maxes[i] as num?)?.toDouble() ?? 0,
        tempMin: (mins[i] as num?)?.toDouble() ?? 0,
        precipitationProbability: (probs[i] as num?)?.toInt() ?? 0,
      );
    });

    return WeatherModel(current: current, daily: daily);
  }
}
