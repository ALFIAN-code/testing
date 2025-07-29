import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/on_project_item_scan_table.dart';
import '../../../../core/database/table/prepare_return_item_scan_table.dart';
import '../../../../core/services/local_service/i_local_service.dart';
import '../../../../domain/entities/on_project_item_scan_entity.dart';
import '../../../../domain/entities/prepare_return_item_scan_entity.dart';
import '../interfaces/i_local_on_project_item_scan_provider.dart';
import '../interfaces/i_local_prepare_return_item_scan_provider.dart';

class LocalPrepareReturnItemScanProvider implements ILocalPrepareReturnItemScanProvider {

  final ILocalService _localService;
  static const String _tableName = DatabaseConstants.prepareReturnItemScanTable;

  LocalPrepareReturnItemScanProvider(this._localService);

  @override
  Future<void> deleteBatch(List<String> ids) => _localService.deleteBatch(_tableName, 'id', ids);

  @override
  Future<List<PrepareReturnItemScanEntity>> getAll({String? projectId}) async {
    String query = 'SELECT * FROM $_tableName';
    final List<String> arguments = <String>[];
    if (projectId != null) {
      query += ' WHERE projectId = ?';
      arguments.add(projectId);
    }
    final List<Map<String, dynamic>> list = await _localService.query(query, arguments);
    return PrepareReturnItemScanTable().buildModels(list);
  }

  @override
  Future<void> insert(PrepareReturnItemScanEntity entity) =>
      _localService.insert(_tableName, PrepareReturnItemScanTable().buildMap(entity));

  @override
  Future<void> truncate() => _localService.truncate(_tableName);

  @override
  Future<PrepareReturnItemScanEntity?> getById(String id) async {
    const String query = 'SELECT * FROM $_tableName WHERE id = ?';
    final List<Map<String, dynamic>> list = await _localService.query(query, [id]);
    return list.isNotEmpty ? PrepareReturnItemScanTable().buildModels(list).first : null;
  }
}