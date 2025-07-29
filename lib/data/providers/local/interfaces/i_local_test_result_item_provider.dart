import '../../../../domain/entities/test_result_item_entity.dart';

abstract class ILocalTestResultItemProvider {
  Future<void> insert(TestResultItemEntity entity);
  Future<List<TestResultItemEntity>> getAll(List<String> itemIds);
  Future<void> deleteAll();
}