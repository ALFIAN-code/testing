import 'package:uuid/uuid.dart';

import '../../core/exceptions/database_exception.dart';
import '../../domain/entities/return_item_scan_entity.dart';
import '../../domain/repositories/return_item_repository.dart';
import '../providers/local/interfaces/i_local_return_item_scan_provider.dart';
import '../providers/remote/interfaces/i_remote_return_item_provider.dart';

class ReturnItemRepositoryImpl implements ReturnItemRepository {

  final ILocalReturnItemScanProvider _localReturnItemScanProvider;
  final IRemoteReturnItemProvider _remoteReturnItemProvider;

  ReturnItemRepositoryImpl(this._localReturnItemScanProvider, this._remoteReturnItemProvider);

  @override
  Future<String> scanItem(String barcode) async {
    try {
      final ReturnItemScanEntity entity = ReturnItemScanEntity(
        id: const Uuid().v4(),
        itemBarcode: barcode,
      );

      await _localReturnItemScanProvider.insert(entity);

      return entity.id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelRequest(String requestId) async {
    try {
      final ReturnItemScanEntity? entity = await _localReturnItemScanProvider.getById(requestId);

      if (entity == null) throw DataNotFoundDatabaseException('Data sudah tersinkronisasi anda harus hapus melalui tabel');

      await _localReturnItemScanProvider.deleteBatch(<String>[requestId]);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> sync() async {
    try {
      final List<ReturnItemScanEntity> list = await _localReturnItemScanProvider.getAll();

      if (list.isEmpty) return;

      await _remoteReturnItemProvider.bulkScan(list.map((ReturnItemScanEntity e) => e.itemBarcode).toList());
      await _localReturnItemScanProvider.deleteBatch(list.map((ReturnItemScanEntity e) => e.id).toList());
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<int> getNotSyncYet() async {
    try {
      final List<ReturnItemScanEntity> result = await _localReturnItemScanProvider.getAll();
      return result.length;
    } catch(e) {
      rethrow;
    }
  }
}