import '../../domain/repositories/verification_receipt_checklist_repository.dart';
import '../providers/remote/implementations/remote_verification_receipt_provider.dart';

class VerificationReceiptChecklistRepositoryImpl
    implements VerificationReceiptChecklistRepository {
  final RemoteVerificationReceiptProvider remoteVerificationReceiptProvider;
  VerificationReceiptChecklistRepositoryImpl({
    required this.remoteVerificationReceiptProvider,
  });

  @override
  Future<void> verifyReceiptChecklist() async {
    await remoteVerificationReceiptProvider.verifyReceiptChecklist();
  }
}
