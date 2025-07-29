import '../../data/models/base_list_request_model.dart';
import '../../data/models/item_preparation/item_preparation_count_model.dart';
import '../../data/models/item_preparation/item_preparation_detail_model.dart';
import '../../data/models/item_preparation/item_preparation_summary_model.dart';
import '../../data/models/on_project_item/scan_status_count_model.dart';
import '../../data/models/pagination_response_model.dart';
import '../../data/models/project/project_item_request_summary_pagination_model.dart';
import '../../data/request/item_preparation/item_preparation_summary_request.dart';

abstract class ItemPreparationRepository {
  Future<String> scanItem(String projectId, String barcode);
  Future<void> deleteRequest(String requestId);
  Future<void> cancelRequest(String requestId);
  Future<ItemPreparationCountModel> getScanStatusCount(String projectId);
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getList(BaseListRequestModel request);
  Future<List<ItemPreparationSummaryModel>> getSummary(ItemPreparationSummaryRequest request);
  Future<void> sync();
  Future<List<ItemPreparationDetailModel>> getDetailItem(String projectId, String itemCodeId);
  Future<int> getNotSyncYet(String projectId);
}