
/// Tất cả các key dùng để đọc/ghi SharedPreferences PHẢI khai báo ở đây.
/// Không được hardcode string key trực tiếp trong code — tránh trường hợp
/// 2 người đặt tên khác nhau dẫn đến đọc nhầm/ghi đè dữ liệu của nhau.
class StorageKeys {
  StorageKeys._();

  // Settings
  static const String tempUnit = 'temp_unit';       // giá trị: 'celsius' | 'fahrenheit'
  static const String themeMode = 'theme_mode';     // giá trị: 'light' | 'dark' | 'system'
  static const String appLanguage = 'app_language'; // giá trị: 'vi' | 'en'

  // Vị trí đã lưu lần cuối — để mở app lên hiển thị ngay, không phải chờ GPS
  static const String lastLat = 'last_lat';         // double
  static const String lastLon = 'last_lon';         // double
  static const String lastLocationName = 'last_location_name'; // String

  // Lịch sử tìm kiếm thành phố (optional, nếu làm tính năng "recent searches")
  static const String recentSearches = 'recent_searches'; // List<String> (json encode)

  // Cache thời tiết offline (nếu làm được thì tốt, không bắt buộc MVP)
  static const String cachedWeatherJson = 'cached_weather_json'; // String (raw json)
  static const String cachedWeatherTimestamp = 'cached_weather_timestamp'; // int (millis)
}