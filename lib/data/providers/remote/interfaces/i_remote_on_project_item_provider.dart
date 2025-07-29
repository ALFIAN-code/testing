import '../../../models/base_list_request_model.dart';
import '../../../models/on_project_item/on_project_item_paginated_model.dart';
import '../../../models/on_project_item/scan_status_count_model.dart';
import '../../../models/on_project_item/scanned_item_list_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../request/on_project_item/get_scanned_item_request.dart';

abstract class IRemoteOnProjectItemProvider {
  Future<PaginationResponseModel<OnProjectItemPaginatedModel>> getList(BaseListRequestModel request);
  Future<String> scanItem(String projectId, String barcode);
  Future<void> deleteRequest(String requestId);
  Future<ScanStatusCountModel> getScanStatusCount(String projectId);
  Future<List<ScannedItemListModel>> getScannedList(GetScannedItemListRequest request);
  Future<void> bulkScan(List<Map<String, dynamic>> listRequest);
}