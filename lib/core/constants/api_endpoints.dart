/// Canonical rice_delivery student API catalog (thkel-style typed getters + base URL).
/// Feature repositories should use this with [INetworkServices] /
/// `networkServicesDi` — not [ApiEndPoints] and not EnhancedNetworkHandler.
class ApiEndpoints {
  static String _baseUrl = 'https://api.rice_delivery.net.sa';

  static String get baseUrl => _baseUrl;

  static set setBaseUrl(String value) {
    _baseUrl =
        value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static String get apiVersion => _baseUrl;

  static const String courseBaseUrl = '/scalar/v1#tag/studentcourse';

  static const String studentApiVersion = '/GET/Api/V1/Student/Api/V1';

  // Authentication — public config (GET)
  static String get authConfig => '$apiVersion/Api/V1/Authentication/Config';

  // Student authentication (POST)
  static String get studentAuth => '$apiVersion/Api/V1/Authentication/Student';

  static String get sendOtp => '$studentAuth/SendOtp';
  static String get verifyOtp => '$studentAuth/VerifyOtp';
  static String get registStudent => '$studentAuth/SetAccountTypeAndUsage';
  static String get completeProfile => '$studentAuth/CompleteProfile';
  static String get addChild => '$studentAuth/AddChild';

  /// GET current user profile.
  static const String accountProfile = '/Api/V1/Authentication/Profile';

  /// POST update current user profile fields.
  static const String accountUpdateProfile =
      '/Api/V1/Authentication/Profile/Update';

  /// PUT multipart profile picture for current user.
  static const String accountUpdateProfilePicture =
      '/Api/V1/Authentication/Profile/Picture';

  /// Active nationalities for profile pickers (AllowAnonymous).
  static const String nationalities = '/Api/V1/Nationalities';

  /// Active pricing markets (AllowAnonymous).
  static const String pricingMarkets = '/Api/V1/Common/Pricing/markets';

  /// Current user's resolved pricing market (auth required).
  static const String pricingMyMarket = '/Api/V1/Common/Pricing/my-market';

  /// GET/PUT notification prefs (JWT).
  static const String notificationPreferences =
      '/Api/V1/Authentication/NotificationPreferences';

  /// POST/DELETE push device tokens (JWT).
  static const String deviceTokens = '/Api/V1/Authentication/DeviceTokens';

  /// POST soft-delete / deactivate account (JWT, Student|Guardian).
  static const String accountDelete = '/Api/V1/Authentication/Delete';

  /// POST public contact form (JWT optional).
  static const String contact = '/Api/V1/Contact';

  /// Update child profile: PUT /Api/V1/Student/Children/{studentId}
  static String updateChild(int studentId) =>
      '/Api/V1/Student/Children/$studentId';

  /// Update child profile picture: PUT /Api/V1/Student/Children/{studentId}/ProfilePicture
  static String updateChildProfilePicture(int studentId) =>
      '/Api/V1/Student/Children/$studentId/ProfilePicture';

  /// Composite student file (attendance, upcoming sessions, documents).
  static String childFile(int studentId) =>
      '/Api/V1/Student/Children/$studentId/File';

  // Education endpoints
  static String get domains => '$apiVersion/Api/V1/Education/Domains';

  /// Active education domains for students (Home / Domains / filter wizard).
  static const String studentDomains = '/Api/V1/Student/Domains';

  static String get curricula => '$apiVersion/Api/V1/Curriculum';
  static String get levels => '$apiVersion/Api/V1/Education/Levels';
  static String get grades => '$apiVersion/Api/V1/Education/Grades';

  // Courses endpoints
  static const String courses = '/Api/V1/Student/Courses';
  static String courseDetails(String id) => '/Api/V1/Student/Courses/$id';

  static const String coursesRecommended =
      '/Api/V1/Student/Courses/Recommended';

  /// Path only — pass `fromDate` / `toDate` via queryParams on INetworkServices.
  static String teacherAvailabilityPath(int teacherId) =>
      '/Api/V1/Student/Teachers/$teacherId/Availability';

  @Deprecated('Use teacherAvailabilityPath + queryParams')
  static String teacherAvailability(
    int teacherId, {
    required String fromDate,
    required String toDate,
  }) =>
      '${teacherAvailabilityPath(teacherId)}?fromDate=$fromDate&toDate=$toDate';

  static const String teachers = '/Api/V1/Student/Teachers';

  static const String teachersRecommended =
      '/Api/V1/Student/Teachers/Recommended';

  static String teacherById(int id) => '/Api/V1/Student/Teachers/$id';

  static String teacherSubjects(int id) =>
      '/Api/V1/Student/Teachers/$id/Subjects';

  static String teacherSubjectUnits(int teacherId, int teacherSubjectId) =>
      '/Api/V1/Student/Teachers/$teacherId/Subjects/$teacherSubjectId/Units';

  static String teacherReviews(int id) =>
      '/Api/V1/Student/Teachers/$id/Reviews';

  static String teacherCertificates(int id) =>
      '/Api/V1/Student/Teachers/$id/Certificates';

  static const String educationFilterOptions =
      '/Api/V1/Education/filter-options';

  static const String teachingModes = '/Api/V1/Teaching/Modes';

  static const String timeSlots = '/Api/V1/Teaching/TimeSlots';

  static const String contentUnits = '/Api/V1/Content/Units';

  static const String contentLessons = '/Api/V1/Content/Lessons';

  /// Quran session-scoped catalogs (not education filter-options steps).
  static const String quranContentTypes = '/Api/V1/Quran/ContentTypes';

  static const String quranLevels = '/Api/V1/Quran/Levels';

  static const String enrollmentRequests = '/Api/V1/Student/EnrollmentRequests';

  static String enrollmentRequestById(int id) =>
      '/Api/V1/Student/EnrollmentRequests/$id';

  static String enrollmentRequestMemberResponse(int enrollmentRequestId) =>
      '/Api/V1/Student/EnrollmentRequests/$enrollmentRequestId/Members/Response';

  static String enrollmentRequestCancelInvite(
    int enrollmentRequestId,
    int studentId,
  ) =>
      '/Api/V1/Student/EnrollmentRequests/$enrollmentRequestId/Members/$studentId/Cancel';

  static const String payEnrollmentParticipant =
      '/Api/V1/Student/Payments/Participants';

  static const String createPaymentIntent = '/Api/V1/Student/Payments/Intents';

  static const String confirmPayment = '/Api/V1/Student/Payments/Confirm';

  static String enrollmentPaymentSummary(int enrollmentId) =>
      '/Api/V1/Student/Payments/Enrollments/$enrollmentId/Summary';

  static const String studentPayments = '/Api/V1/Student/Payments';

  static String studentPaymentById(int paymentId) =>
      '/Api/V1/Student/Payments/$paymentId';

  static const String enrollments = '/Api/V1/Student/Enrollments';

  static String enrollmentById(int id) => '/Api/V1/Student/Enrollments/$id';

  static String enrollmentCancel(int id) =>
      '/Api/V1/Student/Enrollments/$id/Cancel';

  static String enrollmentRequestCancel(int id) =>
      '/Api/V1/Student/EnrollmentRequests/$id/Cancel';

  static const String invitations = '/Api/V1/Student/Invitations';

  static String invitationByKey(String invitationKey) =>
      '$invitations/${Uri.encodeComponent(invitationKey)}';

  /// Name/email search for inviting students to a group enrollment.
  static const String studentSearch = '/Api/V1/Student/Students/Search';

  /// Student course schedules (join / review / detail).
  static String studentSessionById(int id) => '/Api/V1/Student/Sessions/$id';

  static String studentSessionJoin(int id) =>
      '/Api/V1/Student/Sessions/$id/Join';

  static String studentSessionLiveToken(int id) =>
      '/Api/V1/Student/Sessions/$id/LiveToken';

  static String studentSessionReview(int id) =>
      '/Api/V1/Student/Sessions/$id/Review';

  static String studentSessionComplaints(int id) =>
      '/Api/V1/Student/Sessions/$id/Complaints';

  static String studentSessionComplaintById(int complaintId) =>
      '/Api/V1/Student/Sessions/Complaints/$complaintId';

  /// Unified student complaints (all subject types).
  static const String studentComplaints = '/Api/V1/Student/Complaints';

  static String studentComplaintById(int id) =>
      '/Api/V1/Student/Complaints/$id';

  static String studentComplaintRespond(int id) =>
      '/Api/V1/Student/Complaints/$id/Respond';

  static const String studentSessionsList = '/Api/V1/Student/Sessions';

  static const String openSessionRequests =
      '/Api/V1/Student/OpenSessionRequests';

  static const String openSessionRequestsMy =
      '/Api/V1/Student/OpenSessionRequests/my';

  static String openSessionRequestById(int id) =>
      '/Api/V1/Student/OpenSessionRequests/$id';

  static String openSessionRequestCancel(int id) =>
      '/Api/V1/Student/OpenSessionRequests/$id/Cancel';

  /// Invitee Accept/Reject for OSR member invitations.
  static String openSessionRequestMemberResponse(int openSessionRequestId) =>
      '/Api/V1/Student/OpenSessionRequests/$openSessionRequestId/Members/Response';

  static String openSessionRequestAttachments(int id) =>
      '/Api/V1/Student/OpenSessionRequests/$id/Attachments';

  static String openSessionRequestOffers(int id) =>
      '/Api/V1/Student/OpenSessionRequests/$id/Offers';

  static String openSessionRequestOfferById(int id, int offerId) =>
      '/Api/V1/Student/OpenSessionRequests/$id/Offers/$offerId';

  static String openSessionOfferAccept(int offerId) =>
      '/Api/V1/Student/OpenSessionRequests/Offers/$offerId/Accept';

  static String openSessionOfferReject(int offerId) =>
      '/Api/V1/Student/OpenSessionRequests/Offers/$offerId/Reject';

  static String openSessionOfferAvailabilityCheck(int offerId) =>
      '/Api/V1/Student/OpenSessionRequests/Offers/$offerId/availability-check';

  static String conversationsByRequest(int requestId, int teacherId) =>
      '/Api/V1/Conversations/by-request/$requestId/teacher/$teacherId';

  static String conversationsByOffer(int offerId) =>
      '/Api/V1/Conversations/by-offer/$offerId';

  static String conversationMessages(int conversationId) =>
      '/Api/V1/Conversations/$conversationId/messages';

  static String conversationSendMessage(int conversationId) =>
      '/Api/V1/Conversations/$conversationId/messages';

  static String conversationMarkRead(int conversationId) =>
      '/Api/V1/Conversations/$conversationId/read';

  static const String myChildren = '/Api/V1/Student/MyChildren';

  // Legal documents (public, localized via Accept-Language / lang)
  static const String legalDocuments = '/Api/V1/Legal/Documents';

  static String legalDocumentByCode(String code) =>
      '/Api/V1/Legal/Documents/$code';

  static const String logout = 'auth/logout';
  static const String logoutAll = 'auth/logout-all';

  static const String products = 'products';

  static String replacePathParams(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    var result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }

  static String getFullUrl(String endpoint) => endpoint;

  static String getUrlWithParams(String endpoint, Map<String, dynamic> params) {
    final replacedEndpoint = replacePathParams(endpoint, params);
    return getFullUrl(replacedEndpoint);
  }

  static const Map<String, String> environments = {
    'development': 'https://fakestoreapi.com/',
    'staging': 'https://fakestoreapi.com/',
    'production': 'https://fakestoreapi.com/',
  };

  static String getBaseUrlForEnvironment(String environment) =>
      environments[environment] ?? environments['production']!;

  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusUnprocessableEntity = 422;
  static const int statusInternalServerError = 500;
  static const int statusServiceUnavailable = 503;

  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerAccept = 'Accept';
  static const String headerUserAgent = 'User-Agent';
  static const String headerAcceptLanguage = 'Accept-Language';

  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'multipart/form-data';
  static const String contentTypeUrlEncoded =
      'application/x-www-form-urlencoded';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
