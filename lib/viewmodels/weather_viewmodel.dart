import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_service.dart';

enum ViewState { idle, loading, success, empty, error }

/// ViewModel untuk Home / Weather Screen.
class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._service, this._storage);

  final WeatherService _service;
  final LocalStorageService _storage;

  static const defaultLocation = LocationModel(
    id: 1642911,
    name: 'Jakarta',
    latitude: -6.2146,
    longitude: 106.8451,
    country: 'Indonesia',
    admin1: 'Jakarta',
  );

  LocationModel _location = defaultLocation;
  WeatherModel? _weather;
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  int _requestId = 0;

  LocationModel get location => _location;
  WeatherModel? get weather => _weather;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  /// Memuat lokasi terakhir yang tersimpan, atau lokasi default.
  Future<void> init() async {
    final saved = await _storage.loadLastLocation();
    await selectLocation(saved ?? defaultLocation);
  }

  Future<void> selectLocation(LocationModel location) async {
    _location = location;
    await _storage.saveLastLocation(location);
    await _load();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    final id = ++_requestId;
    _state = ViewState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _service.fetchWeather(_location);
      if (id != _requestId) return; // Ada permintaan yang lebih baru.
      _weather = result;
      _state = result.daily.isEmpty ? ViewState.empty : ViewState.success;
    } on EmptyDataException catch (e) {
      if (id != _requestId) return;
      _weather = null;
      _errorMessage = e.message;
      _state = ViewState.empty;
    } on ApiException catch (e) {
      if (id != _requestId) return;
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (_) {
      if (id != _requestId) return;
      _errorMessage = 'Terjadi kesalahan yang tidak terduga.';
      _state = ViewState.error;
    }
    notifyListeners();
  }
}
