import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_request/item_request_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_request_provider.dart';

class RemoteItemRequestProvider implements IRemoteItemRequestProvider {

  final DioClient _dioClient;

  RemoteItemRequestProvider(this._dioClient);

  @override
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getList(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemRequestPagination, data: request.toMap(),);
      final Map<String, dynamic>? data = _dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemRequestPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemRequestPaginatedModel.fromJson(<String, dynamic>{
              ...json,
              'index': index,
            });
          },
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginationResponseModel<ItemRequestPaginatedModel>> getListByProject(String projectId, BaseListRequestModel request) async {
    try {
      request.filters.add(FilterRequestModel(
          field: 'projectId', operator: 'eq', value: projectId));
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemRequestPagination, data: request.toMap(),);
      final Map<String, dynamic>? data = _dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemRequestPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemRequestPaginatedModel.fromJson(<String, dynamic>{
              ...json,
              'index': index,
            });
          },
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }
}