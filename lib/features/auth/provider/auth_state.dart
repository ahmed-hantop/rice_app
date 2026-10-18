// import 'package:rice_delivery/features/auth/model/otp_response.dart';

// class AuthState {
//   final bool isAuthenticated;
//   final bool isLoading;
//   final OtpResponse? response;
//   final String? error;
//   final int? errorStatusCode;
//   final String? errorCode;

//   const AuthState({
//     this.isAuthenticated = false,
//     this.isLoading = false,
//     this.response,
//     this.error,
//     this.errorStatusCode,
//     this.errorCode,
//   });

//   AuthState copyWith({
//     bool? isLoading,
//     bool? isAuthenticated,
//     OtpResponse? response,
//     String? error,
//     int? errorStatusCode,
//     String? errorCode,
//     bool clearError = false,
//   }) {
//     return AuthState(
//       isLoading: isLoading ?? this.isLoading,
//       isAuthenticated: isAuthenticated ?? this.isAuthenticated,
//       response: response ?? this.response,
//       error: clearError ? null : (error ?? this.error),
//       errorStatusCode: clearError ? null : (errorStatusCode ?? this.errorStatusCode),
//       errorCode: clearError ? null : (errorCode ?? this.errorCode),
//     );
//   }
// }
