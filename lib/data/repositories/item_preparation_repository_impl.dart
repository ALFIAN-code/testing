import 'package:uuid/uuid.dart';

import '../../core/constants/condition_constants.dart';
import '../../core/exceptions/item_preparation_exception.dart';
import '../../domain/entities/condition_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/entities/item_preparation_scan_entity.dart';
import '../../domain/repositories/item_preparation_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_preparation/item_preparation_count_model.dart';
import '../models/item_preparation/item_preparation_detail_model.dart';
import '../models/item_preparation/item_preparation_summary_model.dart';
import '../models/pagination_response_model.dart';
import '../models/project/project_item_request_summary_pagination_model.dart';
import '../providers/local/interfaces/i_local_condition_provider.dart';
import '../providers/local/interfaces/i_local_item_preparation_scan_provider.dart';
import '../providers/local/interfaces/i_local_item_provider.dart';
import '../providers/remote/interfaces/i_remote_item_preparation_provider.dart';
import '../request/item_preparation/item_preparation_summary_request.dart';

class ItemPreparationRepositoryImpl implements ItemPreparationRepository {

  final ILocalConditionProvider _localConditionProvider;
  final ILocalItemProvider _localItemProvider;
  final ILocalItemPreparationScanProvider _localItemPreparationScanProvider;
  final IRemoteItemPreparationProvider remoteItemPreparationProvider;

  ItemPreparationRepositoryImpl(
      this._localConditionProvider,
      this._localItemProvider,
      this._localItemPreparationScanProvider,
      this.remoteItemPreparationProvider);

  @override
  Future<List<ItemPreparationDetailModel>> getDetailItem(String projectId, String itemCodeId) => remoteItemPreparationProvider.getDetailItem(projectId, itemCodeId);

  @override
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getList(BaseListRequestModel request) => remoteItemPreparationProvider.getList(request);

  @override
  Future<List<ItemPreparationSummaryModel>> getSummary(ItemPreparationSummaryRequest request) => remoteItemPreparationProvider.getSummary(request);

  @override
  Future<String> scanItem(String projectId, String barcode) async {
    try {
      final ItemEntity? item = await _localItemProvider.getByBarcode(barcode);

      if (item == null) throw ItemPreparationException('Data barang tidak ada');

      final ConditionEntity? condition = await _localConditionProvider.getById(item.conditionId);

      if (condition == null) throw ItemPreparationException('Data kondisi tidak ada');

      if (condition.code != ConditionConstants.good) throw ItemPreparationException('Kondisi barang tidak baik');

      final ItemPreparationScanEntity entity = ItemPreparationScanEntity(
        id: const Uuid().v4(),
        projectId: projectId,
        itemBarcode: barcode,
      );

      await _localItemPreparationScanProvider.insert(entity);

      return entity.id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRequest(String requestId) => remoteItemPreparationProvider.deleteRequest(requestId);

  @override
  Future<void> cancelRequest(String requestId) async {
    try {
      final ItemPreparationScanEntity? entity = await _localItemPreparationScanProvider.getById(requestId);

      if (entity == null) throw Exception('Data sudah tersinkronisasi anda harus hapus melalui tabel');

      await _localItemPreparationScanProvider.deleteBatch(<String>[requestId]);
    } catch(e) {
      throw Exception('Data sudah tersinkronisasi anda harus hapus melalui tabel');
    }
  }

  @override
  Future<ItemPreparationCountModel> getScanStatusCount(String projectId) => remoteItemPreparationProvider.getScanStatusCount(projectId);

  @override
  Future<int> getNotSyncYet(String projectId) async {
    int total = 0;

    try {
      final List<ItemPreparationScanEntity> list = await _localItemPreparationScanProvider.getAll(projectId: projectId);
      total = list.length;
      return total;
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> sync() async {
    try {
      final List<ItemPreparationScanEntity> list = await _localItemPreparationScanProvider.getAll();

      if (list.isEmpty) return;

      await remoteItemPreparationProvider.bulkScan(list.map((ItemPreparationScanEntity e) => e.toJson()).toList());
      await _localItemPreparationScanProvider.deleteBatch(list.map((ItemPreparationScanEntity e) => e.id).toList());
    } catch(e) {
      rethrow;
    }
  }
}