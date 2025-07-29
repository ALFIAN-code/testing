import '../../../../domain/entities/on_project_item_scan_entity.dart';
import '../../../../domain/entities/prepare_return_item_scan_entity.dart';

abstract class ILocalPrepareReturnItemScanProvider {
  Future<void> insert(PrepareReturnItemScanEntity entity);
  Future<void> deleteBatch(List<String> ids);
  Future<List<PrepareReturnItemScanEntity>> getAll({String? projectId});
  Future<PrepareReturnItemScanEntity?> getById(String id);
  Future<void> truncate();
}