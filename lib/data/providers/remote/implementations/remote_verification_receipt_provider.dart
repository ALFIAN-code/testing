import '../../../../core/services/network_service/dio_client.dart';
import '../interfaces/i_verification_receipt_provider.dart';

class RemoteVerificationReceiptProvider
    implements IVerificationReceiptProvider {
  RemoteVerificationReceiptProvider({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<void> verifyReceiptChecklist() async {
    try {
      await dioClient.get('/verify/checklist');
    } catch (e) {  
      rethrow;
    }
  }
}
