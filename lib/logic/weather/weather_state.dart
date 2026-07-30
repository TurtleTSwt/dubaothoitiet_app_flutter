
import 'package:equatable/equatable.dart';
import '../../data/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu, chưa gọi API lần nào
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// Đang gọi API lấy thời tiết (lần đầu — full screen loading/skeleton)
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

/// Đang refresh lại dữ liệu (pull-to-refresh) nhưng vẫn giữ data cũ hiển thị
/// UI dùng field này để show loading indicator nhỏ, không che toàn màn hình
class WeatherRefreshing extends WeatherState {
  final WeatherModel currentData;
  const WeatherRefreshing(this.currentData);

  @override
  List<Object?> get props => [currentData];
}

/// Lấy dữ liệu thành công — đây là state chính UI sẽ render
class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  const WeatherLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

/// Lỗi — có message để hiển thị lên ErrorView
/// Nếu đã có data cũ, giữ lại để UI có thể chọn hiển thị data cũ + banner lỗi
class WeatherError extends WeatherState {
  final String message;
  final WeatherModel? previousData;

  const WeatherError(this.message, {this.previousData});

  @override
  List<Object?> get props => [message, previousData];
}