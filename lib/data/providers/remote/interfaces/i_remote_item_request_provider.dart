import '../../../models/base_list_request_model.dart';
import '../../../models/item_request/item_request_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteItemRequestProvider {
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getList(BaseListRequestModel request);
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getListByProject(String projectId, BaseListRequestModel request);
}