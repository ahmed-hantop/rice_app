import 'package:flutter/foundation.dart';

/// Records errors without Firebase Crashlytics (rice_delivery build).
Future<void> errorLog(
  dynamic error,
  StackTrace stackTrace, {
  bool fatal = false,
}) async {
  if (kDebugMode) {
    debugPrint(
      '[errorLog] fatal=$fatal error=$error\n$stackTrace',
    );
  }
}
