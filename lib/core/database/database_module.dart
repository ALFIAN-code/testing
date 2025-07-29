import 'package:sqflite/sqflite.dart';

import '../constants/database_constants.dart';
import 'table/access_permission_table.dart';
import 'table/condition_category_table.dart';
import 'table/condition_table.dart';
import 'table/item_code_table.dart';
import 'table/item_preparation_scan_table.dart';
import 'table/item_table.dart';
import 'table/log_inspection_table.dart';
import 'table/on_project_item_scan_table.dart';
import 'table/prepare_return_item_scan_table.dart';
import 'table/return_item_scan_table.dart';
import 'table/test_result_item_table.dart';

Future<Database> provideDatabase() async {
  final String path = await getDatabasesPath();
  const String dbName = DatabaseConstants.name;

  return await openDatabase(
    '$path/$dbName',
    version: DatabaseConstants.version,
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
    onConfigure: (Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
  );
}

Future<void> _onCreate(Database db, int version) async {
  await _onCreateV1(db);
}

Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  // Upgrade logic here
}

Future<void> _onCreateV1(Database db) async {
  await db.execute(AccessPermissionTable().createTableQuery);
  await db.execute(TestResultItemTable().createTableQuery);
  await db.execute(ItemTable().createTableQuery);
  await db.execute(ItemCodeTable().createTableQuery);
  await db.execute(ConditionCategoryTable().createTableQuery);
  await db.execute(ConditionTable().createTableQuery);
  await db.execute(ItemPreparationScanTable().createTableQuery);
  await db.execute(OnProjectItemScanTable().createTableQuery);
  await db.execute(ReturnItemScanTable().createTableQuery);
  await db.execute(LogInspectionTable().createTableQuery);
  await db.execute(PrepareReturnItemScanTable().createTableQuery);
}
