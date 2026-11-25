import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_service.dart';

enum SearchStatus { idle, loading, success, empty, error }

/// ViewModel untuk Search / Location Screen (pencarian, favorit, riwayat).
class LocationViewModel extends ChangeNotifier {
  LocationViewModel(this._service, this._storage);

  final WeatherService _service;
  final LocalStorageService _storage;

  static const _maxHistory = 10;

  Timer? _debounce;
  int _requestId = 0;

  String _query = '';
  SearchStatus _status = SearchStatus.idle;
  String _errorMessage = '';
  List<LocationModel> _results = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _history = [];

  String get query => _query;
  SearchStatus get status => _status;
  String get errorMessage => _errorMessage;
  List<LocationModel> get results => List.unmodifiable(_results);
  List<LocationModel> get favorites => List.unmodifiable(_favorites);
  List<LocationModel> get history => List.unmodifiable(_history);

  Future<void> init() async {
    _favorites = await _storage.loadFavorites();
    _history = await _storage.loadHistory();
    notifyListeners();
  }

  /// Dipanggil setiap teks berubah; pencarian ditunda 500 ms (debounce).
  void onQueryChanged(String value) {
    _query = value;
    _debounce?.cancel();

    if (value.trim().length < 2) {
      _requestId++;
      _results = [];
      _status = SearchStatus.idle;
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => search(value));
  }

  Future<void> search(String value) async {
    final keyword = value.trim();
    if (keyword.length < 2) return;
    _debounce?.cancel();

    final id = ++_requestId;
    _query = value;
    _status = SearchStatus.loading;
    notifyListeners();

    try {
      final data = await _service.searchLocations(keyword);
      if (id != _requestId) return;
      _results = data;
      _status = data.isEmpty ? SearchStatus.empty : SearchStatus.success;
    } on ApiException catch (e) {
      if (id != _requestId) return;
      _errorMessage = e.message;
      _status = SearchStatus.error;
    } catch (_) {
      if (id != _requestId) return;
      _errorMessage = 'Terjadi kesalahan yang tidak terduga.';
      _status = SearchStatus.error;
    }
    notifyListeners();
  }

  bool isFavorite(LocationModel location) => _favorites.contains(location);

  Future<void> toggleFavorite(LocationModel location) async {
    if (isFavorite(location)) {
      _favorites = _favorites.where((e) => e != location).toList();
    } else {
      _favorites = [location, ..._favorites];
    }
    notifyListeners();
    await _storage.saveFavorites(_favorites);
  }

  Future<void> addToHistory(LocationModel location) async {
    _history = [
      location,
      ..._history.where((e) => e != location),
    ].take(_maxHistory).toList();
    notifyListeners();
    await _storage.saveHistory(_history);
  }

  Future<void> clearHistory() async {
    _history = [];
    notifyListeners();
    await _storage.saveHistory(_history);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
