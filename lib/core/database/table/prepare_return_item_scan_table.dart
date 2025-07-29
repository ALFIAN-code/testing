import '../../../domain/entities/on_project_item_scan_entity.dart';
import '../../../domain/entities/prepare_return_item_scan_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class PrepareReturnItemScanTable extends BaseDatabaseTable<PrepareReturnItemScanEntity> {
  @override
  String get tableName => DatabaseConstants.prepareReturnItemScanTable;

  String get id => 'id';
  String get projectId => 'projectId';
  String get itemBarcode => 'itemBarcode';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(PrepareReturnItemScanEntity entity) => {
    id: entity.id,
    projectId: entity.projectId,
    itemBarcode: entity.itemBarcode,
  };

  @override
  PrepareReturnItemScanEntity buildModel(Map<String, dynamic> map) => PrepareReturnItemScanEntity(
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
