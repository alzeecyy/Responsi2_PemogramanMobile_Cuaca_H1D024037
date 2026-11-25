/// Model lokasi. Dipakai untuk hasil Geocoding API dan penyimpanan lokal.
class LocationModel {
  const LocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.id,
    this.country,
    this.admin1,
  });

  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'country': country,
        'admin1': admin1,
      };

  /// Contoh: "Jawa Tengah, Indonesia".
  String get subtitle => [admin1, country]
      .where((e) => e != null && e.isNotEmpty)
      .cast<String>()
      .join(', ');

  String get key =>
      '${latitude.toStringAsFixed(3)},${longitude.toStringAsFixed(3)}';

  @override
  bool operator ==(Object other) =>
      other is LocationModel && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
