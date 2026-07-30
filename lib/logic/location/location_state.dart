
import 'package:equatable/equatable.dart';
import '../../data/models/location_model.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

/// Đang xin quyền hoặc đang lấy tọa độ GPS
class LocationLoading extends LocationState {
  const LocationLoading();
}

/// Lấy vị trí GPS thành công
class LocationLoaded extends LocationState {
  final LocationModel location;
  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

/// Người dùng từ chối quyền vị trí (có thể xin lại)
class LocationPermissionDenied extends LocationState {
  const LocationPermissionDenied();
}

/// Người dùng từ chối vĩnh viễn — phải hướng dẫn vào Settings hệ thống để bật
class LocationPermissionDeniedForever extends LocationState {
  const LocationPermissionDeniedForever();
}

/// Lỗi khác: GPS tắt, timeout, lỗi hệ thống...
class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Trạng thái riêng cho màn Search — danh sách kết quả tìm thành phố
/// Tách khỏi các state trên vì nó không liên quan tới GPS hiện tại
class LocationSearchLoading extends LocationState {
  const LocationSearchLoading();
}

class LocationSearchLoaded extends LocationState {
  final List<LocationModel> results;
  const LocationSearchLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class LocationSearchError extends LocationState {
  final String message;
  const LocationSearchError(this.message);

  @override
  List<Object?> get props => [message];
}