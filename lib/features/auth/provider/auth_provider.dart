import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/data/repositories/auth_repository.dart';
import 'package:rice_delivery/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rice_delivery/features/auth/domain/models/driver.dart';



final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance),
);

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final driverProvider = StreamProvider<Driver?>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(null);
  return ref.watch(authRepositoryProvider).watchDriver(user.uid);
});