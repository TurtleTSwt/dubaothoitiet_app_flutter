import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../logic/settings/settings_state.dart';
import '../datasources/local/settings_local_data_source.dart';
import '../models/location_model.dart';

abstract class SettingsRepository {
  TempUnit getTempUnit();
  Future<Either<Failure, void>> setTempUnit(TempUnit unit);

  AppThemeMode getThemeMode();
  Future<Either<Failure, void>> setThemeMode(AppThemeMode mode);

  Future<Either<Failure, void>> saveLastLocation(LocationModel location);
  LocationModel? getLastLocation();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  TempUnit getTempUnit() => localDataSource.getTempUnit();

  @override
  Future<Either<Failure, void>> setTempUnit(TempUnit unit) async {
    try {
      await localDataSource.setTempUnit(unit);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  AppThemeMode getThemeMode() => localDataSource.getThemeMode();

  @override
  Future<Either<Failure, void>> setThemeMode(AppThemeMode mode) async {
    try {
      await localDataSource.setThemeMode(mode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveLastLocation(LocationModel location) async {
    try {
      await localDataSource.saveLastLocation(
        name: location.name,
        lat: location.lat,
        lon: location.lon,
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  LocationModel? getLastLocation() {
    final data = localDataSource.getLastLocation();
    if (data == null) return null;
    return LocationModel(name: data.name, lat: data.lat, lon: data.lon);
  }
}