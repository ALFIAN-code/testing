import '../../../domain/entities/condition_category_entity.dart';
import 'base_database_table.dart';

class ConditionCategoryTable extends BaseDatabaseTable<ConditionCategoryEntity> {
  @override
  String get tableName => 'condition_category';

  String get id => 'id';
  String get name => 'name';
  String get code => 'code';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(ConditionCategoryEntity entity) => {
    id: entity.id,
    name: entity.name,
    code: entity.code,
  };

  @override
  ConditionCategoryEntity buildModel(Map<String, dynamic> map) => ConditionCategoryEntity.fromJson(map);

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $name TEXT NOT NULL,
      $code TEXT NOT NULL
    )
  ''';
}
