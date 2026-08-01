
import 'package:equatable/equatable.dart';

import '../../data/models/location_model.dart';

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
  final List<LocationModel> savedCities;


  const SettingsState({
    this.tempUnit = TempUnit.celsius,
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.vi,
    this.savedCities = const [],
  });

  SettingsState copyWith({
    TempUnit? tempUnit,
    AppThemeMode? themeMode,
    AppLanguage? language,
    List<LocationModel>? savedCities,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      savedCities: savedCities ?? this.savedCities,
    );
  }

  @override
  List<Object?> get props => [tempUnit, themeMode, language, savedCities];
}