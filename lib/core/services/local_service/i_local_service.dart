import 'package:sqflite/sqflite.dart';

abstract class ILocalService {
  Future<bool> isTableExist(String table);

  Future<void> deleteTable(String table);

  Future<void> deleteAllTable();

  Future<void> execute(String sql, [List<String>? arguments]);

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    ConflictAlgorithm? conflictAlgorithm,
  });

  Future<void> insertBatch(String table, List<Map<String, Object?>> list);
  Future<void> upsertBatch(String table, List<Map<String, Object?>> list);

  Future<void> deleteBatch(String table, String idFieldName, List<String> ids);

  Future<void> update(
    String table,
    Map<String, Object?> values, {
    List<String>? where,
    List<String>? whereArgs,
  });

  Future<void> delete(
    String table, {
    List<String>? where,
    List<String>? whereArgs,
  });

  Future<List<Map<String, Object?>>> query(
    String sql, [
    List<String>? arguments,
  ]);

  Future<void> truncate(String table);
}
