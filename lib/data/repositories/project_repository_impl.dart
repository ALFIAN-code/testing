import '../../domain/repositories/project_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/pagination_response_model.dart';
import '../models/project/project_item_request_summary_pagination_model.dart';
import '../providers/remote/interfaces/i_remote_project_provider.dart';

class ProjectRepositoryImpl implements ProjectRepository {

  final IRemoteProjectProvider _remoteProjectProvider;

  ProjectRepositoryImpl(this._remoteProjectProvider);

  @override
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getItemRequestSummary(BaseListRequestModel request) => _remoteProjectProvider.getItemRequestSummary(request);
}