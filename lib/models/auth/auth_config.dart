import 'package:equatable/equatable.dart';

class AuthConfigResponse extends Equatable {
  const AuthConfigResponse({
    required this.succeeded,
    required this.data,
    this.message = '',
  });

  final bool succeeded;
  final AuthConfigData data;
  final String message;

  factory AuthConfigResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AuthConfigResponse(
      succeeded: json['succeeded'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is Map<String, dynamic>
          ? AuthConfigData.fromJson(rawData)
          : AuthConfigData.defaults(),
    );
  }

  @override
  List<Object?> get props => [succeeded, data, message];
}

class AuthConfigData extends Equatable {
  const AuthConfigData({
    required this.student,
    this.teacher,
    required this.otp,
  });

  final AuthPersonaConfig student;
  final AuthPersonaConfig? teacher;
  final AuthOtpConfig otp;

  factory AuthConfigData.fromJson(Map<String, dynamic> json) => AuthConfigData(
        student: json['student'] is Map<String, dynamic>
            ? AuthPersonaConfig.fromJson(
                json['student'] as Map<String, dynamic>,
              )
            : AuthPersonaConfig.defaults(),
        teacher: json['teacher'] is Map<String, dynamic>
            ? AuthPersonaConfig.fromJson(
                json['teacher'] as Map<String, dynamic>,
              )
            : null,
        otp: json['otp'] is Map<String, dynamic>
            ? AuthOtpConfig.fromJson(json['otp'] as Map<String, dynamic>)
            : AuthOtpConfig.defaults(),
      );

  factory AuthConfigData.defaults() => AuthConfigData(
        student: AuthPersonaConfig.defaults(),
        otp: AuthOtpConfig.defaults(),
      );

  Map<String, dynamic> toJson() => {
        'student': student.toJson(),
        if (teacher != null) 'teacher': teacher!.toJson(),
        'otp': otp.toJson(),
      };

  @override
  List<Object?> get props => [student, teacher, otp];
}

class AuthPersonaConfig extends Equatable {
  const AuthPersonaConfig({
    required this.loginMethod,
    required this.otpDelivery,
    required this.showPhoneField,
    required this.showEmailField,
    required this.phoneRequired,
    required this.emailRequired,
    required this.otpHintEn,
    required this.otpHintAr,
  });

  final String loginMethod;
  final String otpDelivery;
  final bool showPhoneField;
  final bool showEmailField;
  final bool phoneRequired;
  final bool emailRequired;
  final String otpHintEn;
  final String otpHintAr;

  bool get isOtpLogin => loginMethod.toLowerCase() == 'otp';
  bool get deliversToEmail => otpDelivery.toLowerCase() == 'email';

  factory AuthPersonaConfig.fromJson(Map<String, dynamic> json) =>
      AuthPersonaConfig(
        loginMethod: json['loginMethod']?.toString() ?? 'Otp',
        otpDelivery: json['otpDelivery']?.toString() ?? 'Email',
        showPhoneField: json['showPhoneField'] as bool? ?? true,
        showEmailField: json['showEmailField'] as bool? ?? false,
        phoneRequired: json['phoneRequired'] as bool? ?? true,
        emailRequired: json['emailRequired'] as bool? ?? false,
        otpHintEn: json['otpHintEn']?.toString() ?? '',
        otpHintAr: json['otpHintAr']?.toString() ?? '',
      );

  factory AuthPersonaConfig.defaults() => const AuthPersonaConfig(
        loginMethod: 'Otp',
        otpDelivery: 'Email',
        showPhoneField: true,
        showEmailField: false,
        phoneRequired: true,
        emailRequired: false,
        otpHintEn: 'We sent a verification code to your registered email',
        otpHintAr: 'أرسلنا رمز التحقق إلى بريدك الإلكتروني المسجل',
      );

  Map<String, dynamic> toJson() => {
        'loginMethod': loginMethod,
        'otpDelivery': otpDelivery,
        'showPhoneField': showPhoneField,
        'showEmailField': showEmailField,
        'phoneRequired': phoneRequired,
        'emailRequired': emailRequired,
        'otpHintEn': otpHintEn,
        'otpHintAr': otpHintAr,
      };

  String otpHintForLocale(String languageCode) {
    final isAr = languageCode.startsWith('ar');
    final hint = isAr ? otpHintAr : otpHintEn;
    return hint.isNotEmpty ? hint : (isAr ? otpHintEn : otpHintAr);
  }

  @override
  List<Object?> get props => [
        loginMethod,
        otpDelivery,
        showPhoneField,
        showEmailField,
        phoneRequired,
        emailRequired,
        otpHintEn,
        otpHintAr,
      ];
}

class AuthOtpConfig extends Equatable {
  const AuthOtpConfig({required this.length, required this.expirySeconds});

  final int length;
  final int expirySeconds;

  factory AuthOtpConfig.fromJson(Map<String, dynamic> json) => AuthOtpConfig(
        length: (json['length'] as num?)?.toInt() ?? 4,
        expirySeconds: (json['expirySeconds'] as num?)?.toInt() ?? 300,
      );

  factory AuthOtpConfig.defaults() =>
      const AuthOtpConfig(length: 4, expirySeconds: 300);

  Map<String, dynamic> toJson() => {
        'length': length,
        'expirySeconds': expirySeconds,
      };

  @override
  List<Object?> get props => [length, expirySeconds];
}
