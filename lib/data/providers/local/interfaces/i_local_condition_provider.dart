import '../../../../domain/entities/condition_entity.dart';

abstract class ILocalConditionProvider {
  Future<void> upsertBatch(List<ConditionEntity> entities);
  Future<void> deleteAll();
  Future<ConditionEntity?> getById(String id);
  Future<List<ConditionEntity>> getAll();
  Future<List<ConditionEntity>> getAllWithCategory();
}