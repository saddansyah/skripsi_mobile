import 'package:geolocator/geolocator.dart';

class Location {
  /// Distance in M
  static double getDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  static double getBearing(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.bearingBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  static String getFormattedDistance(double distance) {
    final distanceInM = distance;

    if (distanceInM > 1000000) {
      return '${(distanceInM / 1000000).toStringAsFixed(1)}k km';
    }

    if (distanceInM > 1000 && distanceInM < 1000000) {
      return '${(distanceInM / 1000).toStringAsFixed(2)} km';
    }

    return '${distanceInM.toStringAsFixed(2)} m';
  }
}
