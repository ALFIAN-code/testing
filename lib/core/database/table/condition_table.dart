import '../../../domain/entities/condition_entity.dart';
import 'base_database_table.dart';

class ConditionTable extends BaseDatabaseTable<ConditionEntity> {
  @override
  String get tableName => 'condition';

  String get id => 'id';
  String get name => 'name';
  String get code => 'code';
  String get conditionCategoryId => 'conditionCategoryId';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(ConditionEntity entity) => {
    id: entity.id,
    name: entity.name,
    code: entity.code,
    conditionCategoryId: entity.conditionCategoryId,
  };

  @override
  ConditionEntity buildModel(Map<String, dynamic> map) => ConditionEntity.fromJson(map);

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $name TEXT NOT NULL,
      $code TEXT NOT NULL,
      $conditionCategoryId TEXT NOT NULL,
      FOREIGN KEY($conditionCategoryId) REFERENCES condition_category(id) ON DELETE CASCADE
    )
  ''';
}
