
import '../../domain/entities/condition_entity.dart';
import '../../domain/entities/item_code_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/item_repository.dart';
import '../mappers/condition_mapper.dart';
import '../models/base_list_request_model.dart';
import '../models/item/item_model.dart';
import '../models/item/item_paginated_model.dart';
import '../models/item/item_sync_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/local/interfaces/i_local_condition_provider.dart';
import '../providers/local/interfaces/i_local_item_code_provider.dart';
import '../providers/local/interfaces/i_local_item_provider.dart';
import '../providers/remote/interfaces/i_remote_item_provider.dart';
import '../request/item/create_item_request.dart';

class ItemRepositoryImpl implements ItemRepository {

  final ILocalConditionProvider _localConditionProvider;
  final ILocalItemCodeProvider _localItemCodeProvider;
  final ILocalItemProvider localItemProvider;
  final IRemoteItemProvider remoteItemProvider;

  ItemRepositoryImpl(
    this._localConditionProvider,
    this._localItemCodeProvider,
    this.localItemProvider,
    this.remoteItemProvider,
  );

  @override
  Future<PaginationResponseModel<ItemPaginatedModel>> getList(BaseListRequestModel model) => remoteItemProvider.getList(model);

  @override
  Future<ItemModel> getDetailBarcode(String barcode) async {
    try {
      final ItemEntity? localResult = await localItemProvider.getByBarcode(barcode);
      if (localResult != null) {
        final ConditionEntity? conditionEntity = await _localConditionProvider.getById(localResult.conditionId);
        final ItemCodeEntity? itemCodeEntity = await _localItemCodeProvider.getById(localResult.itemCodeId);
        return localResult.toModel(condition: conditionEntity?.toModel(), itemCode: itemCodeEntity?.toModel());
      } else {
        final ItemModel remoteResult = await remoteItemProvider.getDetailBarcode(barcode);
        return remoteResult;
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ItemModel?> getDetailBarcodeLocal(String barcode) async {
    try {
      final ItemEntity? localResult = await localItemProvider.getByBarcode(barcode);
      if (localResult != null) {
        final ConditionEntity? conditionEntity = await _localConditionProvider.getById(localResult.conditionId);
        final ItemCodeEntity? itemCodeEntity = await _localItemCodeProvider.getById(localResult.itemCodeId);
        return localResult.toModel(condition: conditionEntity?.toModel(), itemCode: itemCodeEntity?.toModel());
      }

      return null;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> updateCondition(String itemId, String conditionId) => remoteItemProvider.updateCondition(itemId, conditionId);

  @override
  Future<ItemModel> getDetailById(String id) => remoteItemProvider.getDetailById(id);

  @override
  Future<void> update(String id, CreateItemRequest request) => remoteItemProvider.update(id, request);

  @override
  Future<void> sync() async {
    try {
      final ItemEntity? lastEntity = await localItemProvider.getLatest();
      final String date = lastEntity?.lastUpdate != null
          ? lastEntity!.lastUpdate.toUtc().toIso8601String()
          : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toIso8601String();

      final PaginationResponseModel<ItemSyncPaginatedModel> result = await remoteItemProvider.sync(lastEntity?.id, date);
      if (result.items.isNotEmpty) {
        final List<ItemEntity> entities = result.items.map((ItemSyncPaginatedModel e) => e.toEntity()).toList();
        await localItemProvider.upsertBatch(entities);
      }
    }catch(e) {
      rethrow;
    }
  }

}