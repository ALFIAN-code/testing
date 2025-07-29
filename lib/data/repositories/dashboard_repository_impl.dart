import '../../domain/entities/project_active_info_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/base_list_request_model.dart';
import '../models/dashboard/item_request_unprocessed_model.dart';
import '../models/dashboard/item_statistic_model.dart';
import '../models/dashboard/item_test_info_model.dart';
import '../models/dashboard/item_test_pagination_model.dart';
import '../models/dashboard/item_vendor_arrival_model.dart';
import '../models/pagination_response_model.dart';
import '../models/project/project_pagination_model.dart';
import '../providers/remote/interfaces/i_remote_dashboard_provider.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final IRemoteDashboardProvider _remoteDashboardProvider;

  DashboardRepositoryImpl(this._remoteDashboardProvider);

  @override
  Future<ItemStatisticModel> getItemStatistic() => _remoteDashboardProvider.getItemStatistics();

  @override
  Future<ItemRequestUnprocessedModel> getItemRequestUnprocessed() => _remoteDashboardProvider.getItemRequestUnprocessed();

  @override
  Future<PaginationResponseModel<ProjectPaginatedModel>> getProjectActive(BaseListRequestModel request) => _remoteDashboardProvider.getProjectActive(request);

  @override
  Future<ItemTestInfoModel> getItemTestInfo() => _remoteDashboardProvider.getItemTestInfo();
  
  @override
  Future<ProjectActiveInfoEntity> getProjectActiveInfo() => _remoteDashboardProvider.getProjectActiveInfo();

  @override
  Future<PaginationResponseModel<ItemTestPaginationModel>> getItemTestPagination(BaseListRequestModel request) => _remoteDashboardProvider.getItemTestPagination(request);

  @override
  Future<PaginationResponseModel<ItemVendorArrivalModel>> getItemVendorArrivalPagination(BaseListRequestModel request) => _remoteDashboardProvider.getItemVendorArrivalPagination(request);
}