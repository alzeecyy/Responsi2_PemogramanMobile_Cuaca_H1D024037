import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'services/local_storage_service.dart';
import 'services/weather_service.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherService>(create: (_) => WeatherService()),
        Provider<LocalStorageService>(create: (_) => LocalStorageService()),
        ChangeNotifierProvider<WeatherViewModel>(
          create: (context) => WeatherViewModel(
            context.read<WeatherService>(),
            context.read<LocalStorageService>(),
          )..init(),
        ),
        ChangeNotifierProvider<LocationViewModel>(
          create: (context) => LocationViewModel(
            context.read<WeatherService>(),
            context.read<LocalStorageService>(),
          )..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Cuaca Kita',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
