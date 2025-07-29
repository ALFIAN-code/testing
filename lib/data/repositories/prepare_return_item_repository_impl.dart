import 'package:uuid/uuid.dart';

import '../../core/exceptions/database_exception.dart';
import '../../domain/entities/prepare_return_item_scan_entity.dart';
import '../../domain/repositories/prepare_return_item_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/prepare_return_item/scan_status_count_model.dart';
import '../models/on_project_item/scanned_item_list_model.dart';
import '../models/pagination_response_model.dart';
import '../models/prepare_return_item/prepare_return_item_paginated_model.dart';
import '../providers/local/interfaces/i_local_prepare_return_item_scan_provider.dart';
import '../providers/remote/interfaces/i_remote_prepare_return_item_provider.dart';
import '../request/on_project_item/get_scanned_item_request.dart';

class PrepareReturnItemRepositoryImpl implements PrepareReturnItemRepository {

  final ILocalPrepareReturnItemScanProvider _localPrepareReturnItemProvider;
  final IRemotePrepareReturnItemProvider _remotePrepareReturnItemProvider;

  PrepareReturnItemRepositoryImpl(this._localPrepareReturnItemProvider,this._remotePrepareReturnItemProvider);

  @override
  Future<PaginationResponseModel<PrepareReturnItemPaginatedModel>> getList(BaseListRequestModel request) => _remotePrepareReturnItemProvider.getList(request);

  @override
  Future<ScanStatusCountModel> getScanStatusCount(String projectId) => _remotePrepareReturnItemProvider.getScanStatusCount(projectId);

  @override
  Future<String> scanItem(String projectId, String barcode) async {
    try {
      final PrepareReturnItemScanEntity entity = PrepareReturnItemScanEntity(
        id: const Uuid().v4(),
        projectId: projectId,
        itemBarcode: barcode,
      );

      await _localPrepareReturnItemProvider.insert(entity);

      return entity.id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRequest(String requestId) => _remotePrepareReturnItemProvider.deleteRequest(requestId);

  @override
  Future<List<ScannedItemListModel>> getScannedList(GetScannedItemListRequest request) => _remotePrepareReturnItemProvider.getScannedList(request);

  @override
  Future<void> cancelRequest(String requestId) async {
    try {
      final PrepareReturnItemScanEntity? entity = await _localPrepareReturnItemProvider.getById(requestId);

      if (entity == null) throw DataNotFoundDatabaseException('Data sudah tersinkronisasi anda harus hapus melalui tabel');

      await _localPrepareReturnItemProvider.deleteBatch(<String>[requestId]);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<int> getNotSyncYet(String projectId) async {
    int total = 0;

    try {
      final List<PrepareReturnItemScanEntity> list = await _localPrepareReturnItemProvider.getAll(projectId: projectId);
      total = list.length;
      return total;
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> sync() async {
    try {
      final List<PrepareReturnItemScanEntity> list = await _localPrepareReturnItemProvider.getAll();

      if (list.isEmpty) return;

      await _remotePrepareReturnItemProvider.bulkScan(list.map((PrepareReturnItemScanEntity e) => e.toJson()).toList());
      await _localPrepareReturnItemProvider.deleteBatch(list.map((PrepareReturnItemScanEntity e) => e.id).toList());
    } catch(e) {
      rethrow;
    }
  }
}