import '../../../domain/entities/item_preparation_scan_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class ItemPreparationScanTable extends BaseDatabaseTable<ItemPreparationScanEntity> {
  @override
  String get tableName => DatabaseConstants.itemPreparationScanTable;

  String get id => 'id';
  String get projectId => 'projectId';
  String get itemBarcode => 'itemBarcode';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(ItemPreparationScanEntity entity) => {
    id: entity.id,
    projectId: entity.projectId,
    itemBarcode: entity.itemBarcode,
  };

  @override
  ItemPreparationScanEntity buildModel(Map<String, dynamic> map) => ItemPreparationScanEntity(
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
