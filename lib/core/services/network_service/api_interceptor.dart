import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../constants/preference_constants.dart';
import '../navigation_service/app_router_service.dart';
import '../navigation_service/app_router_service.gr.dart';
import '../secure_storage_service/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  // Getter untuk testing purposes
  SecureStorageService get secureStorageService => _secureStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _secureStorageService.getToken();
    final String? roleActive = await _secureStorageService.get(
      PreferenceConstants.roleCode,
    );

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      options.headers['X-Role-Active'] = '$roleActive';
    }

    print('HEADER ${options.headers}');

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _handleUnauthorized();
    }

    return handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    try {
      // Hapus semua data autentikasi
      await _secureStorageService.deleteAll();

      // Redirect ke splash page
      final AppRouter appRouter = GetIt.instance<AppRouter>();
      appRouter.pushAndPopUntil(
        const SplashRoute(),
        predicate: (route) => false,
      );
    } catch (e) {
      print('Error handling unauthorized: $e');
    }
  }
}
