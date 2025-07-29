import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/return_item_scan_table.dart';
import '../../../../core/services/local_service/i_local_service.dart';
import '../../../../domain/entities/return_item_scan_entity.dart';
import '../interfaces/i_local_return_item_scan_provider.dart';

class LocalReturnItemScanProvider implements ILocalReturnItemScanProvider {

  final ILocalService _localService;
  static const String _tableName = DatabaseConstants.returnItemScanTable;

  LocalReturnItemScanProvider(this._localService);

  @override
  Future<void> deleteBatch(List<String> ids) => _localService.deleteBatch(_tableName, 'id', ids);

  @override
  Future<List<ReturnItemScanEntity>> getAll() async {
    try {
      const String query = 'SELECT * FROM $_tableName';
      final List<Map<String, dynamic>> list = await _localService.query(query);

      return ReturnItemScanTable().buildModels(list);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> insert(ReturnItemScanEntity entity) =>
      _localService.insert(_tableName, ReturnItemScanTable().buildMap(entity));

  @override
  Future<void> truncate() => _localService.truncate(_tableName);

  @override
  Future<ReturnItemScanEntity?> getById(String id) async {
    const String query = 'SELECT * FROM $_tableName WHERE id = ?';
    final List<Map<String, dynamic>> list = await _localService.query(query, [id]);
    return list.isNotEmpty ? ReturnItemScanTable().buildModels(list).first : null;
  }
}