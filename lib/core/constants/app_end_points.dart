/// Legacy / non-student endpoint catalog (localization, contact, leftover
/// driver URLs). **rice_delivery student feature repos must use [ApiEndpoints]** in
/// `api_endpoints.dart`.
class ApiEndPoints {
  static String _appDomain = 'https://ozcco.khuzam.io';
  static String get appDomain => _appDomain;
  static set setAppDomain(String value) {
    _appDomain =
        value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }
  static String commonPagesUrl = '$appDomain/api/common/pages';
  static String commonPageBySlugUrl(String slug) =>
      '$appDomain/api/common/pages/by-slug?slug=$slug';
  static const String _auth = '/api/v1/auth';
  static const String _project = '/api/v1/project';
  static const String _products = '/api/v1/products';
  static const String _carrier = '/api/carrier';
  static const String _driver = '/api/driver';
  static String authUrl = '$_appDomain$_auth/login';
  static String settingsUrl = '$_appDomain/api/common/settings';
  static String contactUsUrl = '$_appDomain/api/customer/store';
  static String driverLoginUrl = '$_appDomain/api/driver/login';
  static String carrierLoginUrl = '$_appDomain/api/carrier/login';
  static String unifiedLoginUrl = '$_appDomain/api/auth/unified-login';
  static String projectUrl = '$_appDomain$_project';
  static String cargoUrlDriver = '$_appDomain$_driver/cargos';
  static String driverTrackingCargosUrl = '$_appDomain$_driver/cargos/tracking';
  static String driverCargoStatusesUrl =
      '$_appDomain/api/common/driver/cargo-statuses';
  static String cargoUrlCarrier = '$_appDomain$_carrier/cargos';
  static String availableCargoUrl = '$_appDomain$_carrier/cargos/available';
  static String biddingsCargoUrl =
      '$_appDomain$_carrier/carrier-cargos/Bidding';
  static String updateCargoUrl = '$_appDomain$_driver/cargo';

  static String productsUrl = '$_appDomain$_products';
  static String carrierUrl = '$_appDomain$_carrier';
  static String driverUrl = '$_appDomain$_driver';
  static final String addOfferUrl = '$carrierUrl/bids';
  static final String myBidsUrl = '$carrierUrl/bids';
  static final String bidsFilterOptionsUrl = '$carrierUrl/bids/filter-options';

  /// Authentication endpoints
  static final String signIn = '$driverUrl/login';
  static final String register = '$carrierUrl/register';
  static final String completeRegistration =
      '$carrierUrl/complete-registration';
  static final String driverVerifyOtpUrl = '$appDomain/api/driver/verifyOtp';
  static final String carrierVerifyOtpUrl = '$appDomain/api/carrier/verifyOtp';
  static final String registerVerifyOtpUrl = '$appDomain/api/carrier/verifyOtp';
  static final String driverLogoutUrl = '$driverUrl/logout';
  static final String carrierLogoutUrl = '$carrierUrl/logout';
  static final String setAvailabilityUrl = '$carrierUrl/set-availability';
  static final String deleteAccountUrl = '$carrierUrl/deleteProfile';
  static final String switchToDriverUrl = '$carrierUrl/switch-to-driver';
  static final String switchToCarrierUrl = '$carrierUrl/switch-to-carrier';
  static final String getCarrierProfileUrl = '$carrierUrl/profile';
  static final String updateCarrierProfileUrl = '$carrierUrl/profile';
  static final String getDriverProfileUrl = '$driverUrl/profile';
  static final String updateDriverProfileUrl = '$driverUrl/profile';
  static final String changePasswordUrl = '$carrierUrl/change-password';
  static final String forgotPasswordSendOtpUrl =
      '$_appDomain/api/forgot-password/send-otp';
  static final String forgotPasswordVerifyOtpUrl =
      '$_appDomain/api/forgot-password/verify-otp';
  static final String forgotPasswordResetPasswordUrl =
      '$_appDomain/api/forgot-password/reset-password';

  /// Bank account endpoints
  static final String financialAccountUrl = '$carrierUrl/financial-account';

  /// Revenue endpoints
  static final String revenueUrl = '$carrierUrl/payouts/revenue';

  /// Transactions endpoints
  static final String transactionsUrl = '$carrierUrl/payouts/transactions';

  /// Store settings endpoints
  static const String storeSettingsUrl = '/store/settings';

  /// Cargo endpoints
  static String updateShipmentLocationUrl = '$updateCargoUrl/update-location';
  static String updateShipmentStageUrl = '$updateCargoUrl/updateStage';
  static String resendOtpUrl = '$updateCargoUrl/resend';
  static String resendDeliveryOtpUrl = '$updateCargoUrl/resendCode';

  /// Cancel cargo endpoints (carrier only)
  static String cancelPenaltyUrl(int id) =>
      '$_appDomain$_carrier/cargo/cancel-penalty/$id';
  static String cancelCargoUrl(int id) =>
      '$_appDomain$_carrier/cargo/$id/cancel';

  // Payments endpoints
  static const String paymentsHistoryUrl = '/payments/history';

  /// Offers endpoints
  static const String cancelOffer = '/cancel';
  static const String confirmOffer = '/offers/confirm';

  /// Lorry endpoints
  static final String lorriesUrl = '$carrierUrl/lorries';
  static final String availableLorriesUrl = '$carrierUrl/available-lorries';
  static final String validateLorryUrl = '$carrierUrl/lorries/check-wasl';

  /// Per-field edit-request endpoint for a lorry. Returns the open ER
  /// (if any) with per-field staged state. See
  /// `docs/public/EDIT_REQUEST_PER_FIELD_FRONTEND_GUIDE.md` § 7.1.
  static String lorryPendingEditUrl(int lorryId) =>
      '$lorriesUrl/$lorryId/pending-edit';

  /// Per-field edit-request endpoint for the carrier's driver. Returns
  /// the open ER (if any) with per-field staged state. See
  /// `docs/public/EDIT_REQUEST_PER_FIELD_FRONTEND_GUIDE.md` § 7.1.
  /// Field updates themselves go through the existing carrier profile
  /// update endpoint (`POST /profile`).
  static String driverPendingEditUrl(int driverId) =>
      '$getDriversUrl/$driverId/pending-edit';
  static final String vehicleCategoriesUrl = '$appDomain/api/common/categories';
  static final String vehicleSubCategoriesUrl =
      '$appDomain/api/common/categories';
  static final String getDriversUrl = '$carrierUrl/drivers';

  /// Shipping types endpoint
  static final String shippingTypesUrl = '$appDomain/api/common/shipping_types';
  static final String itemUnitsUrl = '$appDomain/api/common/itemUnits';
  static final String categoriesFilterUrl =
      '$appDomain/api/common/categories/filter';

  /// Areas endpoints
  static final String areasUrl = '$appDomain/api/common/areas';
  static final String governoratesUrl = '$appDomain/api/common/governorates';
  static final String banksUrl = '$appDomain/api/common/banks';

  /// Dashboard endpoints
  static final String dashboardStatisticsUrl = '$carrierUrl/dashboard';

  /// Wallet endpoints
  static final String walletBalanceUrl = '$carrierUrl/wallet/balance';
  static final String walletTransactionsUrl = '$carrierUrl/wallet-transactions';
  static final String walletWithdrawUrl = '$carrierUrl/wallet/withdraw';
  static final String withdrawalsUrl = '$carrierUrl/withdrawals';
  static String withdrawalDetailsUrl(int id) => '$carrierUrl/withdrawals/$id';

  /// Notifications endpoints
  static String notificationsUrl(bool isCarrier) =>
      isCarrier ? '$carrierUrl/notifications' : '$driverUrl/notifications';
  static String markNotificationAsReadUrl(int notificationId, bool isCarrier) =>
      isCarrier
          ? '$carrierUrl/notifications/markAsRead/$notificationId'
          : '$driverUrl/notifications/markAsRead/$notificationId';
  static String markAllNotificationsAsReadUrl(
    bool isCarrier, {
    String? category,
  }) {
    final base =
        isCarrier
            ? '$carrierUrl/notifications/markAllAsRead'
            : '$driverUrl/notifications/markAllAsRead';
    if (category == null || category.isEmpty) return base;
    return '$base?category=${Uri.encodeQueryComponent(category)}';
  }

  static String notificationsUnreadByCategoryUrl(bool isCarrier) =>
      isCarrier
          ? '$carrierUrl/notifications/unreadByCategory'
          : '$driverUrl/notifications/unreadByCategory';

  /// Tickets endpoints
  static final String ticketsUrl = '$carrierUrl/tickets';
  static String ticketDetailsUrl(int ticketId) => '$ticketsUrl/$ticketId';
  static String ticketReplyUrl(int ticketId) => '$ticketsUrl/$ticketId/reply';
  static String ticketCloseUrl(int ticketId) => '$ticketsUrl/$ticketId/close';

  /// Rating endpoints
  static final String ratingsUrl = '$appDomain/api/common/ratings';
  static String get languagesUrl => '$appDomain/api/languages';
  static String get checkUpdatesUrl => '$appDomain/api/check-updates';
  static String get languageKeysUrl => '$appDomain/api/languages/keys';

  /// Cargo refusal endpoint (legacy — carrier side)
  static String cargoRefusalUrl(String cargoNumber) =>
      '$appDomain/api/common/cargo-refusal/$cargoNumber';

  /// Driver cargo refusal endpoint
  static final String cargoRefuseDriverUrl = '$driverUrl/cargo/refuse';

  /// Tracking stages endpoint
  static String trackingStagesUrl(int cargoId) =>
      '$appDomain/api/common/cargo/$cargoId/tracking-stages';
}
