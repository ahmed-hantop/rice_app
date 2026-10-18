class AuthConstants {
  AuthConstants._();

  // OTP
  static const int otpLength = 4;
  static const int otpTimerSeconds = 60;

  // Phone
  static const String countryCode = '966';
  static const int phoneMaxLength = 10;
  static const int nationalIdLength = 10;

  // Registration
  static const int minimumAge = 18;
  static const int licenseExpiryOffsetDays = 30;
  static const int maxDocExpiryYears = 10;
  static const int defaultDocExpiryDays = 365;

  // Flow source identifiers
  static const String sourceLogin = 'login';
  static const String sourceRegister = 'register';

  // User types (API values)
  static const String userTypeCarrier = 'carrier';
  static const String userTypeDriver = 'driver';

  // Snackbar durations
  static const Duration snackBarShort = Duration(seconds: 1);
  static const Duration snackBarLong = Duration(seconds: 5);
}
