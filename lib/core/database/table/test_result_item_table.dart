import '../../../domain/entities/test_result_item_entity.dart';
import '../../constants/database_constants.dart';
import 'base_database_table.dart';

class TestResultItemTable extends BaseDatabaseTable<TestResultItemEntity> {

  @override
  String get tableName => DatabaseConstants.testResultItemTable;

  String get code => 'code';
  String get itemId => 'itemId';
  String get scannedDate => 'scannedDate';

  @override
  String get rowId => 'id';

  @override
  Map<String, dynamic> buildMap(TestResultItemEntity model) => <String, dynamic>{
    rowId: null,
    code: model.code,
    itemId: model.itemId,
    scannedDate: model.scannedDate.toIso8601String()
  };

  @override
  TestResultItemEntity buildModel(Map<String, dynamic> map) => TestResultItemEntity.fromMap(map);

  @override
  String get createTableQuery => '''
    CREATE TABLE $tableName (
      $rowId INTEGER PRIMARY KEY AUTOINCREMENT,
      $code TEXT,
      $itemId TEXT,
      $scannedDate TEXT
    )
  ''';

}