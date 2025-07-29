import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/item_preparation/item_preparation_count_model.dart';
import '../../../models/item_preparation/item_preparation_detail_model.dart';
import '../../../models/item_preparation/item_preparation_summary_model.dart';
import '../../../models/on_project_item/scan_status_count_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/project/project_item_request_summary_pagination_model.dart';
import '../../../request/item_preparation/item_preparation_summary_request.dart';
import '../interfaces/i_remote_item_preparation_provider.dart';

class RemoteItemPreparationProvider implements IRemoteItemPreparationProvider {

  final DioClient _dioClient;

  RemoteItemPreparationProvider(this._dioClient);

  @override
  Future<List<ItemPreparationDetailModel>> getDetailItem(String projectId, String itemCodeId) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemPreparationDetailItem,
        data: { 'projectId': projectId, 'itemCodeId': itemCodeId},);

      final Map<String, dynamic>? response = result.data as Map<String, dynamic>?;

      if (response != null) {
        final List<dynamic> items = response['data'] as List<dynamic>;
        return items.map((dynamic item) => ItemPreparationDetailModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>> getList(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemPreparationPagination,
        data: request.toMap(),
      );
      final Map<String, dynamic>? data =
      _dioClient.getResponseData(result.data as Map<String, dynamic>?);

      if (data != null) {
        return PaginationResponseModel<
            ProjectItemRequestSummaryPaginatedModel>.fromJson(
          data,
              (Map<String, dynamic> json) =>
              ProjectItemRequestSummaryPaginatedModel.fromJson(json),
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ItemPreparationSummaryModel>> getSummary(ItemPreparationSummaryRequest request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemPreparationSummary, data: request.toJson(),);
      final Map<String, dynamic>? response = result.data as Map<String, dynamic>?;

      if (response != null) {
        final List<dynamic> items = response['data'] as List<dynamic>;
        return items.map((dynamic item) => ItemPreparationSummaryModel.fromJson(item as Map<String, dynamic>)).toList();
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
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.itemPreparationScanItem, data: {
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
  Future<ItemPreparationCountModel> getScanStatusCount(String projectId) async {
    try {
      final Uri url = Uri.parse('${EndpointConstants.itemPreparationStatusCount}/$projectId');
      final Response<dynamic> result = await _dioClient.get(url.path);

      final Map<String, dynamic>? response = result.data as Map<String, dynamic>?;

      if (response != null) {
        final Map<String, dynamic> item = response['data'] as Map<String, dynamic>;
        return ItemPreparationCountModel.fromJson(item);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      final Response<dynamic> _ = await _dioClient.delete(
        EndpointConstants.itemPreparationDeleteScannedItem, data: <String, dynamic>{
        'itemRequestItemScanId': requestId,
      },);

    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> bulkScan(List<Map<String, dynamic>> listRequest) async {
    final Response<dynamic> _ = await _dioClient.post(
      EndpointConstants.itemPreparationBulkScanItem, data: <String, List<Map<String, dynamic>>>{'items': listRequest},);
  }
}