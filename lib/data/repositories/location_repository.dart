import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../datasources/local/location_local_data_source.dart';
import '../models/location_model.dart';

abstract class LocationRepository {
  /// Lấy vị trí GPS hiện tại, trả về đã convert sang LocationModel
  /// (name sẽ để rỗng — reverse geocoding không nằm trong scope MVP,
  /// nếu cần tên thành phố từ GPS thì gọi thêm searchCity ở tầng Cubit).
  Future<Either<Failure, LocationModel>> getCurrentLocation();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, LocationModel>> getCurrentLocation() async {
    try {
      final position = await localDataSource.getCurrentPosition();
      return Right(LocationModel(
        name: '', // để trống, tầng trên tự điền qua reverse-geocode nếu cần
        lat: position.latitude,
        lon: position.longitude,
      ));
    } on LocationPermissionDeniedException {
      return const Left(LocationPermissionDenied());
    } on LocationPermissionDeniedForeverException {
      return const Left(LocationPermissionDeniedForever());
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }
}