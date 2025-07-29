import '../../data/models/base_list_request_model.dart';
import '../../data/models/dashboard/item_request_unprocessed_model.dart';
import '../../data/models/dashboard/item_statistic_model.dart';
import '../../data/models/dashboard/item_test_info_model.dart';
import '../../data/models/dashboard/item_test_pagination_model.dart';
import '../../data/models/dashboard/item_vendor_arrival_model.dart';
import '../../data/models/pagination_response_model.dart';
import '../../data/models/project/project_pagination_model.dart';
import '../entities/project_active_info_entity.dart';

abstract class DashboardRepository {
  Future<ItemStatisticModel> getItemStatistic();
  Future<ItemRequestUnprocessedModel> getItemRequestUnprocessed();
  Future<PaginationResponseModel<ProjectPaginatedModel>> getProjectActive(BaseListRequestModel request);
  Future<ItemTestInfoModel> getItemTestInfo();
  Future<ProjectActiveInfoEntity> getProjectActiveInfo();
  Future<PaginationResponseModel<ItemTestPaginationModel>> getItemTestPagination(BaseListRequestModel request);
  Future<PaginationResponseModel<ItemVendorArrivalModel>> getItemVendorArrivalPagination(BaseListRequestModel request);
}
