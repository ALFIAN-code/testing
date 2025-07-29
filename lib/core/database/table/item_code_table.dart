import '../../../domain/entities/item_code_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class ItemCodeTable extends BaseDatabaseTable<ItemCodeEntity> {
  @override
  String get tableName => DatabaseConstants.itemCodeTable;

  String get id => 'id';
  String get name => 'name';
  String get code => 'code';
  String get description => 'description';
  String get itemCodeCategoryId => 'itemCodeCategoryId';
  String get coaId => 'coaId';
  String get itemClassificationId => 'itemClassificationId';
  String get rackCode => 'rackCode';
  String get lastUpdate => 'lastUpdate';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(ItemCodeEntity entity) => {
    id: entity.id,
    name: entity.name,
    code: entity.code,
    description: entity.description,
    itemCodeCategoryId: entity.itemCodeCategoryId,
    coaId: entity.coaId,
    itemClassificationId: entity.itemClassificationId,
    rackCode: entity.rackCode,
    lastUpdate: entity.lastUpdate.millisecondsSinceEpoch,
  };

  @override
  ItemCodeEntity buildModel(Map<String, dynamic> map) {
    final int lastUpdateMillis = map[lastUpdate] as int;
    return ItemCodeEntity.fromJson({
      ...map,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis),
    });
  }

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $name TEXT NOT NULL,
      $code TEXT NOT NULL,
      $description TEXT NOT NULL,
      $itemCodeCategoryId TEXT NOT NULL,
      $coaId TEXT NOT NULL,
      $itemClassificationId TEXT NOT NULL,
      $rackCode TEXT NOT NULL,
      $lastUpdate INTEGER NOT NULL
    )
  ''';
}
