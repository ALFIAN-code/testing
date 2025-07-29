import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_vendor_condition/item_vendor_condition_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ItemVendorConditionRepository {
  Future<PaginationResponseModel<ItemVendorConditionPaginatedModel>> getList(BaseListRequestModel model);
}