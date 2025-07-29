import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_code/item_code_sync_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_code_provider.dart';

class RemoteItemCodeProvider implements IRemoteItemCodeProvider {

  final DioClient _dioClient;

  RemoteItemCodeProvider(this._dioClient);

  @override
  Future<PaginationResponseModel<ItemCodeSyncPaginatedModel>> sync(String? id, String? lastUpdate) async {
    try {
      final BaseListRequestModel requestModel = BaseListRequestModel.initial();
      final Map<String, dynamic> request = <String, dynamic>{
        ...requestModel.toMap(),
        'lastUpdate': lastUpdate ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toString() };

      if (id != null) {
        request['lastId'] = id;
      }

      final Response<dynamic> result = await _dioClient.post(EndpointConstants.itemCodeSyncPagination,  data: request,);
      final Map<String, dynamic>? data = _dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemCodeSyncPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemCodeSyncPaginatedModel.fromJson(<String, dynamic>{
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