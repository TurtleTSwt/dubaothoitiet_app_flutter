
import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface để Repository check mạng trước khi gọi API.
/// Tách interface riêng để sau này dễ mock trong unit test.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // connectivity_plus >=6.0 trả về List<ConnectivityResult>
    return result.isNotEmpty &&
        !result.contains(ConnectivityResult.none);
  }
}