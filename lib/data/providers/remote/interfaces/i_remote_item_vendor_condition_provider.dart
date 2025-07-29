import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_condition/item_vendor_condition_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteItemVendorConditionProvider {
  Future<PaginationResponseModel<ItemVendorConditionPaginatedModel>> getList(BaseListRequestModel model);
}