import '../../../models/base_list_request_model.dart';
import '../../../models/item_request_item_scan/item_request_item_scan_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteItemRequestItemScanProvider {
  Future<PaginationResponseModel<ItemRequestItemScanPaginatedModel>> getList(BaseListRequestModel request);
}