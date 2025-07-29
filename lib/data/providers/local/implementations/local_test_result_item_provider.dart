import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/test_result_item_table.dart';
import '../../../../core/services/local_service/local_service.dart';
import '../../../../domain/entities/test_result_item_entity.dart';
import '../interfaces/i_local_test_result_item_provider.dart';

class LocalTestResultItemProvider implements ILocalTestResultItemProvider {

  final LocalService localService;

  LocalTestResultItemProvider(this.localService);

  final String _tableName = DatabaseConstants.testResultItemTable;

  @override
  Future<void> deleteAll() => localService.truncate(_tableName);

  @override
  Future<List<TestResultItemEntity>> getAll(List<String> itemIds) async {
    try {

      final String placeholders = List.filled(itemIds.length, '?').join(', ');
      final String sql = 'SELECT * FROM $_tableName WHERE itemId IN ($placeholders)';

      final List<Map<String, Object?>> result = await localService.query(sql, itemIds);

      return TestResultItemTable().buildModels(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> insert(TestResultItemEntity entity) async {
    try {
      final Map<String, dynamic> data = TestResultItemTable().buildMap(entity);
      await localService.insert(_tableName, data);
    } catch(e) {
      rethrow;
    }
  }
}