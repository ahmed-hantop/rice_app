import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DriverLoginStatus { idle, loading, success }

class DriverLoginState {
  final DriverLoginStatus status;
  final String? error;
  const DriverLoginState({this.status = DriverLoginStatus.idle, this.error});
}

class DriverLoginController extends Notifier<DriverLoginState> {
  static const _authEmail = 'hantoobahmed@gmail.com';
  static const _authPassword = 'Ahmed@2030';

  @override
  DriverLoginState build() => const DriverLoginState();

  /// [e164] example: +966501234567
  Future<void> login(String e164) async {
    state = const DriverLoginState(status: DriverLoginStatus.loading);
    final auth = FirebaseAuth.instance;

    try {
      // 1. Authenticate with the email account
      if (auth.currentUser?.email != _authEmail) {
        await auth.signInWithEmailAndPassword(
          email: _authEmail,
          password: _authPassword,
        );
      }

      // 2. Look for a user with this phone number
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: e164)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) {
        await auth.signOut();
        state = const DriverLoginState(
          error: 'This phone number is not registered. Contact dispatch.',
        );
        return;
      }

      // 3. Found: the screen routes to /home
      state = const DriverLoginState(status: DriverLoginStatus.success);
    } on FirebaseAuthException catch (e) {
      state = DriverLoginState(error: _authMessage(e));
    } on FirebaseException catch (e) {
      state = DriverLoginState(
        error: e.code == 'permission-denied'
            ? 'No permission to read users. Check Firestore rules.'
            : (e.message ?? 'Database error.'),
      );
    } catch (_) {
      state = const DriverLoginState(error: 'Something went wrong. Try again.');
    }
  }

  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Login account is invalid. Contact support.';
      case 'operation-not-allowed':
        return 'Email sign-in is not enabled in Firebase.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

final driverLoginControllerProvider =
    NotifierProvider<DriverLoginController, DriverLoginState>(
        DriverLoginController.new);
