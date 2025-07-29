import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_request/item_request_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ItemRequestRepository {
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getList(BaseListRequestModel request);
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getListByProject(String projectId, BaseListRequestModel request);
}