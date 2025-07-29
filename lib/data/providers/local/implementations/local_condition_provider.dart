import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/condition_table.dart';
import '../../../../core/services/local_service/local_service.dart';
import '../../../../domain/entities/condition_entity.dart';
import '../interfaces/i_local_condition_provider.dart';

class LocalConditionProvider implements ILocalConditionProvider {

  final LocalService localService;

  final String _tableName = DatabaseConstants.conditionTable;

  LocalConditionProvider(this.localService);

  @override
  Future<void> deleteAll() => localService.truncate(_tableName);

  @override
  Future<void> upsertBatch(List<ConditionEntity> entities) async {
    await localService.upsertBatch(_tableName, ConditionTable().buildMaps(entities));
  }

  @override
  Future<ConditionEntity?> getById(String id) async {
    final String sql = '''
    SELECT 
      c.id AS id,
      c.name AS name,
      c.code AS code,
      c.conditionCategoryId AS conditionCategoryId,
      cc.id AS cc_id,
      cc.name AS cc_name,
      cc.code AS cc_code
    FROM $_tableName c
    LEFT JOIN condition_category cc ON c.conditionCategoryId = cc.id
    WHERE c.id = ?
    LIMIT 1
  ''';

    final List<Map<String, dynamic>> result = await localService.query(sql, <String>[id]);

    if (result.isNotEmpty) {
      return ConditionEntity.fromJoinRow(result.first);
    }
    return null;
  }


  @override
  Future<List<ConditionEntity>> getAll() async {
    try {
      final String query = 'SELECT * FROM $_tableName';
      final List<Map<String, dynamic>> list = await localService.query(query);

      return ConditionTable().buildModels(list);
    } catch(e) {
      rethrow;
    }
  }
  @override
  Future<List<ConditionEntity>> getAllWithCategory() async {
    try {
      final String query = '''
      SELECT 
        c.id AS id,
        c.name AS name,
        c.code AS code,
        c.conditionCategoryId AS conditionCategoryId,
        cc.id AS cc_id,
        cc.name AS cc_name,
        cc.code AS cc_code
      FROM $_tableName c
      LEFT JOIN condition_category cc ON c.conditionCategoryId = cc.id
    ''';

      final List<Map<String, dynamic>> result = await localService.query(query);

      return result.map((Map<String, dynamic> row) => ConditionEntity.fromJoinRow(row)).toList();
    } catch (e) {
      rethrow;
    }
  }

}