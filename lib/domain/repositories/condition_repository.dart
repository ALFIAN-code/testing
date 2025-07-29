import '../../data/models/base_list_request_model.dart';
import '../../data/models/condition/condition_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ConditionRepository {
  Future<PaginationResponseModel<ConditionPaginatedModel>> getList(BaseListRequestModel model);
  Future<List<ConditionPaginatedModel>> getListLocal();
  Future<void> sync();
}