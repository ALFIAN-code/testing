import '../../../../domain/entities/condition_category_entity.dart';
import '../../../../domain/entities/condition_entity.dart';

abstract class ILocalConditionCategoryProvider {
  Future<void> upsertBatch(List<ConditionCategoryEntity> entities);
  Future<List<ConditionCategoryEntity>> getAll();
  Future<void> deleteAll();
}