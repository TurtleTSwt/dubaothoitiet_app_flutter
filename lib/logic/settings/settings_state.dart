
import 'package:equatable/equatable.dart';

enum TempUnit { celsius, fahrenheit }
enum AppThemeMode { light, dark, system }
enum AppLanguage { vi, en }

/// Settings không cần chia Initial/Loading/Loaded rườm rà vì đọc từ
/// SharedPreferences gần như tức thời — chỉ cần 1 state duy nhất chứa data,
/// khởi tạo bằng giá trị mặc định.
class SettingsState extends Equatable {
  final TempUnit tempUnit;
  final AppThemeMode themeMode;
  final AppLanguage language;


  const SettingsState({
    this.tempUnit = TempUnit.celsius,
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.vi,
  });

  SettingsState copyWith({
    TempUnit? tempUnit,
    AppThemeMode? themeMode,
    AppLanguage? language,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,

    );
  }

  @override
  List<Object?> get props => [tempUnit, themeMode, language];
}