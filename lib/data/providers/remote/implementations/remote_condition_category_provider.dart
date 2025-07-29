import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/condition/condition_paginated_model.dart';
import '../../../models/condition_category/condition_category_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_condition_category_provider.dart';
import '../interfaces/i_remote_condition_provider.dart';

class RemoteConditionCategoryProvider implements IRemoteConditionCategoryProvider {

  final DioClient dioClient;

  RemoteConditionCategoryProvider(this.dioClient);

  @override
  Future<PaginationResponseModel<ConditionCategoryPaginatedModel>> getList(BaseListRequestModel model) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.conditionCategoryPagination,
        data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ConditionCategoryPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ConditionCategoryPaginatedModel.fromJson(<String, dynamic>{
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