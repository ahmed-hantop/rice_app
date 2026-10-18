

/// Central place to map auth-related errors into UI-friendly behaviors/messages.
class AuthErrorMapper {
  AuthErrorMapper._();

  /// Server error codes / API envelope [statusCode] values for active OTP.
  static const Set<String> otpAlreadySentCodes = {
    'OTP_ALREADY_SENT',
    'OTP_ALREADY_SENT_VALID',
    'OTP_RATE_LIMIT',
    'TooManyRequests',
    'TOO_MANY_REQUESTS',
  };

  /// Fallback matching when backend doesn't provide stable codes.
  static final RegExp _otpAlreadySentPattern = RegExp(
    r'(otp).*?(already).*?(sent)|already\s+been\s+sent|valid\s+otp\s+code\s+has\s+already|wait\s+before\s+requesting',
    caseSensitive: false,
  );

  

  /// New phone on login tab — API requires email for registration (400 BadRequest).
  static final RegExp _invalidEmailPattern = RegExp(
    r"email\s+''\s+is\s+invalid|email\s+is\s+invalid|invalid\s+email",
    caseSensitive: false,
  );

  static final RegExp _invalidOtpPattern = RegExp(
    r'invalid\s+otp|otp\s+.*invalid|wrong\s+otp|incorrect\s+otp|otp\s+expired|otp\s+code\s+is\s+invalid',
    caseSensitive: false,
  );

  static bool isInvalidEmailError(String? message) {
    if (message == null || message.isEmpty) return false;
    return _invalidEmailPattern.hasMatch(message);
  }

  static bool isInvalidOtpCode(String? message) {
    if (message == null || message.isEmpty) return false;
    if (isInvalidEmailError(message)) return false;
    return _invalidOtpPattern.hasMatch(message);
  }

  /// User-facing copy for OTP sheet inline errors.
  static String messageForOtpSheet(String? serverMessage) {
    if (serverMessage == null || serverMessage.isEmpty) {
      return '';
    }
    if (isInvalidEmailError(serverMessage)) {
      return 'auth_verify_email_invalid';
    }
    if (isEmailRequiredForRegistrationMessage(serverMessage)) {
      return 'auth_phone_requires_register';
    }
    return serverMessage;
  }

  static bool isEmailRequiredForRegistrationMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('email is required for registration') ||
        (lower.contains('email') &&
            lower.contains('registration') &&
            lower.contains('required'));
  
  }
}
