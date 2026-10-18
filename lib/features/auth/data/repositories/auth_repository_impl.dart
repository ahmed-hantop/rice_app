import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rice_delivery/features/auth/data/repositories/auth_repository.dart';
import 'package:rice_delivery/features/auth/domain/models/driver.dart';



class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth, this._db);
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  Stream<Driver?> watchDriver(String uid) =>
      _db.collection('drivers').doc(uid).snapshots().map(
            (doc) => doc.exists ? Driver.fromDoc(doc) : null,
          );

  @override
  Future<AuthResult<OtpSession>> sendOtp({
    required String phone,
    int? resendToken,
  }) {
    final c = Completer<AuthResult<OtpSession>>();

    void fail(Object e) {
      if (!c.isCompleted) c.complete(AuthResult.fail(_message(e)));
    }

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async {
        try {
          await _auth.signInWithCredential(cred);
          if (!c.isCompleted) {
            c.complete(const AuthResult.ok(OtpSession(autoSignedIn: true)));
          }
        } on FirebaseAuthException catch (e) {
          fail(e);
        }
      },
      verificationFailed: fail,
      codeSent: (id, token) {
        if (!c.isCompleted) {
          c.complete(AuthResult.ok(OtpSession(verificationId: id, resendToken: token)));
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    return c.future;
  }

  @override
  Future<AuthResult<void>> verifyOtp({
    required String verificationId,
    required String code,
  }) async {
    try {
      await _auth.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code),
      );
      return const AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_message(e));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

String _message(Object e) {
  if (e is FirebaseAuthException) {
    debugPrint('AUTH ERROR code=${e.code} message=${e.message}');
    switch (e.code) {
      case 'invalid-phone-number':
        return 'That phone number is not valid.';
      case 'invalid-verification-code':
        return 'Wrong code. Please check and try again.';
      case 'session-expired':
      case 'code-expired':
        return 'The code expired. Request a new one.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'quota-exceeded':
        return 'SMS limit reached. Try again later.';
      case 'user-disabled':
        return 'This account has been disabled. Contact dispatch.';
      case 'admin-restricted-operation':
        return 'This number is not registered. Contact dispatch.';
      case 'network-request-failed':
        return 'No internet connection.';
    }
    // Unknown code: show it while developing
    return kDebugMode ? 'Error: ${e.code}' : 'Something went wrong. Please try again.';
  }
  debugPrint('AUTH ERROR (non-firebase): $e');
  return 'Something went wrong. Please try again.';
}
}