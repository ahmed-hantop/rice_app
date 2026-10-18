import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/data/repositories/auth_repository.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';
import 'package:rice_delivery/features/auth/provider/phone_auth_state.dart';




class PhoneAuthController extends Notifier<PhoneAuthState> {
  @override
  PhoneAuthState build() => const PhoneAuthState();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> sendCode(String phone, {bool resend = false}) async {
    state = state.copyWith(status: PhoneAuthStatus.sendingCode, phone: phone);

    final res = await _repo.sendOtp(
      phone: phone,
      resendToken: resend ? state.resendToken : null,
    );

    if (res.isError || res.data == null) {
      state = state.copyWith(
        status: PhoneAuthStatus.idle,
        failure: UiError(res.error ?? 'Something went wrong.'),
      );
      return;
    }

    final s = res.data!;
    state = s.autoSignedIn
        ? const PhoneAuthState() // router takes over
        : state.copyWith(
            status: PhoneAuthStatus.codeSent,
            verificationId: s.verificationId,
            resendToken: s.resendToken,
          );
  }

  Future<void> verifyCode(String code) async {
    final id = state.verificationId;
    if (id == null) return;
    state = state.copyWith(status: PhoneAuthStatus.verifying);

    final res = await _repo.verifyOtp(verificationId: id, code: code);

    state = res.isError
        ? state.copyWith(
            status: PhoneAuthStatus.codeSent,
            failure: UiError(res.error ?? 'Something went wrong.'),
          )
        : const PhoneAuthState();
  }

  void reset() => state = const PhoneAuthState();
}

