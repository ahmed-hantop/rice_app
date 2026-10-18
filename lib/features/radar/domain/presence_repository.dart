// features/radar/domain/presence_repository.dart
abstract class PresenceRepository {
  Future<void> setOnline(String driverId, bool online);
}