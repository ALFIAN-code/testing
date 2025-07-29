import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/item/item_maintenance_model.dart';
import '../../../models/item/item_test_model.dart';
import '../../../request/item_test/create_item_test_request.dart';
import '../interfaces/i_remote_item_test_provider.dart';

class RemoteItemTestProvider implements IRemoteItemTestProvider {

  final DioClient dioClient;

  RemoteItemTestProvider(this.dioClient);

  @override
  Future<ItemTestModel> getDetailBarcode(String barcode) async {
    try {
      final Response<dynamic> result = await dioClient.get(
        '${EndpointConstants.itemTestDetail}/$barcode',);
      final Map<String, dynamic>? data = dioClient.getResponseData(result.data);

      if (data != null) {
        return ItemTestModel.fromJson(data);
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> update(String barcode, CreateItemTestRequest request) async {
    try {
      final String encodedBarcode = Uri.encodeComponent(barcode);
      await dioClient.put(
        '${EndpointConstants.itemTestUpdate}/$encodedBarcode',
        data: request.toJson(),
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ItemMaintenanceModel>> getHistories(String barcode) async {
    try {
      final String encodedBarcode = Uri.encodeComponent(barcode);
      final Response<dynamic> result = await dioClient.get(
        '${EndpointConstants.itemTestGetHistories}/$encodedBarcode',);

      final dynamic rawData = dioClient.getResponseData(result.data);

      final List<dynamic>? listData =result.data['data'] as List<dynamic>?;

      if (listData != null) {
        return listData
            .map((item) => ItemMaintenanceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException('Expected a list under "data" field or directly');
      }
    } catch (_) {
      rethrow;
    }
  }
}