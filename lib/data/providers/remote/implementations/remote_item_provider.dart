import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item/item_model.dart';
import '../../../models/item/item_paginated_model.dart';
import '../../../models/item/item_sync_paginated_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../request/item/create_item_request.dart';
import '../interfaces/i_remote_item_provider.dart';

class RemoteItemProvider implements IRemoteItemProvider {

  final DioClient dioClient;

  RemoteItemProvider(this.dioClient);

  @override
  Future<PaginationResponseModel<ItemPaginatedModel>> getList(BaseListRequestModel model) async {
    try {
      final Response<dynamic> result = await dioClient.post(
        EndpointConstants.itemPagination,
        data: model.toMap(),);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemPaginatedModel.fromJson(<String, dynamic>{
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
  Future<ItemModel> getDetailBarcode(String barcode) async {
    try {
      final Response<dynamic> result = await dioClient.get(
        '${EndpointConstants.itemDetailBarcode}/$barcode',);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return ItemModel.fromJson(data);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ItemModel> getDetailById(String id) async {
    try {
      final Response<dynamic> result = await dioClient.get(
        '${EndpointConstants.itemDetailById}/$id',);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return ItemModel.fromJson(data);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> updateCondition(String itemId, String conditionId) async {
    try {
      final String encodedItemId = Uri.encodeComponent(itemId);
      await dioClient.put(
        '${EndpointConstants.itemUpdateCondition}/$encodedItemId',
        data: {'newConditionId': conditionId},
      );
    } catch (_) {
      rethrow;
    }
  }
  @override
  Future<void> update(String id, CreateItemRequest request) async {
    try {
      final String encodedItemId = Uri.encodeComponent(id);
      await dioClient.put(
        '${EndpointConstants.itemUpdate}/$encodedItemId',
        data: request.toJson(),
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<PaginationResponseModel<ItemSyncPaginatedModel>> sync(String? id, String? lastUpdate) async {
    try {
      final BaseListRequestModel requestModel = BaseListRequestModel.initial(pageSize: 100);
      final Map<String, dynamic> request = <String, dynamic>{
        ...requestModel.toMap(),
        'lastUpdate': lastUpdate ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toString() };

      if (id != null) {
        request['lastId'] = id;
      }

      final Response<dynamic> result = await dioClient.post(EndpointConstants.itemSyncPagination,  data: request,);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return PaginationResponseModel<ItemSyncPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) {
            final int index = (data['items'] as List<dynamic>).indexOf(json) + 1;
            return ItemSyncPaginatedModel.fromJson(<String, dynamic>{
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