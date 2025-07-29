import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../interfaces/i_remote_fcm_token_provider.dart';

class RemoteFCMTokenProvider implements IRemoteFCMTokenProvider {

  final DioClient _dioClient;

  RemoteFCMTokenProvider(this._dioClient);

  @override
  Future<void> register(String token, String appVersion) async {
    try {
      final Response<dynamic> _ = await _dioClient.post(
        EndpointConstants.fcmTokenRegister,
        data: <String, String>{'token': token, 'appVersion': appVersion},
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> unregister(String token) async {
    try {
      final String url = Uri.parse('${EndpointConstants.fcmTokenUnregister}/$token').toString();
      final Response<dynamic> _ = await _dioClient.post(url);
    } catch (_) {
      rethrow;
    }
  }
}