import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_request_item_scan/item_request_item_scan_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ItemRequestItemScanRepository {
  Future<PaginationResponseModel<ItemRequestItemScanPaginatedModel>> getList(BaseListRequestModel request);
}