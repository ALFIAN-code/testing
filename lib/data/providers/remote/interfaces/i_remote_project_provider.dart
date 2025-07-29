import '../../../models/base_list_request_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/project/project_item_request_summary_pagination_model.dart';

abstract class IRemoteProjectProvider {
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getItemRequestSummary(BaseListRequestModel request);
}