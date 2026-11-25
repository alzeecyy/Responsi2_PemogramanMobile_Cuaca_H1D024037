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
      color: theme.colorScheme.secondaryContainer.withAlpha(90),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text('Prakiraan ${daily.length} hari',
                  style: theme.textTheme.titleMedium),
            ),
            for (var i = 0; i < daily.length; i++)
              ListTile(
                dense: true,
                leading: Icon(describeWeatherCode(daily[i].weatherCode).icon),
                title: Text(
                  i == 0 ? 'Hari ini' : dayFormat.format(daily[i].date),
                  style: theme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  '${describeWeatherCode(daily[i].weatherCode).description}'
                  ' • hujan ${daily[i].precipitationProbability}%',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Text(
                  '${daily[i].tempMax.round()}° / ${daily[i].tempMin.round()}°',
                  style: theme.textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
