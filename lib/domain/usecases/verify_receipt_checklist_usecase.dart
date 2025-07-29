import '../repositories/verification_receipt_checklist_repository.dart';
import 'base_usecase.dart';

class VerifyReceiptChecklistUseCase implements BaseUseCase<void, NoParams> {
  final VerificationReceiptChecklistRepository
      verificationReceiptChecklistRepository;

  VerifyReceiptChecklistUseCase({
    required this.verificationReceiptChecklistRepository,
  });

  @override
  Future<void> call(NoParams params) async {
    await verificationReceiptChecklistRepository.verifyReceiptChecklist();
  }
}
