import '../../../domain/entities/on_project_item_scan_entity.dart';
import '../../../domain/entities/return_item_scan_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class ReturnItemScanTable extends BaseDatabaseTable<ReturnItemScanEntity> {
  @override
  String get tableName => DatabaseConstants.returnItemScanTable;

  String get id => 'id';
  String get itemBarcode => 'itemBarcode';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(ReturnItemScanEntity entity) => {
    id: entity.id,
    itemBarcode: entity.itemBarcode,
  };

  @override
  ReturnItemScanEntity buildModel(Map<String, dynamic> map) => ReturnItemScanEntity(
    id: map[id] as String,
    itemBarcode: map[itemBarcode] as String,
  );

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $itemBarcode TEXT NOT NULL
    )
  ''';
}
