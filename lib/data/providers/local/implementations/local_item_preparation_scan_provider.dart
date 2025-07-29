import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/item_preparation_scan_table.dart';
import '../../../../core/services/local_service/i_local_service.dart';
import '../../../../domain/entities/item_preparation_scan_entity.dart';
import '../interfaces/i_local_item_preparation_scan_provider.dart';

class LocalItemPreparationScanProvider implements ILocalItemPreparationScanProvider {

  final ILocalService _localService;
  static const String _tableName = DatabaseConstants.itemPreparationScanTable;

  LocalItemPreparationScanProvider(this._localService);

  @override
  Future<void> deleteBatch(List<String> ids) => _localService.deleteBatch(_tableName, 'id', ids);

  @override
  Future<List<ItemPreparationScanEntity>> getAll({String? projectId}) async {
    String query = 'SELECT * FROM $_tableName';
    final List<String> arguments = <String>[];
    if (projectId != null) {
      query += ' WHERE projectId = ?';
      arguments.add(projectId);
    }
    final List<Map<String, dynamic>> list = await _localService.query(query, arguments);
    return ItemPreparationScanTable().buildModels(list);
  }

  @override
  Future<void> insert(ItemPreparationScanEntity entity) =>
      _localService.insert(_tableName, ItemPreparationScanTable().buildMap(entity));

  @override
  Future<void> truncate() => _localService.truncate(_tableName);

  @override
  Future<ItemPreparationScanEntity?> getById(String id) async {
    const String query = 'SELECT * FROM $_tableName WHERE id = ?';
    final List<Map<String, dynamic>> list = await _localService.query(query, [id]);
    return list.isNotEmpty ? ItemPreparationScanTable().buildModels(list).first : null;
  }
}