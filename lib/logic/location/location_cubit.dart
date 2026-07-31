// lib/logic/location/location_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart' as failures;
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/weather_repository.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository locationRepository;
  final WeatherRepository weatherRepository;

  LocationCubit({
    required this.locationRepository,
    required this.weatherRepository,
  }) : super(const LocationInitial());

  Future<void> getCurrentLocation() async {
    emit(const LocationLoading());

    final result = await locationRepository.getCurrentLocation();

    result.fold(
          (failure) {
        if (failure is failures.LocationPermissionDenied) {
          emit(const LocationPermissionDenied());
        } else if (failure is failures.LocationPermissionDeniedForever) {
          emit(const LocationPermissionDeniedForever());
        } else {
          emit(LocationError(failure.message));
        }
      },
          (location) => emit(LocationLoaded(location)),
    );
  }

  Future<void> searchCity(String query) async {
    if (query.trim().isEmpty) {
      emit(const LocationSearchLoaded([]));
      return;
    }

    emit(const LocationSearchLoading());

    final result = await weatherRepository.searchCity(query);

    result.fold(
          (failure) => emit(LocationSearchError(failure.message)),
          (results) => emit(LocationSearchLoaded(results)),
    );
  }
}