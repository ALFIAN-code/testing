
import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ItemVendorChecklistRepository {
  Future<PaginationResponseModel<ItemVendorChecklistPaginatedModel>> getList(BaseListRequestModel model);
}