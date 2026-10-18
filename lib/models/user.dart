class Customer {
  final int id;
  final String fullname;
  final String email;
  final String role;
  final String createdAt;

  Customer({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      role: json['role'],
      createdAt: json['createdAt'],
    );
  }

  factory Customer.empty() {
    return Customer(
      id: 0,
      fullname: '',
      email: '',
      role: '',
      createdAt: '',
    );
  }
}

class Data {
  // sendOtp response fields
  final bool? isNewUser;
  final String? phoneNumber;
  final String? otpSentTo;
  final String? maskedDestination;

  // verifyOtp response fields
  final String? token;
  final int? currentStep;
  final String? nextStepName;
  final bool? isNextStepRequired;
  final List<dynamic>? optionalSteps;
  final String? nextStepDescription;
  final bool? isRegistrationComplete;
  final String? message;
  final List<String>? roles;

  Data({
    this.isNewUser,
    this.phoneNumber,
    this.otpSentTo,
    this.maskedDestination,
    this.token,
    this.currentStep,
    this.nextStepName,
    this.isNextStepRequired,
    this.optionalSteps,
    this.nextStepDescription,
    this.isRegistrationComplete,
    this.message,
    this.roles,
  });

  Data copyWith({
    bool? isNewUser,
    String? phoneNumber,
    String? otpSentTo,
    String? maskedDestination,
    String? token,
    int? currentStep,
    String? nextStepName,
    bool? isNextStepRequired,
    List<dynamic>? optionalSteps,
    String? nextStepDescription,
    bool? isRegistrationComplete,
    String? message,
    List<String>? roles,
  }) => Data(
    isNewUser: isNewUser ?? this.isNewUser,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    otpSentTo: otpSentTo ?? this.otpSentTo,
    maskedDestination: maskedDestination ?? this.maskedDestination,
    token: token ?? this.token,
    currentStep: currentStep ?? this.currentStep,
    nextStepName: nextStepName ?? this.nextStepName,
    isNextStepRequired: isNextStepRequired ?? this.isNextStepRequired,
    optionalSteps: optionalSteps ?? this.optionalSteps,
    nextStepDescription: nextStepDescription ?? this.nextStepDescription,
    isRegistrationComplete:
        isRegistrationComplete ?? this.isRegistrationComplete,
    message: message ?? this.message,
    roles: roles ?? this.roles,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isNewUser: json["isNewUser"],
    phoneNumber: json["phoneNumber"],
    otpSentTo: json["otpSentTo"]?.toString(),
    maskedDestination: json["maskedDestination"]?.toString(),
    token: json["token"],
    currentStep: json["currentStep"],
    nextStepName: json["nextStepName"],
    isNextStepRequired: json["isNextStepRequired"],
    optionalSteps:
        json["optionalSteps"] != null
            ? List<dynamic>.from(json["optionalSteps"].map((x) => x))
            : null,
    nextStepDescription: json["nextStepDescription"],
    isRegistrationComplete: json["isRegistrationComplete"],
    message: json["message"],
    roles:
        json["roles"] != null
            ? List<String>.from(
              (json["roles"] as List).map((x) => x.toString()),
            )
            : null,
  );

  Map<String, dynamic> toJson() => {
    "isNewUser": isNewUser,
    "phoneNumber": phoneNumber,
    "otpSentTo": otpSentTo,
    "maskedDestination": maskedDestination,
    "token": token,
    "currentStep": currentStep,
    "nextStepName": nextStepName,
    "isNextStepRequired": isNextStepRequired,
    "optionalSteps":
        optionalSteps != null
            ? List<dynamic>.from(optionalSteps!.map((x) => x))
            : null,
    "nextStepDescription": nextStepDescription,
    "isRegistrationComplete": isRegistrationComplete,
    "message": message,
    "roles": roles,
  };

  factory Data.empty() {
    return Data(
      token: null,
      currentStep: 1,
      nextStepName: '',
      isNextStepRequired: false,
      optionalSteps: [],
      nextStepDescription: '',
      isRegistrationComplete: false,
      message: '',
      roles: null,
    );
  }
}
