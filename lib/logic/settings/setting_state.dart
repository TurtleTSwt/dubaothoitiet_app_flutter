
import 'package:equatable/equatable.dart';

enum TempUnit { celsius, fahrenheit }
enum AppThemeMode { light, dark, system }

/// Settings không cần chia Initial/Loading/Loaded rườm rà vì đọc từ
/// SharedPreferences gần như tức thời — chỉ cần 1 state duy nhất chứa data,
/// khởi tạo bằng giá trị mặc định.
class SettingsState extends Equatable {
  final TempUnit tempUnit;
  final AppThemeMode themeMode;

  const SettingsState({
    this.tempUnit = TempUnit.celsius,
    this.themeMode = AppThemeMode.system,
  });

  SettingsState copyWith({
    TempUnit? tempUnit,
    AppThemeMode? themeMode,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [tempUnit, themeMode];
}