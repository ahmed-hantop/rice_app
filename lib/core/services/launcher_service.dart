// lib/core/services/launcher_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens phone, SMS and maps apps. Returns false if nothing could handle it.
class LauncherService {
  String _clean(String phone) => phone.replaceAll(RegExp(r'[^0-9+]'), '');

  Future<bool> call(String phone) =>
      _open(Uri(scheme: 'tel', path: _clean(phone)));

  Future<bool> sms(String phone, {String body = ''}) => _open(Uri(
        scheme: 'sms',
        path: _clean(phone),
        queryParameters: body.isEmpty ? null : {'body': body},
      ));

  Future<bool> navigate(double lat, double lng) => _open(
        Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
        external: true,
      );

  Future<bool> navigateToAddress(String address) => _open(
        Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(address)}'),
        external: true,
      );

  Future<bool> _open(Uri uri, {bool external = false}) async {
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(
      uri,
      mode: external ? LaunchMode.externalApplication : LaunchMode.platformDefault,
    );
  }
}

final launcherServiceProvider = Provider<LauncherService>((_) => LauncherService());