class WeatherIconMapper {
  /// Lấy lời mô tả thời tiết tiếng Việt từ mã WMO
  static String getDescription(int? code) {
    return switch (code) {
      0 => 'Trời quang đãng',
      1 => 'Ít mây',
      2 => 'Có mây rải rác',
      3 => 'Trời nhiều mây / U ám',
      45 || 48 => 'Sương mù',
      51 || 53 || 55 => 'Mưa phùn',
      61 || 63 || 65 => 'Mưa rào',
      80 || 81 || 82 => 'Mưa lớn rào rạt',
      95 || 96 || 99 => 'Có dông bão / Sấm sét',
      _ => 'Thời tiết không xác định',
    };
  }

  /// Lấy đường dẫn ảnh Asset (Nếu bạn có dùng hình ảnh thật)
  static String getIconAsset(int? code, {bool isDay = true}) {
    return switch (code) {
      0 => isDay ? 'assets/icons/clear_day.png' : 'assets/icons/clear_night.png',
      1 || 2 => isDay ? 'assets/icons/partly_cloudy_day.png' : 'assets/icons/partly_cloudy_night.png',
      3 => 'assets/icons/cloudy.png',
      45 || 48 => 'assets/icons/fog.png',
      51 || 53 || 55 => 'assets/icons/drizzle.png',
      61 || 63 || 65 || 80 || 81 || 82 => 'assets/icons/rain.png',
      95 || 96 || 99 => 'assets/icons/thunderstorm.png',
      _ => 'assets/icons/default.png',
    };
  }

  /// Lấy nhanh Emoji biểu tượng thời tiết (Hiển thị ngay không cần thêm ảnh asset)
  static String getIconEmoji(int? code) {
    return switch (code) {
      0 => '☀️',
      1 || 2 => '⛅',
      3 => '☁️',
      45 || 48 => '🌫️',
      51 || 53 || 55 => '🌦️',
      61 || 63 || 65 || 80 || 81 || 82 => '🌧️',
      95 || 96 || 99 => '⛈️',
      _ => '🌡️',
    };
  }
}