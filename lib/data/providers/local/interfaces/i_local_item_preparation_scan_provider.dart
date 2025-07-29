import '../../../../domain/entities/item_preparation_scan_entity.dart';

abstract class ILocalItemPreparationScanProvider {
  Future<void> insert(ItemPreparationScanEntity entity);
  Future<void> deleteBatch(List<String> ids);
  Future<List<ItemPreparationScanEntity>> getAll({String? projectId});
  Future<ItemPreparationScanEntity?> getById(String id);
  Future<void> truncate();
}