import '../../../models/test_result_item_model.dart';

abstract class IRemoteTestResultItemProvider {
  Future<void> add(TestResultItemModel model);
}