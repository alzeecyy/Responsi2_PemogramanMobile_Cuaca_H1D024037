import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/weather_code.dart';
import '../../models/weather_model.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.daily});

  final List<DailyForecast> daily;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayFormat = DateFormat('EEEE, d MMM', 'id_ID');

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prakiraan ${daily.length} Hari ke Depan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            for (var i = 0; i < daily.length; i++) ...[
              ListTile(
                dense: true,
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    describeWeatherCode(daily[i].weatherCode).icon,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                title: Text(
                  i == 0 ? 'Hari ini' : dayFormat.format(daily[i].date),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: i == 0 ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${describeWeatherCode(daily[i].weatherCode).description}'
                  ' • peluang hujan ${daily[i].precipitationProbability}%',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Text(
                  '${daily[i].tempMax.round()}° / ${daily[i].tempMin.round()}°',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (i < daily.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
