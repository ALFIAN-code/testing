import 'package:dio/src/response.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../interfaces/i_remote_inspection_provider.dart';

class RemoteInspectionProvider implements IRemoteInspectionProvider {

  final DioClient _dioClient;

  RemoteInspectionProvider(this._dioClient);

  @override
  Future<void> logInspection(String itemId) async {
    try {
      final Response<dynamic> _ = await _dioClient.post(
        EndpointConstants.inspectionLog,
        data: <String, String>{'itemId': itemId},
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> bulkScan(List<String> ids) async {
    try {
      final Response<dynamic> _ = await _dioClient.post(
        EndpointConstants.inspectionBulkLog, data: <String, List<Map<String, String>>>{
        'items': ids.map((String e) => <String, String>{'itemId': e}).toList(),
      },);
    } catch(e) {
      rethrow;
    }
  }
}