import '../../../models/base_list_request_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/tools_status/tool_status_paginated_model.dart';

abstract class IRemoteToolStatusProvider {
  Future<PaginationResponseModel<ToolStatusPaginatedModel>> getList(BaseListRequestModel request);
}