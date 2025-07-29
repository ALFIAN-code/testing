import '../../data/models/base_list_request_model.dart';
import '../../data/models/on_project_item/on_project_item_paginated_model.dart';
import '../../data/models/on_project_item/scan_status_count_model.dart';
import '../../data/models/on_project_item/scanned_item_list_model.dart';
import '../../data/models/pagination_response_model.dart';
import '../../data/request/on_project_item/get_scanned_item_request.dart';

abstract class OnProjectItemRepository {
  Future<String> scanItem(String projectId, String barcode);
  Future<void> deleteRequest(String requestId);
  Future<void> cancelRequest(String requestId);
  Future<ScanStatusCountModel> getScanStatusCount(String projectId);
  Future<PaginationResponseModel<OnProjectItemPaginatedModel>> getList(BaseListRequestModel request);
  Future<List<ScannedItemListModel>> getScannedList(GetScannedItemListRequest request);
  Future<void> sync();
  Future<int> getNotSyncYet(String projectId);
}