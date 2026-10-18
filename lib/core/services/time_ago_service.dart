import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class TimeAgoService {
  static bool _timeagoArRegistered = false;

  /// Returns a human-readable 'time ago' string using the timeago package.
  static String timeAgoSinceDate(dynamic dateInput, {String? locale}) {
    // Register Arabic locale if needed
    if ((locale == 'ar' || (locale != null && locale.startsWith('ar'))) &&
        !_timeagoArRegistered) {
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      _timeagoArRegistered = true;
    }

    DateTime date;
    if (dateInput is String) {
      try {
        date = DateTime.parse(dateInput);
      } catch (_) {
        try {
          date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateInput);
        } catch (_) {
          return dateInput;
        }
      }
    } else if (dateInput is DateTime) {
      date = dateInput;
    } else {
      return '';
    }

    return timeago.format(date, locale: locale ?? 'en');
  }
}
