import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit(this.settingsRepository)
      : super(SettingsState(
          tempUnit: settingsRepository.getTempUnit(),
          themeMode: settingsRepository.getThemeMode(),
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
}