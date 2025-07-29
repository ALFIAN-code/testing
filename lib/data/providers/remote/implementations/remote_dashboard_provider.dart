import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../../domain/entities/project_active_info_entity.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/dashboard/item_request_unprocessed_model.dart';
import '../../../models/dashboard/item_statistic_model.dart';
import '../../../models/dashboard/item_test_info_model.dart';
import '../../../models/dashboard/item_test_pagination_model.dart';
import '../../../models/dashboard/item_vendor_arrival_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/project/project_pagination_model.dart';
import '../interfaces/i_remote_dashboard_provider.dart';

class RemoteDashboardProvider implements IRemoteDashboardProvider {
  final DioClient _dioClient;

  RemoteDashboardProvider(this._dioClient);

  @override
  Future<ItemStatisticModel> getItemStatistics() async {
    try {
      final Response<dynamic> result = await _dioClient.get(
        EndpointConstants.getItemStatisticsDashboard,
      );
      final Map<String, dynamic>? data = _dioClient.getResponseData(
        result.data,
      );

      if (data != null) {
        return ItemStatisticModel.fromJson(data);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ItemRequestUnprocessedModel> getItemRequestUnprocessed() async {
    try {
      final Response<dynamic> result = await _dioClient.get(
        EndpointConstants.getItemRequestUnprocessedDashboard,
      );
      final Map<String, dynamic>? data = _dioClient.getResponseData(
        result.data,
      );

      if (data != null) {
        return ItemRequestUnprocessedModel.fromJson(data);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ItemTestInfoModel> getItemTestInfo() async {
    try {
      final Response<dynamic> result = await _dioClient.get(
        EndpointConstants.itemTestInfo,
      );
      final Map<String, dynamic>? data = _dioClient.getResponseData(
        result.data,
      );

      print('getItemTestInfo: $data');
      print('getItemTestInfo: ${data != null}');
      if (data == null) {
        throw const FormatException('Invalid response format from server');
      }
      return ItemTestInfoModel.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<PaginationResponseModel<ProjectPaginatedModel>> getProjectActive(
    BaseListRequestModel request,
  ) async {
    try {
      request = request.copyWith(
        sort: <SortRequestModel>[
          SortRequestModel(field: 'endDate', direction: 'asc'),
        ],
      );

      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.projectActiveDashboard,
        data: request.toMap(),
      );
      final Map<String, dynamic>? data = _dioClient.getResponseData(
        result.data,
      );

      if (data != null) {
        return PaginationResponseModel<ProjectPaginatedModel>.fromJson(data, (
          Map<String, dynamic> json,
        ) {
          final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
          return ProjectPaginatedModel.fromJson(<String, dynamic>{
            ...json,
            'index': index,
          });
        });
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginationResponseModel<ItemTestPaginationModel>> getItemTestPagination(BaseListRequestModel request) async {
    try {
      
      // request = request.copyWith(
      //   sort: <SortRequestModel>[
      //     SortRequestModel(field: 'endDate', direction: 'asc'),
      //   ],
      // );

      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemTestPagination,
        data: request.toMap(),
      );
      final Map<String, dynamic>? data = _dioClient.getResponseData(
        result.data,
      );

      if (data != null) {
        return PaginationResponseModel<ItemTestPaginationModel>.fromJson(data, (
          Map<String, dynamic> json,
        ) {
          final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
          return ItemTestPaginationModel.fromJson(<String, dynamic>{
            ...json,
            'index': index,
          });
        });
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProjectActiveInfoEntity> getProjectActiveInfo() async {
    final Response<dynamic> response = await _dioClient.get(
      EndpointConstants.projectActiveInfo,
    );

    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data =
          response.data['data'] as Map<String, dynamic>;
      return ProjectActiveInfoEntity(
        total: data['total'] as int,
        deadline: data['deadline'] as int,
      );
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Future<PaginationResponseModel<ItemVendorArrivalModel>> getItemVendorArrivalPagination(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemVendorArrivalPagination,
        data: request.toMap(),
      );
      final Map<String, dynamic>? data = _dioClient.getResponseData(
        result.data,
      );

      if (data != null) {
        return PaginationResponseModel<ItemVendorArrivalModel>.fromJson(data, (
            Map<String, dynamic> json,
            ) {
          final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
          return ItemVendorArrivalModel.fromJson(<String, dynamic>{
            ...json,
            'index': index,
          });
        });
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }
}
