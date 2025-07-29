import '../../../models/base_list_request_model.dart';
import '../../../models/item_preparation/item_preparation_count_model.dart';
import '../../../models/item_preparation/item_preparation_detail_model.dart';
import '../../../models/item_preparation/item_preparation_summary_model.dart';
import '../../../models/on_project_item/scan_status_count_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/project/project_item_request_summary_pagination_model.dart';
import '../../../request/item_preparation/item_preparation_summary_request.dart';

abstract class IRemoteItemPreparationProvider {
  Future<String> scanItem(String projectId, String barcode);
  Future<void> deleteRequest(String requestId);
  Future<ItemPreparationCountModel> getScanStatusCount(String projectId);
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getList(BaseListRequestModel request);
  Future<List<ItemPreparationSummaryModel>> getSummary(ItemPreparationSummaryRequest request);
  Future<List<ItemPreparationDetailModel>> getDetailItem(String projectId, String itemCodeId);
  Future<void> bulkScan(List<Map<String, dynamic>> listRequest);

}