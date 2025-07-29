import 'package:sqflite/sqflite.dart';

import 'i_local_service.dart';

class LocalService implements ILocalService {
  final Database _database;

  LocalService(this._database);

  @override
  Future<void> deleteAllTable() async {
    const String sql = """
      SELECT name FROM sqlite_master 
      WHERE type = 'table' 
      AND name NOT LIKE 'sqlite_%' 
      AND name NOT LIKE 'android_metadata'
    """;
    final List<Map<String, dynamic>> data = await query(sql);

    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        await deleteTable(data[i]['name'].toString());
      }
    }
  }

  @override
  Future<void> deleteTable(String table) => _database.execute('DROP TABLE $table;');

  @override
  Future<void> execute(String sql, [List<dynamic>? arguments]) => _database.execute(sql, arguments);

  @override
  Future<int> insert(String table, Map<String, Object?> values, {ConflictAlgorithm? conflictAlgorithm}) =>
      _database.insert(table, values, conflictAlgorithm: conflictAlgorithm);

  @override
  Future<void> insertBatch(String table, List<Map<String, Object?>> list) async {
    final Batch batch = _database.batch();

    for (Map<String, Object?> item in list) {
      batch.insert(table, item);
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> upsertBatch(String table, List<Map<String, Object?>> list) async {
    final Batch batch = _database.batch();

    for (Map<String, Object?> item in list) {
      batch.insert(table, item,conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> deleteBatch(String table, String idFieldName, List<String> ids) {
    final String placeholders = List.filled(ids.length, '?').join(', ');
    return _database.delete(
      table,
      where: '$idFieldName IN ($placeholders)',
      whereArgs: ids,
    );
  }


  @override
  Future<bool> isTableExist(String table) async {
    const String sql = """
      SELECT COUNT(*) AS result_count 
      FROM sqlite_master 
      WHERE type = 'table' AND name = ?
    """;

    final List<Map<String, dynamic>> result = await query(sql, <String>[table]);

    if (result.isNotEmpty && result[0]['result_count'] != 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> delete(String table, {List<String>? where, List<String>? whereArgs}) {
    String whereResult = '';
    where?.forEach((String element) => whereResult += element);

    return _database.delete(
      table,
      where: whereResult.trim(),
      whereArgs: whereArgs,
    );
  }

  @override
  Future<List<Map<String, Object?>>> query(String sql, [List<String>? arguments]) => _database.rawQuery(sql, arguments);

  @override
  Future<void> update(String table, Map<String, Object?> values,
      {List<String>? where, List<String>? whereArgs,}) {
    String whereResult = '';
    where?.forEach((String element) {
      whereResult += element;
    });

    return _database.update(
      table,
      values,
      where: whereResult.trim(),
      whereArgs: whereArgs,
    );
  }

  @override
  Future<void> truncate(String table) => _database.execute('DELETE FROM $table; VACUUM;');

}