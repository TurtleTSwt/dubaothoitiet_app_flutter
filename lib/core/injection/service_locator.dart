// lib/core/injection/service_locator.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/location_local_data_source.dart';
import '../../data/datasources/local/settings_local_data_source.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/datasources/remote/weather_remote_data_source.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/weather_repository.dart';
import '../../logic/location/location_cubit.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../logic/weather/weather_cubit.dart';
import '../network/network_info.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ===== External =====
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ===== Core =====
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ===== Data sources =====
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  sl.registerLazySingleton<WeatherRemoteDataSource>(
        () => WeatherRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<LocationLocalDataSource>(
        () => LocationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<SettingsLocalDataSource>(
        () => SettingsLocalDataSourceImpl(sl()),
  );

  // ===== Repositories =====
  sl.registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(sl()),
  );

  // ===== Cubits =====
  // registerFactory: mỗi lần gọi sl<XCubit>() sẽ tạo instance MỚI,
  // tránh giữ state cũ khi quay lại màn hình.
  sl.registerFactory<WeatherCubit>(
        () => WeatherCubit(
      weatherRepository: sl(),
      settingsRepository: sl(),
    ),
  );

  sl.registerFactory<LocationCubit>(
        () => LocationCubit(
      locationRepository: sl(),
      weatherRepository: sl(),
    ),
  );

  sl.registerFactory<SettingsCubit>(
        () => SettingsCubit(sl()),
  );
}