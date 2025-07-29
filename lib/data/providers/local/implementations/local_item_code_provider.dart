import '../../../../core/constants/database_constants.dart';
import '../../../../core/database/table/item_code_table.dart';
import '../../../../core/services/local_service/local_service.dart';
import '../../../../domain/entities/item_code_entity.dart';
import '../interfaces/i_local_item_code_provider.dart';

class LocalItemCodeProvider implements ILocalItemCodeProvider {

  final LocalService localService;

  final String _tableName = DatabaseConstants.itemCodeTable;

  LocalItemCodeProvider(this.localService);

  @override
  Future<void> upsertBatch(List<ItemCodeEntity> entities) async {
    await localService.upsertBatch(_tableName, ItemCodeTable().buildMaps(entities));
  }

  @override
  Future<ItemCodeEntity?> getLatest() async {
    final String sql = 'SELECT * FROM $_tableName ORDER BY lastUpdate DESC LIMIT 1';
    final List<Map<String, Object?>> result = await localService.query(sql,<String>[]);
    if (result.isNotEmpty) {
      return ItemCodeTable().buildModel(result.first);
    }

    return null;
  }

  @override
  Future<void> deleteAll() => localService.truncate(_tableName);

  @override
  Future<ItemCodeEntity?> getById(String id) async {
    final String sql = 'SELECT * FROM $_tableName WHERE id = ?';
    final List<Map<String, Object?>> result = await localService.query(sql, <String>[id]);
    if (result.isNotEmpty) {
      return ItemCodeTable().buildModel(result.first);
    }
    return null;
  }
}