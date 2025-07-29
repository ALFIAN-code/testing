import '../../data/models/test_result_item_model.dart';
import '../entities/test_result_item_entity.dart';

abstract class TestResultItemRepository {
  Future<void> insert(TestResultItemModel model);
  Future<List<TestResultItemModel>> getAll();
  Future<List<TestResultItemModel>> getAllLocal(List<String> itemIds);
  Future<void> deleteAll();
}