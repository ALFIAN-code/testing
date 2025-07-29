import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_vendor_reception/item_vendor_reception_item_paginated_model.dart';
import '../../../models/item_vendor_reception/item_vendor_reception_model.dart';
import '../../../models/item_vendor_reception/item_vendor_reception_paginated_model.dart';
import '../../../models/item_vendor_reception/item_vendor_reception_param.dart';
import '../../../models/pagination_response_model.dart';
import '../interfaces/i_remote_item_vendor_reception_provider.dart';

class RemoteItemVendorReceptionProvider implements IRemoteItemVendorReceptionProvider {

  final DioClient dioClient;

  RemoteItemVendorReceptionProvider({required this.dioClient});

  @override
  Future<PaginationResponseModel<ItemVendorReceptionPaginatedModel>> getList(BaseListRequestModel model) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.itemVendorReceptionPagination,
        data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemVendorReceptionPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemVendorReceptionPaginatedModel.fromJson(<String, dynamic>{
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

  @override
  Future<ItemVendorReceptionModel> getDetail(String id) async {
    try {
      final Response<dynamic> result = await dioClient.get(
        '${EndpointConstants.itemVendorReceptionDetail}/$id',
      );
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return ItemVendorReceptionModel.fromJson(data);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<PaginationResponseModel<ItemVendorReceptionItemPaginatedModel>> getListItem(String id, BaseListRequestModel model) async {
    try {
      const String endpoint = EndpointConstants.itemVendorReceptionItemPagination;

      final String finalUrl = endpoint.replaceFirst('{itemVendorId}', id);

      final Response<dynamic> result = await dioClient.post(finalUrl, data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemVendorReceptionItemPaginatedModel>.fromJson(
          data, (Map<String, dynamic> json) => ItemVendorReceptionItemPaginatedModel.fromJson(json),
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateChecklist(String id, ItemVendorReceptionParam param) async {
    try {
      final String finalUrl = '${EndpointConstants.itemVendorReceptionItemUpdate}/$id';
      await dioClient.put(finalUrl, data: param.toJson(),);

    } catch (e) {
      rethrow;
    }
  }
}