import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../../utils/constants/api_constants.dart';

/// Wrapper quanh Dio — chỗ duy nhất trong app gọi Dio trực tiếp.
/// Các DataSource khác chỉ gọi qua class này, không tự new Dio() riêng.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options.connectTimeout =
    const Duration(seconds: ApiConstants.connectTimeoutSeconds);
    _dio.options.receiveTimeout =
    const Duration(seconds: ApiConstants.receiveTimeoutSeconds);
  }

  /// GET request chung, trả về Map<String, dynamic> đã parse JSON.
  /// Bắt lỗi Dio và quy về ServerException để tầng trên xử lý thống nhất.
  Future<Map<String, dynamic>> get(
      String url, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }

      throw ServerException('Server trả về mã lỗi ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException('Kết nối tới server quá thời gian chờ');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const ServerException('Không thể kết nối tới server');
      }
      throw ServerException(e.message ?? 'Lỗi không xác định từ Dio');
    }
  }
}