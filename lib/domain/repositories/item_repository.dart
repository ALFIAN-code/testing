import '../../data/models/base_list_request_model.dart';
import '../../data/models/item/item_model.dart';
import '../../data/models/item/item_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';
import '../../data/request/item/create_item_request.dart';

abstract class ItemRepository {
  Future<PaginationResponseModel<ItemPaginatedModel>> getList(BaseListRequestModel model);
  Future<ItemModel> getDetailBarcode(String barcode);
  Future<ItemModel?> getDetailBarcodeLocal(String barcode);
  Future<ItemModel> getDetailById(String id);
  Future<void> updateCondition(String itemId, String conditionId);
  Future<void> update(String id, CreateItemRequest request);
  Future<void> sync();
}