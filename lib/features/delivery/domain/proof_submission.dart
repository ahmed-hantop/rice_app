// features/delivery/domain/proof_submission.dart
import '../../../core/services/location_service.dart';

class ProofSubmission {
  const ProofSubmission({
    required this.orderId,
    required this.driverId,
    required this.photoPath,
    required this.notes,
    required this.tempOk,
    required this.smsNotified,
    required this.location,
  });

  final String orderId, driverId, photoPath, notes;
  final bool tempOk, smsNotified;
  final Coordinates location;
}