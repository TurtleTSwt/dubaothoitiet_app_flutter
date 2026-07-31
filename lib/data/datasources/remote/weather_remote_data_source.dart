
import '../../models/location_model.dart';
import '../../models/weather_model.dart';
import '../../../utils/constants/api_constants.dart';
import 'api_client.dart';

/// Interface — Repository chỉ phụ thuộc vào interface này,
/// không phụ thuộc trực tiếp vào ApiClient/Dio.
abstract class WeatherRemoteDataSource {
  /// Lấy thời tiết hiện tại + hourly + daily cho 1 tọa độ.
  /// [location] cần có sẵn name/lat/lon (lấy từ GPS hoặc từ kết quả search).
  Future<WeatherModel> getWeather(LocationModel location);

  /// Tìm kiếm thành phố theo tên, trả về danh sách địa điểm khớp.
  Future<List<LocationModel>> searchCity(String query);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient apiClient;

  WeatherRemoteDataSourceImpl(this.apiClient);

  @override
  Future<WeatherModel> getWeather(LocationModel location) async {
    final json = await apiClient.get(
      ApiConstants.baseUrl,
      queryParameters: {
        'latitude': location.lat,
        'longitude': location.lon,
        'current': ApiConstants.currentParams,
        'hourly': ApiConstants.hourlyParams,
        'daily': ApiConstants.dailyParams,
        'timezone': ApiConstants.timezone,
        'forecast_days': ApiConstants.forecastDays,
      },
    );

    return WeatherModel.fromJson(json, location);
  }

  @override
  Future<List<LocationModel>> searchCity(String query) async {
    final json = await apiClient.get(
      ApiConstants.geocodingBaseUrl,
      queryParameters: {
        'name': query,
        'count': 8,
        'language': 'vi',
        'format': 'json',
      },
    );

    final results = json['results'] as List<dynamic>?;
    if (results == null) return [];

    return results
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}