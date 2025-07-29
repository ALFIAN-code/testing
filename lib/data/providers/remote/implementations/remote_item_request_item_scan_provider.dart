import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_request_item_scan/item_request_item_scan_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_request_item_scan_provider.dart';

class RemoteItemRequestItemScanProvider implements IRemoteItemRequestItemScanProvider {

  final DioClient _dioClient;

  RemoteItemRequestItemScanProvider(this._dioClient);

  @override
  Future<PaginationResponseModel<ItemRequestItemScanPaginatedModel>> getList(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemPreparationPagination,
        data: request.toMap(),);
      final Map<String, dynamic>? data = _dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemRequestItemScanPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemRequestItemScanPaginatedModel.fromJson(<String, dynamic>{
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