import '../../../../domain/entities/project_active_info_entity.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/dashboard/item_request_unprocessed_model.dart';
import '../../../models/dashboard/item_statistic_model.dart';
import '../../../models/dashboard/item_test_info_model.dart';
import '../../../models/dashboard/item_test_pagination_model.dart';
import '../../../models/dashboard/item_vendor_arrival_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/project/project_pagination_model.dart';

abstract class IRemoteDashboardProvider {
  Future<ItemStatisticModel> getItemStatistics();
  Future<ItemRequestUnprocessedModel> getItemRequestUnprocessed();
  Future<PaginationResponseModel<ProjectPaginatedModel>> getProjectActive(BaseListRequestModel request);
  Future<ItemTestInfoModel> getItemTestInfo();
  Future<PaginationResponseModel<ItemTestPaginationModel>> getItemTestPagination(BaseListRequestModel request);
  Future<ProjectActiveInfoEntity> getProjectActiveInfo();
  Future<PaginationResponseModel<ItemVendorArrivalModel>> getItemVendorArrivalPagination(BaseListRequestModel request);
}