import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../interfaces/i_remote_return_item_provider.dart';

class RemoteReturnItemProvider implements IRemoteReturnItemProvider {

  final DioClient _dioClient;

  RemoteReturnItemProvider(this._dioClient);

  @override
  Future<void> scanItem(String barcode) async {
    try {
      final Response<dynamic> _ = await _dioClient.put(
        EndpointConstants.scanToReturnItem, data: {
        'itemBarcode': barcode,
      },);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> bulkScan(List<String> barcodes) async {
    try {
      final Response<dynamic> _ = await _dioClient.put(
        EndpointConstants.bulkScanToReturnItem, data: <String, List<Map<String, String>>>{
        'items': barcodes.map((String e) => <String, String>{'itemBarcode': e}).toList(),
      },);
    } catch(e) {
      rethrow;
    }
  }

}