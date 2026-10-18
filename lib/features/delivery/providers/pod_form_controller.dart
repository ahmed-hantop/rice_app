// features/delivery/providers/pod_form_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_delivery/features/auth/provider/auth_provider.dart';

import '../../../core/services/location_service.dart';
import '../../../core/services/photo_service.dart';
import '../domain/proof_submission.dart';
import 'proof_providers.dart';

class PodFormState {
  const PodFormState({
    this.arrived = false,
    this.photoPath,
    this.location,
    this.notes = '',
    this.tempOk = false,
    this.smsNotified = false,
    this.submitting = false,
  });

  final bool arrived, tempOk, smsNotified, submitting;
  final String? photoPath;
  final Coordinates? location;
  final String notes;

  bool get canSubmit =>
      arrived && photoPath != null && location != null && !submitting;

  PodFormState copyWith({
    bool? arrived,
    String? photoPath,
    Coordinates? location,
    String? notes,
    bool? tempOk,
    bool? smsNotified,
    bool? submitting,
  }) =>
      PodFormState(
        arrived: arrived ?? this.arrived,
        photoPath: photoPath ?? this.photoPath,
        location: location ?? this.location,
        notes: notes ?? this.notes,
        tempOk: tempOk ?? this.tempOk,
        smsNotified: smsNotified ?? this.smsNotified,
        submitting: submitting ?? this.submitting,
      );
}

class PodFormController extends AutoDisposeNotifier<PodFormState> {
  @override
  PodFormState build() => const PodFormState();

  void toggleArrived() => state = state.copyWith(arrived: !state.arrived);
  void toggleTempOk() => state = state.copyWith(tempOk: !state.tempOk);
  void toggleSmsNotified() => state = state.copyWith(smsNotified: !state.smsNotified);
  void setNotes(String v) => state = state.copyWith(notes: v);

  /// Takes the photo, then stamps it with the current location.
  /// Returns an error message, or null on success or cancel.
  Future<String?> takePhoto() async {
    try {
      final path = await ref.read(photoServiceProvider).capture();
      if (path == null) return null; // cancelled

      final where = await ref.read(locationServiceProvider).current();
      if (where == null) {
        return 'Could not get your location. Turn on GPS, allow location access, and retake the photo.';
      }
      state = state.copyWith(photoPath: path, location: where);
      return null;
    } catch (_) {
      return 'Could not open the camera.';
    }
  }

  /// Returns an error message, or null when the proof was saved.
  Future<String?> submit(String orderId) async {
    final uid = ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return 'You are signed out.';
    if (!state.canSubmit) return 'Confirm arrival and take a photo first.';

    state = state.copyWith(submitting: true);
    try {
      await ref.read(proofRepositoryProvider).submit(ProofSubmission(
            orderId: orderId,
            driverId: uid,
            photoPath: state.photoPath!,
            notes: state.notes.trim(),
            tempOk: state.tempOk,
            smsNotified: state.smsNotified,
            location: state.location!,
          ));
      state = state.copyWith(submitting: false);
      return null;
    } catch (_) {
      state = state.copyWith(submitting: false);
      return 'Could not submit the proof. Check your connection and try again.';
    }
  }
}

final podFormProvider =
    AutoDisposeNotifierProvider<PodFormController, PodFormState>(PodFormController.new);