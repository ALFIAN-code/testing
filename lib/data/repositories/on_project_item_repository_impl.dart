import 'package:uuid/uuid.dart';

import '../../core/exceptions/on_project_item_exception.dart';
import '../../domain/entities/item_preparation_scan_entity.dart';
import '../../domain/entities/on_project_item_scan_entity.dart';
import '../../domain/repositories/on_project_item_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/on_project_item/on_project_item_paginated_model.dart';
import '../models/on_project_item/scan_status_count_model.dart';
import '../models/on_project_item/scanned_item_list_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/local/interfaces/i_local_on_project_item_scan_provider.dart';
import '../providers/remote/interfaces/i_remote_on_project_item_provider.dart';
import '../request/on_project_item/get_scanned_item_request.dart';

class OnProjectItemRepositoryImpl implements OnProjectItemRepository {

  final ILocalOnProjectItemScanProvider _localOnProjectItemProvider;
  final IRemoteOnProjectItemProvider _remoteOnProjectItemProvider;

  OnProjectItemRepositoryImpl(this._localOnProjectItemProvider,this._remoteOnProjectItemProvider);

  @override
  Future<PaginationResponseModel<OnProjectItemPaginatedModel>> getList(BaseListRequestModel request) => _remoteOnProjectItemProvider.getList(request);

  @override
  Future<ScanStatusCountModel> getScanStatusCount(String projectId) => _remoteOnProjectItemProvider.getScanStatusCount(projectId);

  @override
  Future<String> scanItem(String projectId, String barcode) async {
    try {
      final OnProjectItemScanEntity entity = OnProjectItemScanEntity(
        id: const Uuid().v4(),
        projectId: projectId,
        itemBarcode: barcode,
      );

      await _localOnProjectItemProvider.insert(entity);

      return entity.id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRequest(String requestId) => _remoteOnProjectItemProvider.deleteRequest(requestId);

  @override
  Future<List<ScannedItemListModel>> getScannedList(GetScannedItemListRequest request) => _remoteOnProjectItemProvider.getScannedList(request);

  @override
  Future<void> cancelRequest(String requestId) async {
    try {
      final OnProjectItemScanEntity? entity = await _localOnProjectItemProvider.getById(requestId);

      if (entity == null) throw NoDatLocalOnProjectItemException('Data sudah tersinkronisasi anda harus hapus melalui tabel');

      await _localOnProjectItemProvider.deleteBatch(<String>[requestId]);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<int> getNotSyncYet(String projectId) async {
    int total = 0;

    try {
      final List<OnProjectItemScanEntity> list = await _localOnProjectItemProvider.getAll(projectId: projectId);
      total = list.length;
      return total;
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> sync() async {
    try {
      final List<OnProjectItemScanEntity> list = await _localOnProjectItemProvider.getAll();

      if (list.isEmpty) return;

      await _remoteOnProjectItemProvider.bulkScan(list.map((OnProjectItemScanEntity e) => e.toJson()).toList());
      await _localOnProjectItemProvider.deleteBatch(list.map((OnProjectItemScanEntity e) => e.id).toList());
    } catch(e) {
      rethrow;
    }
  }
}