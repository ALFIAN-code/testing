import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../core/services/sync_service/i_sync_service.dart';
import '../../../core/services/sync_service/sync_service.dart';
import '../../../core/utils/formz.dart';
import '../../../dependency_injection.dart';
import '../../../domain/repositories/item_code_repository.dart';
import '../../../domain/repositories/item_preparation_repository.dart';
import '../../../domain/repositories/item_repository.dart';
import '../../bloc/app/access_permission/access_permission_bloc.dart';
import '../../bloc/splash/splash_bloc.dart';
import '../../widgets/shared/dialog/pick_role_dialog.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<SplashBloc>(
    create: (_) => SplashBloc(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
    )..add(AccessPermissionRequested()),
    child: const _SplashView(),
  );
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  late ISyncService _syncService;

  void initSync() {
    final ItemRepository itemRepository = serviceLocator.get();
    final ItemCodeRepository itemCodeRepository = serviceLocator.get();
    _syncService = serviceLocator.get();
    _syncService.clear();
    _syncService.register<void>(() => itemRepository.sync(), const Duration(seconds: 20));
    _syncService.register<void>(() => itemCodeRepository.sync(), const Duration(seconds: 20));
    _syncService.start();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocListener<SplashBloc, SplashState>(
      listener: (BuildContext context, SplashState state) {

        if (state is SplashStatePickRole) {
          showDialog(context: context,
              builder: (ctx) => PickRoleDialog(
                  onResult: (FormzSubmissionStatus action) {
                    ctx.router.pushAndPopUntil(const SplashRoute(), predicate: (route) => false);
                  }
              ),
          );
        }

        if (state is SplashStateSuccess) {
          initSync();
          context.read<AccessPermissionBloc>().setPermissions(state.listPermissions);
          context.router.replaceAll(<PageRouteInfo<Object?>>[const DashboardRoute()]);
        }

        if (state is SplashStateFailure) {
          context.router.replaceAll(<PageRouteInfo<Object?>>[const LoginRoute()]);
        }
      },
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (BuildContext context, SplashState state) {
          if (state is SplashStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SplashStateFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Gagal: ${state.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<SplashBloc>().add(
                          AccessPermissionRequested(),
                        ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (state is SplashStateSuccess) {
            return const Center(
              child: Text(
                'Hak akses berhasil disiapkan!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const Center(child: Text('Menyiapkan data...'));
        },
      ),
    ),
  );
}
