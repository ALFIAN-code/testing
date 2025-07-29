import '../../../../domain/entities/item_entity.dart';

abstract class ILocalItemProvider {
  Future<void> upsertBatch(List<ItemEntity> entities);
  Future<ItemEntity?> getLatest();
  Future<void> deleteAll();
  Future<ItemEntity?> getByBarcode(String barcode);
}