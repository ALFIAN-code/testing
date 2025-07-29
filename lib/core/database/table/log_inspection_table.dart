import '../../../domain/entities/log_inspection_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class LogInspectionTable extends BaseDatabaseTable<LogInspectionEntity> {
  @override
  String get tableName => DatabaseConstants.logInspectionTable;

  String get id => 'id';
  String get itemId => 'itemId';

  @override
  String get rowId => id;

  @override
  Map<String, dynamic> buildMap(LogInspectionEntity entity) => {
    id: entity.id,
    itemId: entity.itemId,
  };

  @override
  LogInspectionEntity buildModel(Map<String, dynamic> map) => LogInspectionEntity.fromJson(map);

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $id TEXT PRIMARY KEY,
      $itemId TEXT NOT NULL
    )
  ''';
}
