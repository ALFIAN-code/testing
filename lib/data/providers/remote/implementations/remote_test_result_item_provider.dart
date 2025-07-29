import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/test_result_item_model.dart';
import '../interfaces/i_remote_test_result_item_provider.dart';

class RemoteTestResultItemProvider implements IRemoteTestResultItemProvider {

  final DioClient _dioClient;

  RemoteTestResultItemProvider(this._dioClient);

  @override
  Future<void> add(TestResultItemModel model) {
    try {
      throw Exception();
    } catch(e) {
      rethrow;
    }
  }
}