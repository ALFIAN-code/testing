import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_vendor_checklist_provider.dart';

class RemoteItemVendorChecklistProvider implements IRemoteItemVendorChecklistProvider {

  final DioClient dioClient;

  RemoteItemVendorChecklistProvider({required this.dioClient});

  @override
  Future<PaginationResponseModel<ItemVendorChecklistPaginatedModel>> getList(BaseListRequestModel model) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.itemVendorChecklistPagination,
        data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemVendorChecklistPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemVendorChecklistPaginatedModel.fromJson(<String, dynamic>{
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