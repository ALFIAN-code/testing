import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/on_project_item/on_project_item_paginated_model.dart';
import '../../../models/on_project_item/scan_status_count_model.dart';
import '../../../models/on_project_item/scanned_item_list_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../request/on_project_item/get_scanned_item_request.dart';
import '../interfaces/i_remote_on_project_item_provider.dart';

class RemoteOnProjectItemProvider implements IRemoteOnProjectItemProvider {

  final DioClient _dioClient;

  RemoteOnProjectItemProvider(this._dioClient);

  @override
  Future<PaginationResponseModel<OnProjectItemPaginatedModel>> getList(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.onProjectItemPagination,
        data: request.toMap(),
      );
      final Map<String, dynamic>? data =
      _dioClient.getResponseData(result.data as Map<String, dynamic>?);

      if (data != null) {
        return PaginationResponseModel<
            OnProjectItemPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) =>
                  OnProjectItemPaginatedModel.fromJson(json),
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScanStatusCountModel> getScanStatusCount(String projectId) async {
    try {
      final Uri url = Uri.parse('${EndpointConstants.onProjectStatusCount}/$projectId');
      final Response<dynamic> result = await _dioClient.get(url.path);

      final Map<String, dynamic>? response = result.data as Map<String, dynamic>?;

      if (response != null) {
        final Map<String, dynamic> item = response['data'] as Map<String, dynamic>;
        return ScanStatusCountModel.fromJson(item);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> scanItem(String projectId, String barcode) async {
    try {
      final Response<dynamic> result = await _dioClient.put(
        EndpointConstants.onProjectItemScan, data: {
        'projectId': projectId, 'itemBarcode': barcode,
      },);
      final Map<String, dynamic>? response = result.data as Map<String, dynamic>?;

      if (response != null) {
        final Map<String, dynamic> item = response['data'] as Map<String, dynamic>;
        return item['id'] as String;
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      final Response<dynamic> _ = await _dioClient.put(
        EndpointConstants.onProjectRemoveScan, data: <String, dynamic>{
        'itemRequestItemScanId': requestId,
      },);

    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<ScannedItemListModel>> getScannedList(GetScannedItemListRequest request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.onProjectItemScannedList, data: request.toJson(),);
      final Map<String, dynamic>? response = result.data as Map<String, dynamic>?;

      if (response != null) {
        final List<dynamic> items = response['data'] as List<dynamic>;
        return items.map((dynamic item) => ScannedItemListModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> bulkScan(List<Map<String, dynamic>> listRequest) async {
    final Response<dynamic> _ = await _dioClient.put(
      EndpointConstants.onProjectItemBulkScanItem, data: <String, List<Map<String, dynamic>>>{'items': listRequest},);
  }
}