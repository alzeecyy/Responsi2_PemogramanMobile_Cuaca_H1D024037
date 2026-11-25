import 'package:flutter/material.dart';

/// Deskripsi dan ikon untuk kode cuaca WMO yang dikembalikan Open-Meteo.
class WeatherCodeInfo {
  const WeatherCodeInfo(this.description, this.icon);

  final String description;
  final IconData icon;
}

WeatherCodeInfo describeWeatherCode(int code) {
  switch (code) {
    case 0:
      return const WeatherCodeInfo('Cerah', Icons.wb_sunny);
    case 1:
      return const WeatherCodeInfo('Cerah berawan', Icons.wb_sunny_outlined);
    case 2:
      return const WeatherCodeInfo('Berawan sebagian', Icons.cloud_queue);
    case 3:
      return const WeatherCodeInfo('Mendung', Icons.cloud);
    case 45:
    case 48:
      return const WeatherCodeInfo('Berkabut', Icons.blur_on);
    case 51:
    case 53:
    case 55:
      return const WeatherCodeInfo('Gerimis', Icons.grain);
    case 56:
    case 57:
      return const WeatherCodeInfo('Gerimis beku', Icons.grain);
    case 61:
      return const WeatherCodeInfo('Hujan ringan', Icons.water_drop_outlined);
    case 63:
      return const WeatherCodeInfo('Hujan sedang', Icons.water_drop);
    case 65:
      return const WeatherCodeInfo('Hujan lebat', Icons.water_drop);
    case 66:
    case 67:
      return const WeatherCodeInfo('Hujan beku', Icons.water_drop);
    case 71:
    case 73:
    case 75:
    case 77:
      return const WeatherCodeInfo('Salju', Icons.ac_unit);
    case 80:
    case 81:
    case 82:
      return const WeatherCodeInfo('Hujan deras sesaat', Icons.water_drop);
    case 85:
    case 86:
      return const WeatherCodeInfo('Hujan salju', Icons.ac_unit);
    case 95:
      return const WeatherCodeInfo('Badai petir', Icons.thunderstorm);
    case 96:
    case 99:
      return const WeatherCodeInfo(
          'Badai petir disertai es', Icons.thunderstorm);
    default:
      return const WeatherCodeInfo('Tidak diketahui', Icons.help_outline);
  }
}
