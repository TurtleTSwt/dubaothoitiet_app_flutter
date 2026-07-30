
/// Ném ra ở tầng datasource (remote/local) khi có lỗi kỹ thuật.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Lỗi từ server']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Lỗi đọc/ghi cache']);
}

class LocationException implements Exception {
  final String message;
  const LocationException([this.message = 'Lỗi lấy vị trí']);
}

class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException();
}

class LocationPermissionDeniedForeverException implements Exception {
  const LocationPermissionDeniedForeverException();
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Không có kết nối mạng']);
}