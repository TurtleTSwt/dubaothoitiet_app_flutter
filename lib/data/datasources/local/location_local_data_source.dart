// lib/data/datasources/local/location_local_data_source.dart

import 'package:geolocator/geolocator.dart';

import '../../../core/errors/exceptions.dart';

abstract class LocationLocalDataSource {
  Future<Position> getCurrentPosition();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('Vui lòng bật dịch vụ định vị (GPS) của thiết bị');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedForeverException();
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw LocationException('Không lấy được vị trí: ${e.toString()}');
    }
  }
}