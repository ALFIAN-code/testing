import '../../../models/base_list_request_model.dart';
import '../../../models/condition/condition_paginated_model.dart';
import '../../../models/pagination_response_model.dart';

abstract class IRemoteConditionProvider {
  Future<PaginationResponseModel<ConditionPaginatedModel>> getList(BaseListRequestModel model);
}