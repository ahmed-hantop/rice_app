// core/services/location_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class Coordinates {
  const Coordinates(this.lat, this.lng);
  final double lat, lng;

  /// 24.7136° N, 46.6753° E
  String get label =>
      '${lat.abs().toStringAsFixed(4)}° ${lat >= 0 ? 'N' : 'S'}, '
      '${lng.abs().toStringAsFixed(4)}° ${lng >= 0 ? 'E' : 'W'}';
}

class LocationService {
  /// Current position, or null if services are off, permission is denied, or it times out.
  Future<Coordinates?> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }

      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return Coordinates(p.latitude, p.longitude);
    } catch (_) {
      return null;
    }
  }
}

final locationServiceProvider = Provider<LocationService>((_) => LocationService());