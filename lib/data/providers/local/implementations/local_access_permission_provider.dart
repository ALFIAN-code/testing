import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/access_permission_table.dart';
import '../../../../core/services/local_service/local_service.dart';
import '../../../../domain/entities/access_permission_entity.dart';
import '../interfaces/i_local_access_permission_provider.dart';

class LocalAccessPermissionProvider implements ILocalAccessPermissionProvider {

  final LocalService localService;

  final String _tableName = DatabaseConstants.accessPermissionTable;

  LocalAccessPermissionProvider({required this.localService});

  @override
  Future<List<AccessPermissionEntity>> getAll() async {
    try {
      final String query = 'SELECT * FROM $_tableName';
      final List<Map<String, dynamic>> list = await localService.query(query);

      return AccessPermissionTable().buildModels(list);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> insertRange(List<AccessPermissionEntity> entities) async {
    try {
      final List<Map<String, dynamic>> data = AccessPermissionTable().buildMaps(entities);
      await localService.insertBatch(_tableName, data);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() => localService.truncate(_tableName);
}