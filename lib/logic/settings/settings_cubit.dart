import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/location_model.dart';
import '../../data/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit(this.settingsRepository)
      : super(SettingsState(
          tempUnit: settingsRepository.getTempUnit(),
          themeMode: settingsRepository.getThemeMode(),
          language: settingsRepository.getLanguage(),
          savedCities: settingsRepository.getSavedCities(),
        ));

  Future<void> changeTempUnit(TempUnit unit) async {
    // Cập nhật UI ngay (optimistic), không chờ ghi cache xong mới đổi
    emit(state.copyWith(tempUnit: unit));

    final result = await settingsRepository.setTempUnit(unit);
    result.fold(
      (failure) {
        // Ghi thất bại — rollback lại giá trị cũ để UI phản ánh đúng thực tế
        emit(state.copyWith(tempUnit: state.tempUnit));
      },
      (_) {},
    );
  }

  Future<void> changeThemeMode(AppThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));

    final result = await settingsRepository.setThemeMode(mode);
    result.fold(
      (failure) => emit(state.copyWith(themeMode: state.themeMode)),
      (_) {},
    );
  }

  Future<void> changeLanguage(AppLanguage language) async {
    emit(state.copyWith(language: language));

    final result = await settingsRepository.setLanguage(language);
    result.fold(
          (failure) => emit(state.copyWith(language: state.language)),
          (_) {},
    );
  }

  /// Kiểm tra 1 thành phố đã được lưu chưa (so sánh theo tên + toạ độ)
  bool isCitySaved(LocationModel location) {
    return state.savedCities.any(
          (c) => c.name == location.name && c.lat == location.lat && c.lon == location.lon,
    );
  }

  /// Bấm nút lưu nếu chưa có, bỏ lưu nếu đã có
  Future<void> toggleSavedCity(LocationModel location) async {
    final isSaved = isCitySaved(location);

    final newList = isSaved
        ? state.savedCities
        .where((c) => !(c.name == location.name && c.lat == location.lat && c.lon == location.lon))
        .toList()
        : [...state.savedCities, location];

    emit(state.copyWith(savedCities: newList));

    final result = await settingsRepository.saveCities(newList);
    result.fold(
          (failure) => emit(state.copyWith(savedCities: state.savedCities)), // rollback nếu lỗi
          (_) {},
    );
  }
}