import '../../logic/settings/settings_state.dart';

/// Chứa toàn bộ chuỗi text hiển thị trong app, theo 2 ngôn ngữ vi/en.
/// Cách dùng: AppStrings.of(tempUnit_hoac_language).homeTitle
///
/// Để đơn giản, class này không dùng codegen (intl/arb) mà là 1 Map tay —
/// đủ cho quy mô app hiện tại, dễ đọc, dễ thêm chuỗi mới không cần build_runner.
class AppStrings {
  final AppLanguage language;
  const AppStrings._(this.language);

  static AppStrings of(AppLanguage language) => AppStrings._(language);

  bool get _isEn => language == AppLanguage.en;

  // ===== AppBar / Home =====
  String get homeTitle => _isEn ? 'Weather' : 'Thời Tiết';
  String get emptyStateTitle =>
      _isEn ? 'No weather data yet' : 'Chưa có dữ liệu thời tiết';
  String get searchCityButton => _isEn ? 'Search a city' : 'Tìm thành phố ngay';
  String get errorPrefix => _isEn ? 'Error: ' : 'Lỗi: ';
  String get retryButton => _isEn ? 'Retry' : 'Thử lại';

  // ===== Current weather card =====
  String get feelsLike => _isEn ? 'Feels like' : 'Cảm nhận';
  String get humidity => _isEn ? 'Humidity' : 'Độ ẩm';
  String get wind => _isEn ? 'Wind' : 'Gió';

  // ===== Hourly / Daily sections =====
  String get hourlyTitle =>
      _isEn ? '24-HOUR FORECAST' : 'DỰ BÁO THỜI TIẾT 24 GIỜ';
  String get dailyTitle => _isEn ? '7-DAY FORECAST' : 'DỰ BÁO 7 NGÀY TỚI';
  String get noHourlyData =>
      _isEn ? 'No hourly data yet' : 'Chưa có dữ liệu theo giờ';
  String get noDailyData =>
      _isEn ? 'No 7-day data yet' : 'Chưa có dữ liệu 7 ngày';

  // ===== Search screen =====
  String get searchHint =>
      _isEn ? 'Search for a city...' : 'Tìm thành phố...';
  String get searchNoResults =>
      _isEn ? 'No cities found' : 'Không tìm thấy thành phố nào';
  String get searchTypeToStart =>
      _isEn ? 'Type a city name to search' : 'Nhập tên thành phố để tìm kiếm';

  // ===== Settings screen =====
  String get settingsTitle => _isEn ? 'Settings' : 'Cài đặt';
  String get sectionTempUnit =>
      _isEn ? 'Temperature unit' : 'Đơn vị nhiệt độ';
  String get sectionTheme => _isEn ? 'Appearance' : 'Giao diện';
  String get sectionLanguage => _isEn ? 'Language' : 'Ngôn ngữ';
  String get themeLight => _isEn ? 'Light' : 'Sáng';
  String get themeDark => _isEn ? 'Dark' : 'Tối';
  String get themeSystem => _isEn ? 'System' : 'Hệ thống';
  String get languageVi => 'Tiếng Việt';
  String get languageEn => 'English';

  // ===== Location permission =====
  String get permissionDeniedTitle =>
      _isEn ? 'Location permission needed' : 'Cần quyền vị trí';
  String get permissionDeniedMessage => _isEn
      ? 'Weather needs location access to show weather at your location.'
      : 'Ứng dụng cần quyền truy cập vị trí để hiển thị thời tiết tại nơi bạn đang ở.';
  String get permissionDeniedForeverMessage => _isEn
      ? 'Location permission was permanently denied. Please enable it in system Settings.'
      : 'Quyền vị trí đã bị từ chối vĩnh viễn. Vui lòng vào Settings hệ thống để bật lại.';
  String get openSettingsButton =>
      _isEn ? 'Open Settings' : 'Mở Cài đặt';
  String get tryAgainButton => _isEn ? 'Try again' : 'Thử lại';

  // ===== Saved cities =====
  String get savedCitiesTitle => _isEn ? 'Saved cities' : 'Thành phố đã lưu';
  String get noSavedCities =>
      _isEn ? 'No saved cities yet' : 'Chưa có thành phố nào được lưu';
  String get citySaved => _isEn ? 'City saved' : 'Đã lưu thành phố';
  String get cityRemoved => _isEn ? 'City removed' : 'Đã bỏ lưu thành phố';
}