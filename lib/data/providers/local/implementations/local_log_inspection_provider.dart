import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/log_inspection_table.dart';
import '../../../../core/services/local_service/i_local_service.dart';
import '../../../../domain/entities/log_inspection_entity.dart';
import '../interfaces/i_local_log_inspection_provider.dart';

class LocalLogInspectionProvider implements ILocalLogInspectionProvider {

  final ILocalService _localService;
  static const String _tableName = DatabaseConstants.logInspectionTable;

  LocalLogInspectionProvider(this._localService);

  @override
  Future<void> deleteBatch(List<String> ids) => _localService.deleteBatch(_tableName, 'id', ids);

  @override
  Future<List<LogInspectionEntity>> getAll() async {
    const String query = 'SELECT * FROM $_tableName';
    final List<Map<String, dynamic>> list = await _localService.query(query);
    return LogInspectionTable().buildModels(list);
  }

  @override
  Future<void> insert(LogInspectionEntity entity) =>
      _localService.insert(_tableName, LogInspectionTable().buildMap(entity));

  @override
  Future<void> truncate() => _localService.truncate(_tableName);

  @override
  Future<LogInspectionEntity?> getById(String id) async {
    const String query = 'SELECT * FROM $_tableName WHERE id = ?';
    final List<Map<String, dynamic>> list = await _localService.query(query, [id]);
    return list.isNotEmpty ? LogInspectionTable().buildModels(list).first : null;
  }
}