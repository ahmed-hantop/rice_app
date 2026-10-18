import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}

class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

// Provider for SecureStorage
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl(ref.read(sharedPreferencesProvider));
});
