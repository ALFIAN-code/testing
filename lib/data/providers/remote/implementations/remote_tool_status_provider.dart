import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/tools_status/tool_status_paginated_model.dart';
import '../interfaces/i_remote_item_test_provider.dart';
import '../interfaces/i_remote_tool_status_provider.dart';

class RemoteToolStatusProvider implements IRemoteToolStatusProvider {

  final DioClient dioClient;

  RemoteToolStatusProvider(this.dioClient);

  @override
  Future<PaginationResponseModel<ToolStatusPaginatedModel>> getList(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.toolStatusPagination,
        data: request.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ToolStatusPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ToolStatusPaginatedModel.fromJson(<String, dynamic>{
              ...json,
              'index': index,
            });
          },
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }
}