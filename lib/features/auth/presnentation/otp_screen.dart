import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rice_delivery/features/auth/provider/phone_auth_state.dart';

import '../../../core/constants/app_colors.dart';


class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  Timer? _timer;
  int _seconds = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) t.cancel();
      if (mounted) setState(() => _seconds--);
    });
  }

  void _verify() {
    if (_code.text.length != 6) return;
    ref.read(phoneAuthControllerProvider.notifier).verifyCode(_code.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(phoneAuthControllerProvider, (prev, next) {
      if (next.failure != null && next.failure != prev?.failure) {
        _code.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.failure!.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    });

    final s = ref.watch(phoneAuthControllerProvider);
    final verifying = s.status == PhoneAuthStatus.verifying;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () {
          ref.read(phoneAuthControllerProvider.notifier).reset();
          context.pop();
        }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Verify your number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Enter the 6-digit code sent to\n${s.phone ?? ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, height: 1.45)),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _code,
                  autofocus: true,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28, letterSpacing: 10, color: Colors.white),
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (v) {
                    setState(() {});
                    if (v.length == 6) _verify();
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: (_code.text.length == 6 && !verifying) ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.onGreen,
                    disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: verifying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: AppColors.onGreen))
                      : const Text('VERIFY',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: (_seconds > 0 || s.phone == null)
                    ? null
                    : () {
                        ref
                            .read(phoneAuthControllerProvider.notifier)
                            .sendCode(s.phone!, resend: true);
                        _startTimer();
                      },
                child: Text(
                  _seconds > 0 ? 'Resend in ${_seconds}s' : 'Resend code',
                  style: TextStyle(
                      color: _seconds > 0 ? AppColors.hint : AppColors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}