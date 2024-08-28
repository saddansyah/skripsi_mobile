import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

abstract class GeolocationRepository {
  Future<void> serviceCheck();
  Future<Position> getCurrentPosition();
  Future<Position?> getLastKnownPosition();
  Stream<Position?> getPositionStream();
  Stream<ServiceStatus?> getServiceStatusStream();
  Stream<double?> getNavigationHeading();
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
  Stream<ServiceStatus> getServiceStatusStream() async* {
    try {
      final initialStatus = await Geolocator.isLocationServiceEnabled()
          ? ServiceStatus.enabled
          : ServiceStatus.disabled;
      yield initialStatus;

      final statusStream = Geolocator.getServiceStatusStream();

      await for (final status in statusStream) {
        yield status;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<Position> getPositionStream() {
    try {
      return Geolocator.getPositionStream();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> serviceCheck() async {
    bool serviceEnabled;
    LocationPermission permission;

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

  @override
  Stream<double?> getNavigationHeading() async* {
    try {
      final events = FlutterCompass.events;

      await for (final e in events!) {
        yield e.heading;
      }
    } catch (e) {
      throw 'Terjadi galat saat menggunakan navigasi';
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

final lastPositionProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getLastKnownPosition();
});

final currentPositionProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getCurrentPosition();
});
final streamPositionProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getPositionStream();
});

final locationServiceProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getServiceStatusStream();
});

final streamNavigationHeadingProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(geolocationRepositoryProvider).getNavigationHeading();
});
