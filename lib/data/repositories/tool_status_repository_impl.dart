import '../../domain/repositories/tool_status_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/pagination_response_model.dart';
import '../models/tools_status/tool_status_paginated_model.dart';
import '../providers/remote/interfaces/i_remote_tool_status_provider.dart';

class ToolStatusRepositoryImpl implements ToolStatusRepository {

  final IRemoteToolStatusProvider remoteToolStatusProvider;

  ToolStatusRepositoryImpl(this.remoteToolStatusProvider);

  @override
  Future<PaginationResponseModel<ToolStatusPaginatedModel>> getList(BaseListRequestModel request) => remoteToolStatusProvider.getList(request);

}