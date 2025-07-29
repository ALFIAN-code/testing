import '../../domain/repositories/item_request_item_scan_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/item_request_item_scan/item_request_item_scan_paginated_model.dart';
import '../models/pagination_response_model.dart';
import '../providers/remote/interfaces/i_remote_item_request_item_scan_provider.dart';

class ItemRequestItemScanRepositoryImpl implements ItemRequestItemScanRepository {

  final IRemoteItemRequestItemScanProvider _remoteItemRequestItemScanProvider;

  ItemRequestItemScanRepositoryImpl(this._remoteItemRequestItemScanProvider);

  @override
  Future<PaginationResponseModel<ItemRequestItemScanPaginatedModel>> getList(BaseListRequestModel request) =>
      _remoteItemRequestItemScanProvider.getList(request);
}