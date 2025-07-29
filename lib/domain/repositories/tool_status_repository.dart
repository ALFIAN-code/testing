import '../../data/models/base_list_request_model.dart';
import '../../data/models/pagination_response_model.dart';
import '../../data/models/tools_status/tool_status_paginated_model.dart';

abstract class ToolStatusRepository {
  Future<PaginationResponseModel<ToolStatusPaginatedModel>> getList(BaseListRequestModel request);
}