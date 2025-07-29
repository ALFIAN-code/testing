import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';

import '../secure_storage_service/secure_storage_service.dart';
import 'app_router_service.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final SecureStorageService secureStorageService =
        GetIt.instance<SecureStorageService>();

    try {
      final String? token = await secureStorageService.getToken();

      if (token != null && token.isNotEmpty) {
        // Token exists, allow navigation
        resolver.next();
      } else {
        // No token, redirect to splash
        router.pushAndPopUntil(
          const SplashRoute(),
          predicate: (route) => false,
        );
      }
    } catch (e) {
      // Error getting token, redirect to splash
      router.pushAndPopUntil(const SplashRoute(), predicate: (route) => false);
    }
  }
}
