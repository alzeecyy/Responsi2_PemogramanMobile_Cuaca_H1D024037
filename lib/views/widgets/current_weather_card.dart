import 'package:flutter/material.dart';

import '../../core/utils/weather_code.dart';
import '../../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({
    super.key,
    required this.current,
    required this.today,
  });

  final CurrentWeather current;
  final DailyForecast today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onColor = theme.colorScheme.onPrimary;
    final info = describeWeatherCode(current.weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Icon(info.icon, size: 72, color: onColor),
          const SizedBox(height: 8),
          Text(
            '${current.temperature.round()}°C',
            style: theme.textTheme.displayLarge?.copyWith(color: onColor),
          ),
          Text(
            info.description,
            style: theme.textTheme.titleLarge?.copyWith(color: onColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Terasa ${current.apparentTemperature.round()}°  •  '
            'T ${today.tempMax.round()}°  R ${today.tempMin.round()}°',
            style: theme.textTheme.bodyMedium?.copyWith(color: onColor),
          ),
        ],
      ),
    );
  }
}
