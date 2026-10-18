// features/delivery/domain/proof_repository.dart
import 'proof_submission.dart';

abstract class ProofRepository {
  /// Uploads the photo and saves the proof record.
  /// Marking the order delivered and crediting earnings is done by the server.
  Future<void> submit(ProofSubmission proof);
}