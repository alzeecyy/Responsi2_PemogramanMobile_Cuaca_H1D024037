import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/weather_viewmodel.dart';
import 'search_screen.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/state_message.dart';
import 'widgets/weather_detail_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final location = vm.location;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location.name, style: textTheme.titleLarge),
            if (location.subtitle.isNotEmpty)
              Text(location.subtitle, style: textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cari lokasi',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _HomeBody(vm: vm)),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.vm});

  final WeatherViewModel vm;

  @override
  Widget build(BuildContext context) {
    switch (vm.state) {
      case ViewState.idle:
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return StateMessage(
          icon: Icons.cloud_off,
          title: 'Gagal memuat cuaca',
          message: vm.errorMessage,
          actionLabel: 'Coba lagi',
          onAction: vm.refresh,
        );
      case ViewState.empty:
        return StateMessage(
          icon: Icons.inbox_outlined,
          title: 'Data kosong',
          message: vm.errorMessage.isEmpty
              ? 'Belum ada data cuaca untuk lokasi ini.'
              : vm.errorMessage,
          actionLabel: 'Muat ulang',
          onAction: vm.refresh,
        );
      case ViewState.success:
        final weather = vm.weather!;
        final today = weather.daily.first;
        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    children: [
                      CurrentWeatherCard(
                        current: weather.current,
                        today: today,
                      ),
                      const SizedBox(height: 16),
                      WeatherDetailGrid(
                        current: weather.current,
                        today: today,
                      ),
                      const SizedBox(height: 16),
                      DailyForecastList(daily: weather.daily),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}
