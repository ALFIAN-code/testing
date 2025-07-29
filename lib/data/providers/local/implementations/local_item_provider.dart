import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/item_table.dart';
import '../../../../core/services/local_service/local_service.dart';
import '../../../../domain/entities/item_entity.dart';
import '../interfaces/i_local_item_provider.dart';

class LocalItemProvider implements ILocalItemProvider {

  final LocalService localService;

  final String _tableName = DatabaseConstants.itemTable;

  LocalItemProvider(this.localService);

  @override
  Future<void> upsertBatch(List<ItemEntity> entities) async {
    await localService.upsertBatch(_tableName, ItemTable().buildMaps(entities));
  }

  @override
  Future<ItemEntity?> getLatest() async {
    final String sql = 'SELECT * FROM $_tableName ORDER BY lastUpdate DESC LIMIT 1';
    final List<Map<String, Object?>> result = await localService.query(sql,<String>[]);
    if (result.isNotEmpty) {
      return ItemTable().buildModel(result.first);
    }

    return null;
  }

  @override
  Future<void> deleteAll() => localService.truncate(_tableName);

  @override
  Future<ItemEntity?> getByBarcode(String barcode) async {
    final String sql = 'SELECT * FROM $_tableName WHERE barcode = ? LIMIT 1';
    final List<Map<String, Object?>> result = await localService.query(sql, <String>[barcode]);
    if (result.isNotEmpty) {
      return ItemTable().buildModel(result.first);
    }
    return null;
  }
}