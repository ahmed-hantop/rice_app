import 'dart:convert';

import 'package:rice_delivery/models/auth/auth_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthConfigStorage {
  static const _cacheKey = 'auth_config_cache';
  static const _fetchedAtKey = 'auth_config_fetched_at';
  static const cacheTtl = Duration(minutes: 5);

  Future<AuthConfigData?> readIfFresh() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_cacheKey);
    final fetchedAtMs = prefs.getInt(_fetchedAtKey);
    if (jsonStr == null || fetchedAtMs == null) return null;

    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(fetchedAtMs),
    );
    if (age > cacheTtl) return null;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AuthConfigData.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(AuthConfigData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(data.toJson()));
    await prefs.setInt(
      _fetchedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_fetchedAtKey);
  }
}
