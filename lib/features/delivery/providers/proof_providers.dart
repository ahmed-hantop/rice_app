// features/delivery/providers/proof_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/proof_repository_impl.dart';
import '../domain/proof_repository.dart';

final proofRepositoryProvider = Provider<ProofRepository>(
  (ref) => ProofRepositoryImpl(FirebaseFirestore.instance, FirebaseStorage.instance),
);