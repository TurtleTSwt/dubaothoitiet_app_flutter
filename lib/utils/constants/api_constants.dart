

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  static const int connectTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 10;

  // 2 người dùng chung để response luôn đúng field
  static const String currentParams =
      'temperature_2m,relative_humidity_2m,apparent_temperature,'
      'weather_code,wind_speed_10m,is_day';

  static const String hourlyParams =
      'temperature_2m,weather_code,precipitation_probability';

  static const String dailyParams =
      'weather_code,temperature_2m_max,temperature_2m_min,'
      'sunrise,sunset';

  static const String timezone = 'auto';
  static const int forecastDays = 7;
}