import '../../../../domain/entities/item_code_entity.dart';

abstract class ILocalItemCodeProvider {
  Future<void> upsertBatch(List<ItemCodeEntity> entities);
  Future<ItemCodeEntity?> getLatest();
  Future<void> deleteAll();
  Future<ItemCodeEntity?> getById(String id);
}