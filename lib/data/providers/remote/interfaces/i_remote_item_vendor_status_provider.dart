import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_status/item_vendor_status_paginated_model.dart';
import '../../../models/pagination_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteItemVendorStatusProvider {
  Future<PaginationResponseModel<ItemVendorStatusPaginatedModel>> getList(BaseListRequestModel model);
}