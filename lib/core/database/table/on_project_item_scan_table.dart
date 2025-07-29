import '../../../domain/entities/on_project_item_scan_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class OnProjectItemScanTable extends BaseDatabaseTable<OnProjectItemScanEntity> {
  @override
  String get tableName => DatabaseConstants.onProjectItemScanTable;

  String get id => 'id';
  String get projectId => 'projectId';
  String get itemBarcode => 'itemBarcode';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(OnProjectItemScanEntity entity) => {
    id: entity.id,
    projectId: entity.projectId,
    itemBarcode: entity.itemBarcode,
  };

  @override
  OnProjectItemScanEntity buildModel(Map<String, dynamic> map) => OnProjectItemScanEntity(
    id: map[id] as String,
    projectId: map[projectId] as String,
    itemBarcode: map[itemBarcode] as String,
  );

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $projectId TEXT NOT NULL,
      $itemBarcode TEXT NOT NULL
    )
  ''';
}
