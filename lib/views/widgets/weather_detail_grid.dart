import 'package:flutter/material.dart';

import '../../models/weather_model.dart';

class WeatherDetailGrid extends StatelessWidget {
  const WeatherDetailGrid({
    super.key,
    required this.current,
    required this.today,
  });

  final CurrentWeather current;
  final DailyForecast today;

  @override
  Widget build(BuildContext context) {
    final items = <_Detail>[
      _Detail(Icons.water_drop_outlined, 'Kelembapan', '${current.humidity}%'),
      _Detail(Icons.air, 'Kecepatan angin',
          '${current.windSpeed.toStringAsFixed(1)} km/j'),
      _Detail(Icons.grain, 'Curah hujan',
          '${current.precipitation.toStringAsFixed(1)} mm'),
      _Detail(Icons.umbrella_outlined, 'Peluang hujan',
          '${today.precipitationProbability}%'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(width: width, child: _DetailTile(detail: item)),
          ],
        );
      },
    );
  }
}

class _Detail {
  const _Detail(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.detail});

  final _Detail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(detail.icon, color: theme.colorScheme.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.label,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(detail.value, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
