import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/condition_category_table.dart';
import '../../../../core/services/local_service/local_service.dart';
import '../../../../domain/entities/condition_category_entity.dart';
import '../interfaces/i_local_condition_category_provider.dart';

class LocalConditionCategoryProvider implements ILocalConditionCategoryProvider {

  final LocalService localService;

  final String _tableName = DatabaseConstants.conditionCategoryTable;

  LocalConditionCategoryProvider(this.localService);

  @override
  Future<void> deleteAll() => localService.truncate(_tableName);

  @override
  Future<void> upsertBatch(List<ConditionCategoryEntity> entities) async {
    await localService.upsertBatch(_tableName, ConditionCategoryTable().buildMaps(entities));
  }

  @override
  Future<List<ConditionCategoryEntity>> getAll() async {
    try {
      final String query = 'SELECT * FROM $_tableName';
      final List<Map<String, dynamic>> list = await localService.query(query);

      return ConditionCategoryTable().buildModels(list);
    } catch(e) {
      rethrow;
    }
  }
}