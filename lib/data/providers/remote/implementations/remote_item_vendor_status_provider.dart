import 'package:dio/src/response.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_status/item_vendor_status_paginated_model.dart';
import '../../../models/pagination_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_vendor_status_provider.dart';

class RemoteItemVendorStatusProvider implements IRemoteItemVendorStatusProvider {

  final DioClient dioClient;

  RemoteItemVendorStatusProvider({required this.dioClient});

  @override
  Future<PaginationResponseModel<ItemVendorStatusPaginatedModel>> getList(BaseListRequestModel model) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.itemVendorStatusPagination,
        data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemVendorStatusPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemVendorStatusPaginatedModel.fromJson(<String, dynamic>{
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