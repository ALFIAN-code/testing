import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_vendor_status/item_vendor_status_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ItemVendorStatusRepository {
  Future<PaginationResponseModel<ItemVendorStatusPaginatedModel>> getList(BaseListRequestModel model);
}