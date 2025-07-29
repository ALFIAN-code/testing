import '../../domain/repositories/item_request_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_request/item_request_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/interfaces/i_remote_item_request_provider.dart';

class ItemRequestRepositoryImpl implements ItemRequestRepository {

  final IRemoteItemRequestProvider _remoteItemRequestProvider;

  ItemRequestRepositoryImpl(this._remoteItemRequestProvider);

  @override
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getList(BaseListRequestModel request) => _remoteItemRequestProvider.getList(request);

  @override
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getListByProject(String projectId, BaseListRequestModel request) => _remoteItemRequestProvider.getListByProject(projectId, request);
}