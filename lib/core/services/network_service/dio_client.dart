import 'package:dio/dio.dart';
import '../../exceptions/dio_exception.dart';
import '../secure_storage_service/secure_storage_service.dart';

import 'api_config.dart';
import 'api_interceptor.dart';

class DioClient {
  DioClient({
    required Dio dio,
    required this.apiConfig,
    required SecureStorageService secureStorageService,
  }) : _dio = dio,
        apiInterceptor = ApiInterceptor(secureStorageService) {
    _setupDio();
  }

  final Dio _dio;
  final ApiConfig apiConfig;
  final ApiInterceptor apiInterceptor;

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: apiConfig.baseUrl,
      connectTimeout: apiConfig.connectTimeout,
      receiveTimeout: apiConfig.receiveTimeout,
      headers: apiConfig.headers,
    );

    _dio.interceptors.clear();
    _dio.interceptors.add(apiInterceptor);
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {

      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.post(
        path,
        data: <String, Object?>{'data': data},
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch(e) {
      rethrow;
    }
  }

  Future<Response<T>> postFormData<T>(
      String path, {
        required FormData data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final Options requestOptions = options ?? Options();
      requestOptions.headers = {
        ...?requestOptions.headers,
        Headers.contentTypeHeader: 'multipart/form-data',
      };

      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.put(
        path,
        data: <String, Object?>{'data': data},
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch(e) {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.delete(
        path,
        data:  <String, Object?>{'data': data},
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic>? getResponseData(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return null;
  }

  Exception _handleError(DioException error) {
    final String message = error.message ?? 'Unknown error occurred';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout try to reconnect');
      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String errorMsg = 'Server error';

        if (responseData != null && responseData is Map<String, dynamic>) {
          try {
            errorMsg =
                responseData['message']?.toString() ??
                    'Server error message missing';
          } catch (e) {
            errorMsg = 'Failed to parse server error message';
          }
        } else if (responseData != null) {
          errorMsg = responseData.toString();
        }

        return ServerException(
          '$errorMsg (${statusCode ?? 'unknown status'})',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException('Connection error: $message');
      case DioExceptionType.badCertificate:
        return NetworkException('Bad certificate');
      case DioExceptionType.unknown:
        return NetworkException('Unknown error: $message');
    }
  }
}