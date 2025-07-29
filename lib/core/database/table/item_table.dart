import '../../../domain/entities/item_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class ItemTable extends BaseDatabaseTable<ItemEntity> {
  @override
  String get tableName => DatabaseConstants.itemTable;

  String get id => 'id';
  String get itemCodeId => 'itemCodeId';
  String get barcode => 'barcode';
  String get description => 'description';
  String get brand => 'brand';
  String get model => 'model';
  String get serialNumber => 'serialNumber';
  String get specification => 'specification';
  String get poReference => 'poReference';
  String get purchasedDate => 'purchasedDate';
  String get conditionId => 'conditionId';
  String get projectId => 'projectId';
  String get lastLocationName => 'lastLocationName';
  String get quantity => 'quantity';
  String get lastUpdate => 'lastUpdate';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(ItemEntity entity) => {
    id: entity.id,
    itemCodeId: entity.itemCodeId,
    barcode: entity.barcode,
    description: entity.description,
    brand: entity.brand,
    model: entity.model,
    serialNumber: entity.serialNumber,
    specification: entity.specification,
    poReference: entity.poReference,
    purchasedDate: entity.purchasedDate?.toIso8601String(),
    conditionId: entity.conditionId,
    projectId: entity.projectId,
    lastLocationName: entity.lastLocationName,
    quantity: entity.quantity,
    lastUpdate: entity.lastUpdate.microsecondsSinceEpoch,
  };

  @override
  ItemEntity buildModel(Map<String, dynamic> map) {
    final int createdMillis = map[lastUpdate] as int;
    return ItemEntity.fromJson({
      ...map,
      lastUpdate: DateTime.fromMicrosecondsSinceEpoch(createdMillis),
    });
  }

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $itemCodeId TEXT NOT NULL,
      $barcode TEXT,
      $description TEXT NOT NULL,
      $brand TEXT,
      $model TEXT,
      $serialNumber TEXT,
      $specification TEXT,
      $poReference TEXT,
      $purchasedDate TEXT,
      $conditionId TEXT NOT NULL,
      $projectId TEXT,
      $lastLocationName TEXT NOT NULL,
      $quantity REAL NOT NULL,
      $lastUpdate INTEGER NOT NULL
    )
  ''';
}
