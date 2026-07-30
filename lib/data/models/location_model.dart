
import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String name;      // City name
  final String? country;  // "Vietnam" — có thể null nếu lấy từ GPS chưa reverse-geocode
  final double lat;
  final double lon;

  const LocationModel({
    required this.name,
    required this.lat,
    required this.lon,
    this.country,
  });

  /// Dùng khi parse kết quả từ Geocoding API (tìm kiếm thành phố)
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String,
      country: json['country'] as String?,
      lat: (json['latitude'] as num).toDouble(),
      lon: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'latitude': lat,
      'longitude': lon,
    };
  }

  @override
  List<Object?> get props => [name, country, lat, lon];
}