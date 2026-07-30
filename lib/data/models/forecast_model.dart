
import 'package:equatable/equatable.dart';

/// 1 mốc giờ trong danh sách dự báo 24h tới
class HourlyForecastModel extends Equatable {
  final DateTime time;
  final double temp;
  final int weatherCode;              // Mã WMO -> map sang icon ở weather_icon_mapper.dart
  final int precipitationProbability; // % khả năng mưa, 0-100

  const HourlyForecastModel({
    required this.time,
    required this.temp,
    required this.weatherCode,
    required this.precipitationProbability,
  });

  @override
  List<Object?> get props => [time, temp, weatherCode, precipitationProbability];
}

/// 1 ngày trong danh sách dự báo 5-7 ngày tới
class DailyForecastModel extends Equatable {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final DateTime sunrise;
  final DateTime sunset;

  const DailyForecastModel({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.sunrise,
    required this.sunset,
  });

  @override
  List<Object?> get props => [date, tempMax, tempMin, weatherCode, sunrise, sunset];
}

/// Parse toàn bộ block "hourly" từ response Open-Meteo (dạng mảng song song)
/// thành List<HourlyForecastModel>. Chỉ lấy 24 mốc giờ tới tính từ hiện tại.
List<HourlyForecastModel> parseHourlyList(Map<String, dynamic> hourlyJson) {
  final times = hourlyJson['time'] as List;
  final temps = hourlyJson['temperature_2m'] as List;
  final codes = hourlyJson['weather_code'] as List;
  final precipProbs = hourlyJson['precipitation_probability'] as List;

  final now = DateTime.now();
  final result = <HourlyForecastModel>[];

  for (var i = 0; i < times.length; i++) {
    final time = DateTime.parse(times[i] as String);
    if (time.isBefore(now.subtract(const Duration(minutes: 59)))) continue;

    result.add(HourlyForecastModel(
      time: time,
      temp: (temps[i] as num).toDouble(),
      weatherCode: codes[i] as int,
      precipitationProbability: (precipProbs[i] as num).toInt(),
    ));

    if (result.length == 24) break;
  }
  return result;
}

/// Parse toàn bộ block "daily" từ response Open-Meteo
List<DailyForecastModel> parseDailyList(Map<String, dynamic> dailyJson) {
  final dates = dailyJson['time'] as List;
  final tempsMax = dailyJson['temperature_2m_max'] as List;
  final tempsMin = dailyJson['temperature_2m_min'] as List;
  final codes = dailyJson['weather_code'] as List;
  final sunrises = dailyJson['sunrise'] as List;
  final sunsets = dailyJson['sunset'] as List;

  return List.generate(dates.length, (i) {
    return DailyForecastModel(
      date: DateTime.parse(dates[i] as String),
      tempMax: (tempsMax[i] as num).toDouble(),
      tempMin: (tempsMin[i] as num).toDouble(),
      weatherCode: codes[i] as int,
      sunrise: DateTime.parse(sunrises[i] as String),
      sunset: DateTime.parse(sunsets[i] as String),
    );
  });
}