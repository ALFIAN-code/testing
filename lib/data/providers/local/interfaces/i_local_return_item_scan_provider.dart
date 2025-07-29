import '../../../../domain/entities/return_item_scan_entity.dart';

abstract class ILocalReturnItemScanProvider {
  Future<void> insert(ReturnItemScanEntity entity);
  Future<void> deleteBatch(List<String> ids);
  Future<List<ReturnItemScanEntity>> getAll();
  Future<ReturnItemScanEntity?> getById(String id);
  Future<void> truncate();
}