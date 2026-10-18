// lib/features/auth/providers/phone_auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/domain/controlllers/phone_auth_controllerer.dart';


enum PhoneAuthStatus { idle, sendingCode, codeSent, verifying }

/// Non-const on purpose: each new instance counts as a new "event",
/// so the same error twice still triggers the snackbar.
class UiError {
  UiError(this.message);
  final String message;
}

class PhoneAuthState {
  const PhoneAuthState({
    this.status = PhoneAuthStatus.idle,
    this.phone,
    this.verificationId,
    this.resendToken,
    this.failure,
  });

  final PhoneAuthStatus status;
  final String? phone, verificationId;
  final int? resendToken;
  final UiError? failure;

  /// `failure` is one-shot: any copyWith without it clears it.
  PhoneAuthState copyWith({
    PhoneAuthStatus? status,
    String? phone,
    String? verificationId,
    int? resendToken,
    UiError? failure,
  }) =>
      PhoneAuthState(
        status: status ?? this.status,
        phone: phone ?? this.phone,
        verificationId: verificationId ?? this.verificationId,
        resendToken: resendToken ?? this.resendToken,
        failure: failure,
      );
}

final phoneAuthControllerProvider =
    NotifierProvider<PhoneAuthController, PhoneAuthState>(PhoneAuthController.new);