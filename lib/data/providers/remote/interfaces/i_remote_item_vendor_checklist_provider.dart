import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteItemVendorChecklistProvider {
  Future<PaginationResponseModel<ItemVendorChecklistPaginatedModel>> getList(BaseListRequestModel model);
}
