import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../models/page_access/page_access_model.dart';
import '../../../models/user_info/user_info_model.dart';
import '../interfaces/i_auth_provider.dart';

class RemoteAuthProvider implements IAuthProvider {
  final DioClient dioClient;
  final SecureStorageService secureStorageService;

  RemoteAuthProvider({
    required this.dioClient,
    required this.secureStorageService,
  });

  @override
  Future<String> generateCode() async {
    final Response<dynamic> response = await dioClient.get(
      EndpointConstants.generateCode,
      queryParameters: <String, String>{
        'platform': 'mobile'},
    );

    if (response.data is Map<String, dynamic>) {
      return response.data['data'] as String;
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Future<void> getToken(String code) async {
    try {
      final Response<dynamic> response = await dioClient.post(
        EndpointConstants.token,
        data:<String, String>{'code': code, 'platform': 'mobile'},
        options: Options(
          headers: <String, String>{'Content-Type': 'application/json'},
        ),
      );

      final Map<String, dynamic> data =
          response.data!['data'] as Map<String, dynamic>;
      final String token = data['access_token'] as String;
      final String idToken = data['id_token'] as String;
      final String roleActive = data['role_active'] as String;

      await secureStorageService.saveToken(token);
      await secureStorageService.saveIdToken(idToken);
      await secureStorageService.saveRoleActive(roleActive);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<String> logout() async {
    final String? idTokenHint = await secureStorageService.getIdToken();
    try {


      final Response<dynamic> response = await dioClient.get(
        EndpointConstants.logout,
        queryParameters: <String, String>{
          'platform': 'mobile',
          'idTokenHint': idTokenHint!,
        },
      );

      return response.data!['data'] as String;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<PageAccessModel> getPageAccess() async {
    try {
      final RequestOptions options = RequestOptions();
      final String? token = await secureStorageService.getToken();
      final String? roleActive = await secureStorageService.getRoleActive();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['X-Role-Active'] = '$roleActive';
      }
      final Response<dynamic> response = await dioClient.get(
        EndpointConstants.pageAccess,
      );
      final PageAccessModel data = PageAccessModel.fromJson(response.data['data'] as Map<String, dynamic>);
      return data;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<UserInfoModel> getUserInfo() async {
    try {
      final Response<dynamic> response = await dioClient.get(
        EndpointConstants.userInfo,
      );

      final UserInfoModel data = UserInfoModel.fromJson(response.data['data'] as Map<String, dynamic>);
      return data;

    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
