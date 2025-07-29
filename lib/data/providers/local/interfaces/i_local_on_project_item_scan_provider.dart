import '../../../../domain/entities/on_project_item_scan_entity.dart';

abstract class ILocalOnProjectItemScanProvider {
  Future<void> insert(OnProjectItemScanEntity entity);
  Future<void> deleteBatch(List<String> ids);
  Future<List<OnProjectItemScanEntity>> getAll({String? projectId});
  Future<OnProjectItemScanEntity?> getById(String id);
  Future<void> truncate();
}