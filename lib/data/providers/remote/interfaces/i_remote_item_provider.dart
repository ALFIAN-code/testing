import '../../../models/base_list_request_model.dart';
import '../../../models/item/item_model.dart';
import '../../../models/item/item_paginated_model.dart';
import '../../../models/item/item_sync_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../request/item/create_item_request.dart';

abstract class IRemoteItemProvider {
  Future<PaginationResponseModel<ItemPaginatedModel>> getList(BaseListRequestModel model);
  Future<ItemModel> getDetailBarcode(String barcode);
  Future<ItemModel> getDetailById(String id);
  Future<void> updateCondition(String itemId, String conditionId);
  Future<void> update(String id, CreateItemRequest request);
  Future<PaginationResponseModel<ItemSyncPaginatedModel>> sync(String? id, String? lastUpdate);
}