import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';
import '../models/weather_model.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Dilempar ketika API merespons sukses tetapi tanpa data yang dibutuhkan.
class EmptyDataException extends ApiException {
  const EmptyDataException([super.message = 'Data cuaca tidak tersedia.']);
}

/// Mengakses REST API Open-Meteo (Geocoding & Forecast) dengan HTTP GET.
class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _timeout = Duration(seconds: 15);

  Future<List<LocationModel>> searchLocations(String name) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': name,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    final body = await _get(uri);
    final results = body['results'] as List<dynamic>?;
    if (results == null) return [];

    return results
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WeatherModel> fetchWeather(LocationModel location) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'precipitation,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final body = await _get(uri);
    if (body['current'] == null || body['daily'] == null) {
      throw const EmptyDataException();
    }

    try {
      return WeatherModel.fromJson(body);
    } on TypeError {
      throw const ApiException('Format data dari server tidak sesuai.');
    }
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw ApiException('Server mengembalikan kode ${response.statusCode}.');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw const ApiException('Permintaan melebihi batas waktu.');
    } on http.ClientException {
      throw const ApiException('Gagal terhubung ke server.');
    } on FormatException {
      throw const ApiException('Respons server tidak valid.');
    }
  }
}
