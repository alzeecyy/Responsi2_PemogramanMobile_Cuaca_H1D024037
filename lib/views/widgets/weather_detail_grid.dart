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
      const _Detail(
        icon: Icons.water_drop_rounded,
        label: 'Kelembapan',
        unit: '%',
        accentColor: Color(0xFF0284C7), // Biru langit pastel
      ),
      const _Detail(
        icon: Icons.air_rounded,
        label: 'Kecepatan angin',
        unit: 'km/j',
        accentColor: Color(0xFF0D9488), // Toska / Teal segar
      ),
      const _Detail(
        icon: Icons.grain_rounded,
        label: 'Curah hujan',
        unit: 'mm',
        accentColor: Color(0xFF2563EB), // Indigo / Biru laut
      ),
      const _Detail(
        icon: Icons.umbrella_rounded,
        label: 'Peluang hujan',
        unit: '%',
        accentColor: Color(0xFF7C3AED), // Ungu pastel
      ),
    ];

    final values = [
      '${current.humidity}%',
      '${current.windSpeed.toStringAsFixed(1)} km/j',
      '${current.precipitation.toStringAsFixed(1)} mm',
      '${today.precipitationProbability}%',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < items.length; i++)
              SizedBox(
                width: width,
                child: _DetailTile(
                  detail: items[i],
                  value: values[i],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Detail {
  const _Detail({
    required this.icon,
    required this.label,
    required this.unit,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String unit;
  final Color accentColor;
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.detail,
    required this.value,
  });

  final _Detail detail;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: detail.accentColor.withValues(alpha: isDark ? 0.25 : 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                detail.icon,
                color: detail.accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
