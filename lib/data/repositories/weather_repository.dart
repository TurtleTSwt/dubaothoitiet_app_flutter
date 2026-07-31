import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/remote/weather_remote_data_source.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';

abstract class WeatherRepository {
  /// Lấy thời tiết hiện tại + hourly + daily cho 1 vị trí.
  Future<Either<Failure, WeatherModel>> getWeather(LocationModel location);

  /// Tìm kiếm thành phố theo tên.
  Future<Either<Failure, List<LocationModel>>> searchCity(String query);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherModel>> getWeather(LocationModel location) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final weather = await remoteDataSource.getWeather(location);
      return Right(weather);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LocationModel>>> searchCity(String query) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final results = await remoteDataSource.searchCity(query);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }
}