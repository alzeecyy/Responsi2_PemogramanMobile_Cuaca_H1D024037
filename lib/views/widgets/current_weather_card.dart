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
    final isDark = theme.brightness == Brightness.dark;
    final info = describeWeatherCode(current.weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                  Color(0xFF090D16),
                ]
              : const [
                  Color(0xFF38BDF8), // Biru langit cerah (luminous sky)
                  Color(0xFF2563EB), // Biru royal kaya
                  Color(0xFF1E40AF), // Biru samudra dalam
                ],
          stops: const [0.0, 0.52, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF2563EB))
                .withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(info.icon, size: 80, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            '${current.temperature.round()}°C',
            style: theme.textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            info.description,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Text(
              'Terasa ${current.apparentTemperature.round()}°  •  '
              'T ${today.tempMax.round()}°  R ${today.tempMin.round()}°',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
