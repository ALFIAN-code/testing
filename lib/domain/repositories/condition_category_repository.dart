import '../../data/models/base_list_request_model.dart';
import '../../data/models/condition/condition_paginated_model.dart';
import '../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../data/models/pagination_response_model.dart';

abstract class ConditionCategoryRepository {
  Future<PaginationResponseModel<ConditionCategoryPaginatedModel>> getList(BaseListRequestModel model);
  Future<List<ConditionCategoryPaginatedModel>> getListLocal();
  Future<void> sync();
}