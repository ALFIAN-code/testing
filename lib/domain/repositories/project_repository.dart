import '../../data/models/base_list_request_model.dart';
import '../../data/models/pagination_response_model.dart';
import '../../data/models/project/project_item_request_summary_pagination_model.dart';

abstract class ProjectRepository {
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getItemRequestSummary(BaseListRequestModel request);
}