import '../../../../domain/entities/item_preparation_scan_entity.dart';
import '../../../../domain/entities/on_project_item_scan_entity.dart';

abstract class ILocalOnProjectItemScanProvider {
  Future<void> insert(OnProjectItemScanEntity entity);
  Future<void> deleteBatch(List<String> ids);
  Future<List<OnProjectItemScanEntity>> getAll();
  Future<void> truncate();
}