import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/location_model.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  final SettingsRepository settingsRepository;

  WeatherCubit({
    required this.weatherRepository,
    required this.settingsRepository,
  }) : super(const WeatherInitial());

  /// Gọi khi vào Home lần đầu, hoặc khi đổi sang 1 vị trí mới (từ Search).
  /// [isRefresh] = true khi dùng cho pull-to-refresh — giữ data cũ hiển thị
  /// trong lúc chờ, thay vì hiện full loading.
  Future<void> fetchWeather(LocationModel location, {bool isRefresh = false}) async {
    if (isRefresh && state is WeatherLoaded) {
      emit(WeatherRefreshing((state as WeatherLoaded).weather));
    } else {
      emit(const WeatherLoading());
    }

    final result = await weatherRepository.getWeather(location);

    result.fold(
          (failure) {
        // Nếu đang refresh và đã có data cũ, giữ lại để UI hiện data cũ + báo lỗi
        final previousData = state is WeatherRefreshing
            ? (state as WeatherRefreshing).currentData
            : null;
        emit(WeatherError(failure.message, previousData: previousData));
      },
          (weather) {
        emit(WeatherLoaded(weather));
        // Lưu lại vị trí thành công gần nhất, để lần sau mở app hiện ngay
        settingsRepository.saveLastLocation(location);
      },
    );
  }

  /// Gọi khi kéo pull-to-refresh trên Home — dùng lại vị trí đang hiển thị
  Future<void> refresh() async {
    final currentLocation = _getCurrentLocation();
    if (currentLocation == null) return;
    await fetchWeather(currentLocation, isRefresh: true);
  }

  LocationModel? _getCurrentLocation() {
    if (state is WeatherLoaded) return (state as WeatherLoaded).weather.location;
    if (state is WeatherRefreshing) return (state as WeatherRefreshing).currentData.location;
    if (state is WeatherError) return (state as WeatherError).previousData?.location;
    return null;
  }
}