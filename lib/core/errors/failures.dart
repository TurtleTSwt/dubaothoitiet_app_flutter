
import 'package:equatable/equatable.dart';

/// Failure ở tầng domain/logic — Repository luôn trả về
/// Either<Failure, T> chứ KHÔNG bao giờ throw Exception ra ngoài.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi từ server']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Lỗi đọc dữ liệu cục bộ']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Không có kết nối mạng']);
}

class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Không lấy được vị trí']);
}

class LocationPermissionDenied extends Failure {
  const LocationPermissionDenied([super.message = 'Bạn chưa cấp quyền vị trí']);
}

class LocationPermissionDeniedForever extends Failure {
  const LocationPermissionDeniedForever(
      [super.message = 'Quyền vị trí đã bị từ chối vĩnh viễn, vào Settings để bật']);
}