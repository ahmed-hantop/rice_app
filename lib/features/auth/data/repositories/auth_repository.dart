// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:rice_delivery/features/auth/domain/models/driver.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;


class AuthResult<T> {
  const AuthResult.ok([this.data]) : error = null;
  const AuthResult.fail(this.error) : data = null;
  final T? data;
  final String? error;
  bool get isError => error != null;
}

class OtpSession {
  const OtpSession({this.verificationId, this.resendToken, this.autoSignedIn = false});
  final String? verificationId;
  final int? resendToken;
  final bool autoSignedIn; // Android auto-read the SMS and signed in
}

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  Stream<Driver?> watchDriver(String uid);
  Future<AuthResult<OtpSession>> sendOtp({required String phone, int? resendToken});
  Future<AuthResult<void>> verifyOtp({required String verificationId, required String code});
  Future<void> signOut();
}

// abstract class AuthRepository {
//   AuthRepository(this.firebaseAuth, this.firestore);

//   final FirebaseAuth firebaseAuth;
//   final FirebaseFirestore firestore;

//   Stream<User?> authStateChanges();
//   Stream<Driver?> watchDriver(String uid);

//   Future<PostDataHandle<OtpSession>> sendOtp({
//     required String phone,
//     int? resendToken,
//   });

//   Future<PostDataHandle<void>> verifyOtp({
//     required String verificationId,
//     required String code,
//   });
//   Future<User?> signIn(String email, String password);

//   Future<void> signOut();
// }

// class OtpSession {
//   const OtpSession({
//     this.verificationId,
//     this.resendToken,
//     this.autoSignedIn = false,
//   });

//   final String? verificationId;
//   final int? resendToken;

//   /// Android SMS auto-retrieval already signed the user in.
//   final bool autoSignedIn;
// }