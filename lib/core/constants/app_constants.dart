import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const int paginationLimit = 10;
  static const String arabicFont = "Alexandria";
  static final String? englishFont = GoogleFonts.openSans().fontFamily;
  static const String remoteMessage = 'remoteMessage';
  static const String tokenKey = 'token';
  static const String userDataKey = 'userDataKey';
  static const String onboardingKey = 'onboarding';
  static const String onboardingValue = 'show';
  static const String rs = '\uFDFC';
  static const String isTerminateNotification = 'terminate';
  static const String helpUrl = 'https://thkel.com';
  static const String serverExceptions = 'serverExceptions';
  static const String socketException = 'socketException';
  static const String timeoutException = 'timeoutException';
  static const String formatException = 'formatException';
  static const Duration timeOut = Duration(seconds: 30);
  static const Duration fileUploadTimeOut = Duration(seconds: 60);
  static const String unAuthorized = 'unAuthorized';
  static const Duration searchTime = Duration(milliseconds: 1500);
  static const String filter = 'filter';
  static const String search = 'search';
  static const String original = 'original';
  static const int splashTimer = 3;
  static const bool lightMode = false;
  static const bool darkMode = true;
  static const String success = 'success';
  static const String error = 'error';

  // Location permission results
  static const String granted = 'granted';
  static const String openSetting = 'openSetting';
  static const String permissionDenied = 'permissionDenied';
  static const String locationNotEnabled = 'locationNotEnabled';

  // Notification types - New cargo available for bidding
  static const String notificationTypeNewCargo = 'new_cargo';
  static const String notificationTypeNewCargoTitle = 'New Cargo Available';
  static const String notificationTypeCargoAvailable = 'cargo_available';
  static const String notificationTypeNewShipment = 'new_shipment';
  static const String notificationTypeShipmentAvailable = 'shipment_available';
  static const String notificationTypeCarrier = 'carrier';

  // Customer actions on driver/carrier bids
  static const String notificationTypeBidAccepted = 'bid_accepted';
  static const String notificationTypeCustomerAccepted = 'customer_accepted';
  static const String notificationTypeBidRejected = 'bid_rejected';
  static const String notificationTypeCustomerRejected = 'customer_rejected';
  static const String notificationTypeCustomerCancelBid = 'customer_cancel';
  static const String notificationTypeCarrierCancelBid = 'carrier_cancel';
  static const String notificationTypeCustomerCancelBidTitle =
      'Your bid has been canceled';

  // Bid accepted and payment
  static const String notificationTypePay = 'pay';
  static const String notificationTypeBidAcceptedTitle = 'Bid Accepted';
  static const String notificationTypeBidAcceptedBody =
      'Your bid has been accepted and payment has been processed';

  // Cargo status updates
  static const String notificationTypeOnTheWay = 'on_the_way';
  static const String notificationTypeStarted = 'started';
  static const String notificationTypeCompleted = 'completed';
  static const String notificationTypeCargoTrackingTitle = 'Cargo Tracking';

  // New cargo notification body
  static const String notificationTypeNewCargoBody =
      'A new cargo has been posted for bidding';

  // Customer cancels cargo
  static const String notificationTypeCargoCancelled = 'cargo_cancelled';
  static const String notificationTypeShipmentCancelled = 'shipment_cancelled';
  static const String notificationTypeCustomerCancelled = 'customer_cancelled';

  // Wallet notifications
  static const String notificationTypeDeposit = 'deposit';
  static const String notificationTypeWallet = 'wallet';
  static const String notificationTypeWithdraw = 'withdraw';
  static const String notificationTypeWithdrawal = 'withdrawal';

  // Ticket/Support notifications
  static const String notificationTypeTicketReply = 'ticket_reply';
  static const String notificationTypeTicketReplyTitle =
      'New Reply to Your Ticket';
  static const String notificationTypeTicketStatus = 'ticket_status';
  static const String notificationTypeTicketStatusChanged =
      'ticket_status_changed';
  static const String notificationTypeTicketStatusTitle =
      'Ticket Status Updated';
  static const String notificationTypeTicketUpdate = 'ticket_update';

  // Cargo tracking
  static const String notificationTypeCargoTracking = 'cargo_tracking';

  // Financial account
  static const String notificationTypeFinancialAccountApproved =
      'financial_account_approved';
  static const String notificationTypeFinancialAccountRejected =
      'financial_account_rejected';

  // Account status
  static const String notificationTypeStatusChanged = 'status_changed';

  // Entity ban/unban (driver/lorry)
  static const String notificationTypeEntityBanned = 'entity_banned';

  // Document notifications
  static const String notificationTypeDocumentExpiry = 'document_expiry';
  static const String notificationTypeDocumentExpiredDeactivation =
      'document_expired_deactivation';
  static const String notificationTypeDocumentApproved = 'document_approved';
  static const String notificationTypeDocumentRejected = 'document_rejected';
  static const String notificationTypeDocumentPending = 'document_pending';

  // Delay notifications
  static const String notificationTypeDelayPickup = 'delay_pickup';
  static const String notificationTypeDelayInTrip = 'delay_in_trip';
  static const String notificationTypeDelayDelivery = 'delay_delivery';
  static const String notificationTypeDelayEscalation = 'delay_escalation';
  static const String notificationTypeDelayAlert = 'delay_alert';

  // Contract notifications
  static const String notificationTypeContractIssued = 'contract_issued';

  // Bid outcome notifications
  static const String notificationTypeNotSelected = 'not_selected';

  // Per-field vehicle edit-request notifications (per
  // docs/public/EDIT_REQUEST_PER_FIELD_FRONTEND_GUIDE.md §8)
  static const String notificationTypeVehicleEditRequested =
      'vehicle_edit_requested';
  static const String notificationTypeVehicleEditFieldAccepted =
      'vehicle_edit_field_accepted';
  static const String notificationTypeVehicleEditAccepted =
      'vehicle_edit_accepted';
  static const String notificationTypeVehicleEditRejected =
      'vehicle_edit_rejected';

  // Per-field driver edit-request notifications (driver-side parallel
  // of the vehicle_edit_* family — `name` / `email` fields).
  static const String notificationTypeDriverEditRequested =
      'driver_edit_requested';
  static const String notificationTypeDriverEditFieldAccepted =
      'driver_edit_field_accepted';
  static const String notificationTypeDriverEditAccepted =
      'driver_edit_accepted';
  static const String notificationTypeDriverEditRejected =
      'driver_edit_rejected';

  // Static-page content updates (terms, policies, FAQs)
  static const String notificationTypePageUpdated = 'page_updated';
}
