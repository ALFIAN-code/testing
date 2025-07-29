import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_vendor_reception/item_vendor_reception_item_paginated_model.dart';
import '../../data/models/item_vendor_reception/item_vendor_reception_model.dart';
import '../../data/models/item_vendor_reception/item_vendor_reception_paginated_model.dart';
import '../../data/models/item_vendor_reception/item_vendor_reception_param.dart';
import '../../data/models/pagination_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ItemVendorReceptionRepository {
  Future<PaginationResponseModel<ItemVendorReceptionPaginatedModel>> getList(BaseListRequestModel model);
  Future<ItemVendorReceptionModel> getDetail(String id);
  Future<PaginationResponseModel<ItemVendorReceptionItemPaginatedModel>> getListItem(String id, BaseListRequestModel model);
  Future<void> updateChecklist(String id, ItemVendorReceptionParam param);
}