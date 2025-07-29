import 'package:dio/dio.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/foundation.dart';

import '../../constants/endpoint_constant.dart';
import '../network_service/api_config.dart';
import 'i_firebase_service.dart';

class FirebaseService implements IFirebaseService {
  late ApiConfig apiConfig;

  FirebaseService() {
    apiConfig = ApiConfig.defaultConfig();
  }

  @override
  Future<FirebaseOptions> getConfig() async {
    try {
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: apiConfig.baseUrl,
          connectTimeout: apiConfig.connectTimeout,
          receiveTimeout: apiConfig.receiveTimeout,
        ),
      );
      const String url = EndpointConstants.getConfigurationFirebase;
      final Response<dynamic> response = await dio.get(url, options: Options(headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'X-Mobile-Auth-Token': EndpointConstants.mobileToken,
      },),);
      final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;

      final Map<String, dynamic>? config = data['config'] as Map<String, dynamic>?;

      if (config == null) {
        throw Exception('Firebase config is null');
      }

      return FirebaseOptions(
        apiKey: config['apiKey'] as String,
        appId: config['appId'] as String,
        messagingSenderId: config['messagingSenderId'] as String,
        projectId: config['projectId'] as String,
        storageBucket: config['storageBucket'] as String,
      );
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      rethrow;
    }
  }
}