import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exceptions.dart';
import '../../../logic/settings/settings_state.dart';
import '../../../utils/constants/storage_keys.dart';

abstract class SettingsLocalDataSource {
  /// Đọc đơn vị nhiệt độ đã lưu. Trả về mặc định celsius nếu chưa từng lưu.
  TempUnit getTempUnit();

  /// Lưu đơn vị nhiệt độ mới.
  Future<void> setTempUnit(TempUnit unit);

  /// Đọc theme mode đã lưu. Trả về mặc định system nếu chưa từng lưu.
  AppThemeMode getThemeMode();

  /// Lưu theme mode mới.
  Future<void> setThemeMode(AppThemeMode mode);

  /// Lưu vị trí cuối cùng — để mở app lên hiển thị ngay, không phải chờ GPS.
  Future<void> saveLastLocation({
    required String name,
    required double lat,
    required double lon,
  });

  /// Đọc vị trí cuối cùng. Trả về null nếu chưa từng lưu (lần đầu mở app).
  ({String name, double lat, double lon})? getLastLocation();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences prefs;

  SettingsLocalDataSourceImpl(this.prefs);

  @override
  TempUnit getTempUnit() {
    final value = prefs.getString(StorageKeys.tempUnit);
    if (value == 'fahrenheit') return TempUnit.fahrenheit;
    return TempUnit.celsius; // mặc định
  }

  @override
  Future<void> setTempUnit(TempUnit unit) async {
    final value = unit == TempUnit.fahrenheit ? 'fahrenheit' : 'celsius';
    final success = await prefs.setString(StorageKeys.tempUnit, value);
    if (!success) {
      throw const CacheException('Không lưu được đơn vị nhiệt độ');
    }
  }

  @override
  AppThemeMode getThemeMode() {
    final value = prefs.getString(StorageKeys.themeMode);
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system; // mặc định
    }
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    final value = switch (mode) {
      AppThemeMode.light => 'light',
      AppThemeMode.dark => 'dark',
      AppThemeMode.system => 'system',
    };
    final success = await prefs.setString(StorageKeys.themeMode, value);
    if (!success) {
      throw const CacheException('Không lưu được chế độ giao diện');
    }
  }

  @override
  Future<void> saveLastLocation({
    required String name,
    required double lat,
    required double lon,
  }) async {
    final results = await Future.wait([
      prefs.setString(StorageKeys.lastLocationName, name),
      prefs.setDouble(StorageKeys.lastLat, lat),
      prefs.setDouble(StorageKeys.lastLon, lon),
    ]);

    if (results.any((success) => !success)) {
      throw const CacheException('Không lưu được vị trí cuối cùng');
    }
  }

  @override
  ({String name, double lat, double lon})? getLastLocation() {
    final name = prefs.getString(StorageKeys.lastLocationName);
    final lat = prefs.getDouble(StorageKeys.lastLat);
    final lon = prefs.getDouble(StorageKeys.lastLon);

    if (name == null || lat == null || lon == null) return null;

    return (name: name, lat: lat, lon: lon);
  }
}