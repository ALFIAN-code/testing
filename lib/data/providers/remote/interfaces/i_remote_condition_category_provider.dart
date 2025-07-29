import '../../../models/base_list_request_model.dart';
import '../../../models/condition_category/condition_category_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteConditionCategoryProvider {
  Future<PaginationResponseModel<ConditionCategoryPaginatedModel>> getList(BaseListRequestModel model);
}