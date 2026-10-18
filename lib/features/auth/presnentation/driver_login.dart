import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rice_delivery/features/auth/domain/controlllers/login_controller.dart';


import '../../../core/constants/app_colors.dart';


class DriverLoginScreen extends ConsumerStatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  ConsumerState<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends ConsumerState<DriverLoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static const _countryCode = '+966';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// +966 + digits, dropping a leading 0 (0501234567 -> +966501234567)
  String get _e164 {
    var digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) digits = digits.substring(1);
    return '$_countryCode$digits';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
debugPrint("User Phone number Is :$_e164");
    // Signs in with the email account, then checks the phone in Firestore.
    ref.read(driverLoginControllerProvider.notifier).login(_e164);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(driverLoginControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        _showSnackBar(next.error!);
      }
      // Phone number found in Firestore `users` -> go to home
      if (next.status == DriverLoginStatus.success &&
          prev?.status != DriverLoginStatus.success) {
        debugPrint("Where to go ????");
        //context.go('/home');
      }
    });

    final isLoading =
        ref.watch(driverLoginControllerProvider).status == DriverLoginStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.field,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: AppColors.green.withValues(alpha: 0.35), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.green.withValues(alpha: 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 34, color: AppColors.green),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildPill(),
                      const SizedBox(height: 16),
                      const Text(
                        'Driver Sign In',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Enter your registered courier phone number. We will text you a verification code.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, height: 1.45, color: AppColors.muted),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildCredentialCard(),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: AppColors.onGreen,
                            disabledBackgroundColor: AppColors.green.withValues(alpha: 0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: AppColors.onGreen),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('SEND CODE',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: AppColors.onGreen)),
                                    SizedBox(width: 8),
                                    Icon(Icons.sms_outlined,
                                        size: 18, color: AppColors.onGreen),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Not registered? Contact dispatch.',
                          style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 3, backgroundColor: AppColors.green),
            SizedBox(width: 7),
            Text('DRIVER GATEWAY',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.green)),
          ],
        ),
      );

  Widget _buildAppBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(bottom: BorderSide(color: AppColors.field)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFF0284C7),
                  borderRadius: BorderRadius.circular(9)),
              child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FLEETRUNNER',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.muted)),
                Text('Driver Login',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
            const Spacer(),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.field,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.help_outline_rounded,
                  size: 18, color: AppColors.muted),
            ),
          ],
        ),
      );

  Widget _buildCredentialCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('MOBILE NUMBER',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted)),
                Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        size: 13, color: AppColors.green),
                    const SizedBox(width: 4),
                    Text('Direct Carrier SMS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.green.withValues(alpha: 0.9))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.field,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: AppColors.border)),
                    ),
                    child: const Text(_countryCode,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9 \-]')),
                        LengthLimitingTextInputFormatter(14),
                      ],
                      onFieldSubmitted: (_) => _submit(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '50 000-0000',
                        hintStyle: TextStyle(color: AppColors.hint, fontSize: 14),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        errorStyle: TextStyle(height: 0.9),
                      ),
                      validator: (val) {
                        var d = (val ?? '').replaceAll(RegExp(r'\D'), '');
                        if (d.startsWith('0')) d = d.substring(1);
                        if (d.isEmpty) return 'Phone number is required';
                        // Saudi mobile: 9 digits starting with 5
                        if (!RegExp(r'^5\d{8}$').hasMatch(d)) {
                          return 'Enter a valid Saudi mobile (5X XXX XXXX)';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}