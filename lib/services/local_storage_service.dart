import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';

/// Penyimpanan lokal (SharedPreferences) untuk favorit, riwayat, dan
/// lokasi terakhir yang dipilih.
class LocalStorageService {
  static const _favoritesKey = 'favorite_locations';
  static const _historyKey = 'search_history';
  static const _lastLocationKey = 'last_location';

  Future<List<LocationModel>> loadFavorites() => _loadList(_favoritesKey);
  Future<void> saveFavorites(List<LocationModel> items) =>
      _saveList(_favoritesKey, items);

  Future<List<LocationModel>> loadHistory() => _loadList(_historyKey);
  Future<void> saveHistory(List<LocationModel> items) =>
      _saveList(_historyKey, items);

  Future<LocationModel?> loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastLocationKey);
    if (raw == null) return null;
    try {
      return LocationModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, jsonEncode(location.toJson()));
  }

  Future<List<LocationModel>> _loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(key) ?? [];
    final result = <LocationModel>[];
    for (final item in raw) {
      try {
        result.add(
          LocationModel.fromJson(jsonDecode(item) as Map<String, dynamic>),
        );
      } catch (_) {
        // Lewati data yang rusak.
      }
    }
    return result;
  }

  Future<void> _saveList(String key, List<LocationModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
