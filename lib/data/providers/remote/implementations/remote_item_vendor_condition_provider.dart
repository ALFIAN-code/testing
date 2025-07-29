import 'package:dio/src/response.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_condition/item_vendor_condition_paginated_model.dart';
import '../../../models/pagination_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_vendor_condition_provider.dart';

class RemoteItemVendorConditionProvider implements IRemoteItemVendorConditionProvider {

  final DioClient dioClient;

  RemoteItemVendorConditionProvider({required this.dioClient});

  @override
  Future<PaginationResponseModel<ItemVendorConditionPaginatedModel>> getList(BaseListRequestModel model) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.itemVendorConditionPagination,
        data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemVendorConditionPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemVendorConditionPaginatedModel.fromJson(<String, dynamic>{
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