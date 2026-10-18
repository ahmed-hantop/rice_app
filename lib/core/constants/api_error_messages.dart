/// API error messages returned from the backend
/// These are the exact error messages that come from the API responses
class ApiErrorMessages {
  /// Error message when driver is not assigned to any lorry
  static const String driverNotAssignedToLorry =
      "Carrier does not have any lorry.";

  static const String driverNotAssignedToLorryArabic = "الناقل ليس لديه مركبة";

  /// Error message when account is under review
  static const String accountUnderReview =
      "Your account is under review. Please contact technical support.";
  static const String accountUnderReviewPendingEn =
      "Account is pending for approval. Please wait.";

  static const String accountUnderReviewArabic =
      "حسابك قيد المراجعة.  يرجى التواصل مع الدعم الفني";
  static const String accountUnderReviewArabicPending =
      "الحساب قيد المراجعة. يرجى الانتظار.";

  /// Error message when driver account is inactive
  static const String driverAccountNotActive = "Driver account is not active.";

  static const String driverAccountNotActiveArabic = "حساب السائق غير نشط.";

  static bool isAccountUnderReview(String? message) {
    if (message == null || message.trim().isEmpty) return false;
    final normalized = message.trim();
    return normalized == accountUnderReview ||
        normalized == accountUnderReviewPendingEn ||
        normalized == accountUnderReviewArabic ||
        normalized == accountUnderReviewArabicPending ||
        normalized.contains('قيد المراجعة') ||
        normalized.toLowerCase().contains('pending for approval');
  }

  static bool isDriverNotAssignedToLorry(String? message) {
    if (message == null || message.trim().isEmpty) return false;
    final normalized = message.trim();
    return normalized == driverNotAssignedToLorry ||
        normalized == driverNotAssignedToLorryArabic;
  }

  static bool isDriverAccountNotActive(String? message) {
    if (message == null || message.trim().isEmpty) return false;
    final normalized = message.trim();
    return normalized == driverAccountNotActive ||
        normalized == driverAccountNotActiveArabic;
  }
}
