import 'package:easy_localization/easy_localization.dart';
import 'package:rice_delivery/core/localization/app_strings.dart';

class AvailabilityDateUtils {
  static const maxRangeDays = 90;
  static const defaultRangeDays = 30;

  /// Matches backend OpenSessionRequestSettings defaults.
  static const broadcastMinimumLeadHours = 3;
  static const targetedMinimumLeadHours = 2;

  /// Last catalog slot start hour (TimeSlotsSeeder: 08:00 through 22:00).
  static const lastSlotStartHour = 22;

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime today() => dateOnly(DateTime.now());

  static int leadHoursFor({required bool isTargeted}) =>
      isTargeted ? targetedMinimumLeadHours : broadcastMinimumLeadHours;

  /// Earliest selectable calendar day for session date pickers.
  ///
  /// Returns the first day that can still hold a bookable slot under the
  /// minimum lead window (not merely "today"). When `now + leadHours` falls
  /// after the last catalog slot start on that day, rolls to the next day.
  static DateTime earliestAllowedSessionDate({bool isTargeted = false}) {
    final leadHours = leadHoursFor(isTargeted: isTargeted);
    final earliestInstant = DateTime.now().add(Duration(hours: leadHours));
    final day = dateOnly(earliestInstant);
    if (earliestInstant.hour > lastSlotStartHour ||
        (earliestInstant.hour == lastSlotStartHour &&
            earliestInstant.minute > 0)) {
      return day.add(const Duration(days: 1));
    }
    return day;
  }

  static bool isSameDay(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);

  /// True when [startTime] (`HH:mm`) on [onDate] is strictly before now.
  static bool isSlotStartTimeInPast(String startTime, {DateTime? onDate}) {
    final parts = startTime.split(':');
    if (parts.length < 2) return false;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return false;
    final date = dateOnly(onDate ?? DateTime.now());
    final slotStart = DateTime(date.year, date.month, date.day, h, m);
    return slotStart.isBefore(DateTime.now());
  }

  /// True when the slot start is inside the minimum lead window.
  static bool isSlotInsideLeadWindow(
    String startTime, {
    required DateTime sessionDate,
    required bool isTargeted,
  }) {
    final parts = startTime.split(':');
    if (parts.length < 2) return false;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return false;
    final date = dateOnly(sessionDate);
    final slotStart = DateTime(date.year, date.month, date.day, h, m);
    final leadHours = leadHoursFor(isTargeted: isTargeted);
    final earliest = DateTime.now().add(Duration(hours: leadHours));
    return slotStart.isBefore(earliest);
  }

  /// Catalog slots are bookable only when a session date is set and the start
  /// is neither in the past nor inside the lead window.
  static bool isCatalogTimeSlotAvailable({
    required String startTime,
    required DateTime? sessionDate,
    bool isTargeted = false,
  }) {
    if (sessionDate == null) return false;
    if (isSlotStartTimeInPast(startTime, onDate: sessionDate)) return false;
    if (isSlotInsideLeadWindow(
      startTime,
      sessionDate: sessionDate,
      isTargeted: isTargeted,
    )) {
      return false;
    }
    return true;
  }

  /// rice_delivery day-of-week id: Sunday=1 … Saturday=7 (not Dart's Monday=1).
  static int dayOfWeekIdFor(DateTime d) =>
      d.weekday == DateTime.sunday ? 1 : d.weekday + 1;

  /// e.g. "Sunday 12/10/2026".
  static String formatWeekdayDateLabel(DateTime d) {
    final weekday = dayLabelForId(dayOfWeekIdFor(d));
    final date = formatDisplayDate(d);
    if (weekday.isEmpty) return date;
    return '$weekday $date';
  }

  /// Parses `HH:mm` into hour/minute, or null when invalid.
  static (int, int)? parseHourMinute(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return (h, m);
  }

  /// e.g. "5:00 PM to 6:00 PM" from slot start + duration minutes.
  static String formatTimeRangeLabel(
    String startTime, {
    required int durationMinutes,
    String? locale,
  }) {
    final parsed = parseHourMinute(startTime);
    if (parsed == null) return startTime;
    final start = DateTime(2000, 1, 1, parsed.$1, parsed.$2);
    final end = start.add(Duration(minutes: durationMinutes));
    final startLabel = DateFormat.jm(locale).format(start);
    final endLabel = DateFormat.jm(locale).format(end);
    return AppStrings.osrWizardTimeRange.tr(
      namedArgs: {'start': startLabel, 'end': endLabel},
    );
  }

  /// Accordion / review schedule label with partial states.
  ///
  /// - no date → empty (caller shows placeholder)
  /// - date only → "Sunday 12/10/2026 · Pick a time"
  /// - complete → "Sunday 12/10/2026 · 5:00 PM to 6:00 PM"
  static String sessionScheduleLabel({
    required DateTime? preferredDate,
    required String? timeSlotStart,
    required int durationMinutes,
    String? locale,
  }) {
    if (preferredDate == null) return '';
    final datePart = formatWeekdayDateLabel(preferredDate);
    if (timeSlotStart == null || timeSlotStart.isEmpty) {
      return AppStrings.osrWizardScheduleDateOnly.tr(
        namedArgs: {'date': datePart},
      );
    }
    final range = formatTimeRangeLabel(
      timeSlotStart,
      durationMinutes: durationMinutes,
      locale: locale,
    );
    return '$datePart · $range';
  }

  static DateTime defaultEndDate(DateTime start) =>
      start.add(const Duration(days: defaultRangeDays));

  static String toApiDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static String formatDisplayDate(DateTime d) =>
      DateFormat('dd/MM/yyyy').format(d);

  /// Gregorian display for chip subtitles (same as range boxes).
  static String formatChipDateLabel(DateTime d) => formatDisplayDate(d);

  /// Locale-aware 12-hour time for chip labels (e.g. "5:30 PM", "٥:٣٠ م").
  static String formatChipTimeLabel(String time, {String? locale}) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return time;
    return DateFormat.jm(locale).format(DateTime(2000, 1, 1, h, m));
  }

  static String? validateRange(DateTime start, DateTime end) {
    final s = dateOnly(start);
    final e = dateOnly(end);
    final t = today();
    if (s.isBefore(t)) {
      return AppStrings.availabilityStartPast.tr();
    }
    if (e.isBefore(s)) {
      return AppStrings.availabilityEndBeforeStart.tr();
    }
    if (e.difference(s).inDays > maxRangeDays) {
      return AppStrings.availabilityRangeTooLong.tr();
    }
    return null;
  }

  static DateTime clampEndDate(DateTime start, DateTime end) {
    final maxEnd = start.add(const Duration(days: maxRangeDays));
    final e = dateOnly(end);
    if (e.isAfter(maxEnd)) return maxEnd;
    if (e.isBefore(start)) return defaultEndDate(start);
    return e;
  }

  static String dayLabelForId(int dayOfWeekId) {
    return switch (dayOfWeekId) {
      7 => AppStrings.weekDaySaturday.tr(),
      1 => AppStrings.weekDaySunday.tr(),
      2 => AppStrings.weekDayMonday.tr(),
      3 => AppStrings.weekDayTuesday.tr(),
      4 => AppStrings.weekDayWednesday.tr(),
      5 => AppStrings.weekDayThursday.tr(),
      6 => AppStrings.weekDayFriday.tr(),
      _ => '',
    };
  }
}
