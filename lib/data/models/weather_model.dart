
import 'package:equatable/equatable.dart';
import 'forecast_model.dart';
import 'location_model.dart';

/// Thời tiết hiện tại (block "current" trong response)
class CurrentWeatherModel extends Equatable {
  final double temp;
  final double feelsLike;
  final int humidity;       // %
  final double windSpeed;   // km/h
  final int weatherCode;    // Mã WMO -> map sang condition/icon
  final bool isDay;         // true = ban ngày, false = ban đêm (để đổi icon/theme)

  const CurrentWeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temp: (json['temperature_2m'] as num).toDouble(),
      feelsLike: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: json['weather_code'] as int,
      isDay: json['is_day'] == 1,
    );
  }

  @override
  List<Object?> get props =>
      [temp, feelsLike, humidity, windSpeed, weatherCode, isDay];
}

/// Model tổng — đây là object mà WeatherCubit sẽ emit trong WeatherState.Loaded
/// Gồm: vị trí + thời tiết hiện tại + 24h tới + 7 ngày tới
class WeatherModel extends Equatable {
  final LocationModel location;
  final CurrentWeatherModel current;
  final List<HourlyForecastModel> hourly;
  final List<DailyForecastModel> daily;
  final DateTime lastUpdated; // để hiển thị "Cập nhật lúc..." và phục vụ cache

  const WeatherModel({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.lastUpdated,
  });

  /// json ở đây là toàn bộ response gốc từ Open-Meteo cho 1 tọa độ,
  /// location được truyền riêng vì API thời tiết không trả tên thành phố.
  factory WeatherModel.fromJson(Map<String, dynamic> json, LocationModel location) {
    return WeatherModel(
      location: location,
      current: CurrentWeatherModel.fromJson(
        json['current'] as Map<String, dynamic>,
      ),
      hourly: parseHourlyList(json['hourly'] as Map<String, dynamic>),
      daily: parseDailyList(json['daily'] as Map<String, dynamic>),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [location, current, hourly, daily, lastUpdated];
}