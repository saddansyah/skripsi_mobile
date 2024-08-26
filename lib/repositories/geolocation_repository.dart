import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skripsi_mobile/repositories/collect_repository.dart';

abstract class GeolocationRepository {
  Future<void> serviceCheck();
  Future<Position> getCurrentPosition();
  Future<Position?> getLastKnownPosition();
  Stream<Position?> getPositionStream();
}

class GeolocationImplRepository implements GeolocationRepository {
  final LocationSettings settings;

  GeolocationImplRepository({required this.settings});

  @override
  Future<Position> getCurrentPosition() async {
    try {
      serviceCheck();
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Position?> getLastKnownPosition() async {
    try {
      serviceCheck();
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<Position> getPositionStream() {
    try {
      serviceCheck();
      return Geolocator.getPositionStream();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> serviceCheck() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}

final geolocationRepositoryProvider =
    Provider.autoDispose<GeolocationRepository>((ref) {
  return GeolocationImplRepository(
    settings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    ),
  );
});

final streamPositionProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getPositionStream();
});

final lastPositionProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getLastKnownPosition();
});

final currentPositionProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getCurrentPosition();
});
