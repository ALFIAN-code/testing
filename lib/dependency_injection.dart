import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../core/services/network_service/api_config.dart';
import '../core/services/network_service/dio_client.dart';
import 'core/database/database_module.dart';
import 'core/services/firebase_service/firebase_service.dart';
import 'core/services/firebase_service/i_firebase_service.dart';
import 'core/services/local_service/local_service.dart';
import 'core/services/navigation_service/app_router_service.dart';
import 'core/services/navigation_service/auth_guard.dart';
import 'core/services/secure_storage_service/secure_storage_service.dart';
import 'core/services/sync_service/i_sync_service.dart';
import 'core/services/sync_service/sync_service.dart';
import 'data/providers/local/implementations/local_access_permission_provider.dart';
import 'data/providers/local/implementations/local_condition_category_provider.dart';
import 'data/providers/local/implementations/local_condition_provider.dart';
import 'data/providers/local/implementations/local_item_code_provider.dart';
import 'data/providers/local/implementations/local_item_preparation_scan_provider.dart';
import 'data/providers/local/implementations/local_item_provider.dart';
import 'data/providers/local/implementations/local_log_inspection_provider.dart';
import 'data/providers/local/implementations/local_on_project_item_scan_provider.dart';
import 'data/providers/local/implementations/local_prepare_return_item_scan_provider.dart';
import 'data/providers/local/implementations/local_return_item_scan_provider.dart';
import 'data/providers/local/implementations/local_test_result_item_provider.dart';
import 'data/providers/local/interfaces/i_local_condition_category_provider.dart';
import 'data/providers/local/interfaces/i_local_condition_provider.dart';
import 'data/providers/local/interfaces/i_local_item_code_provider.dart';
import 'data/providers/local/interfaces/i_local_item_preparation_scan_provider.dart';
import 'data/providers/local/interfaces/i_local_item_provider.dart';
import 'data/providers/local/interfaces/i_local_log_inspection_provider.dart';
import 'data/providers/local/interfaces/i_local_on_project_item_scan_provider.dart';
import 'data/providers/local/interfaces/i_local_prepare_return_item_scan_provider.dart';
import 'data/providers/local/interfaces/i_local_return_item_scan_provider.dart';
import 'data/providers/remote/implementations/remote_auth_provider.dart';
import 'data/providers/remote/implementations/remote_condition_category_provider.dart';
import 'data/providers/remote/implementations/remote_condition_provider.dart';
import 'data/providers/remote/implementations/remote_dashboard_provider.dart';
import 'data/providers/remote/implementations/remote_fcm_token_provider.dart';
import 'data/providers/remote/implementations/remote_file_provider.dart';
import 'data/providers/remote/implementations/remote_inspection_provider.dart';
import 'data/providers/remote/implementations/remote_item_code_provider.dart';
import 'data/providers/remote/implementations/remote_item_preparation_provider.dart';
import 'data/providers/remote/implementations/remote_item_provider.dart';
import 'data/providers/remote/implementations/remote_item_request_item_scan_provider.dart';
import 'data/providers/remote/implementations/remote_item_request_provider.dart';
import 'data/providers/remote/implementations/remote_item_test_provider.dart';
import 'data/providers/remote/implementations/remote_item_vendor_checklist_provider.dart';
import 'data/providers/remote/implementations/remote_item_vendor_condition_provider.dart';
import 'data/providers/remote/implementations/remote_item_vendor_reception_provider.dart';
import 'data/providers/remote/implementations/remote_item_vendor_status_provider.dart';
import 'data/providers/remote/implementations/remote_on_project_item_provider.dart';
import 'data/providers/remote/implementations/remote_prepare_return_item_provider.dart';
import 'data/providers/remote/implementations/remote_project_provider.dart';
import 'data/providers/remote/implementations/remote_return_item_provider.dart';
import 'data/providers/remote/implementations/remote_test_result_item_provider.dart';
import 'data/providers/remote/implementations/remote_tool_status_provider.dart';
import 'data/providers/remote/implementations/remote_vendor_reception_provider.dart';
import 'data/providers/remote/implementations/remote_vendor_reception_provider_detail.dart';
import 'data/providers/remote/implementations/remote_verification_receipt_provider.dart';
import 'data/providers/remote/interfaces/i_remote_condition_category_provider.dart';
import 'data/providers/remote/interfaces/i_remote_condition_provider.dart';
import 'data/providers/remote/interfaces/i_remote_dashboard_provider.dart';
import 'data/providers/remote/interfaces/i_remote_fcm_token_provider.dart';
import 'data/providers/remote/interfaces/i_remote_file_provider.dart';
import 'data/providers/remote/interfaces/i_remote_inspection_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_code_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_preparation_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_request_item_scan_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_request_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_test_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_vendor_checklist_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_vendor_condition_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_vendor_reception_provider.dart';
import 'data/providers/remote/interfaces/i_remote_item_vendor_status_provider.dart';
import 'data/providers/remote/interfaces/i_remote_on_project_item_provider.dart';
import 'data/providers/remote/interfaces/i_remote_prepare_return_item_provider.dart';
import 'data/providers/remote/interfaces/i_remote_project_provider.dart';
import 'data/providers/remote/interfaces/i_remote_return_item_provider.dart';
import 'data/providers/remote/interfaces/i_remote_tool_status_provider.dart';
import 'data/repositories/access_permission_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/condition_category_repository_impl.dart';
import 'data/repositories/condition_repository_impl.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'data/repositories/fcm_token_repository_impl.dart';
import 'data/repositories/file_repository_impl.dart';
import 'data/repositories/inspection_repository_impl.dart';
import 'data/repositories/item_code_repository_impl.dart';
import 'data/repositories/item_preparation_repository_impl.dart';
import 'data/repositories/item_repository_impl.dart';
import 'data/repositories/item_request_item_scan_repository_impl.dart';
import 'data/repositories/item_request_repository_impl.dart';
import 'data/repositories/item_test_repository_impl.dart';
import 'data/repositories/item_vendor_checklist_repository_impl.dart';
import 'data/repositories/item_vendor_condition_repository_impl.dart';
import 'data/repositories/item_vendor_reception_repository_impl.dart';
import 'data/repositories/item_vendor_status_repository_impl.dart';
import 'data/repositories/on_project_item_repository_impl.dart';
import 'data/repositories/prepare_return_item_repository_impl.dart';
import 'data/repositories/project_repository_impl.dart';
import 'data/repositories/return_item_repository_impl.dart';
import 'data/repositories/test_result_item_repository_impl.dart';
import 'data/repositories/tool_status_repository_impl.dart';
import 'data/repositories/vendor_goods_reception_detail_repository_impl.dart';
import 'data/repositories/vendor_goods_reception_repository_impl.dart';
import 'data/repositories/verification_receipt_checklist_repository_impl.dart';
import 'domain/repositories/access_permission_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/condition_category_repository.dart';
import 'domain/repositories/condition_repository.dart';
import 'domain/repositories/dashboard_repository.dart';
import 'domain/repositories/fcm_token_repository.dart';
import 'domain/repositories/file_repository.dart';
import 'domain/repositories/inspection_repository.dart';
import 'domain/repositories/item_code_repository.dart';
import 'domain/repositories/item_preparation_repository.dart';
import 'domain/repositories/item_repository.dart';
import 'domain/repositories/item_request_item_scan_repository.dart';
import 'domain/repositories/item_request_repository.dart';
import 'domain/repositories/item_test_repository.dart';
import 'domain/repositories/item_vendor_checklist_repository.dart';
import 'domain/repositories/item_vendor_condition_repository.dart';
import 'domain/repositories/item_vendor_reception_repository.dart';
import 'domain/repositories/item_vendor_status_repository.dart';
import 'domain/repositories/on_project_item_repository.dart';
import 'domain/repositories/prepare_return_item_repository.dart';
import 'domain/repositories/project_repository.dart';
import 'domain/repositories/return_item_repository.dart';
import 'domain/repositories/test_result_item_repository.dart';
import 'domain/repositories/tool_status_repository.dart';
import 'domain/repositories/vendor_goods_reception_detail_repository.dart';
import 'domain/repositories/vendor_goods_reception_repository.dart';
import 'domain/repositories/verification_receipt_checklist_repository.dart';
import 'domain/usecases/access_permission/add_range_access_permission_usecase.dart';
import 'domain/usecases/access_permission/get_all_access_permission_usecase.dart';
import 'domain/usecases/auth_get_token_usecase.dart';
import 'domain/usecases/auth_login_usecase.dart';
import 'domain/usecases/fetch_vendor_goods_reception_detail_usecase.dart';
import 'domain/usecases/fetch_vendor_goods_reception_usecase.dart';
import 'domain/usecases/verify_receipt_checklist_usecase.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  try {
    await _initializeFirebase();
    await _initializeDatabase();
    await _initializeStorage();
    await _initializeNetwork();
    await _initializeProviders();
    await _initializeRepositories();
    await _initializeUseCases();

    serviceLocator.registerSingleton<ISyncService>(SyncService());
  } catch (e) {
    throw DependencyInitializationException(
      'Failed to initialize dependencies: $e',
    );
  }
}

Future<void> _initializeFirebase() async {
  final IFirebaseService service = FirebaseService();
  final FirebaseOptions firebaseOptions = await service.getConfig();
  await Firebase.initializeApp(options: firebaseOptions);
}

Future<void> _initializeDatabase() async {
  serviceLocator.registerSingletonAsync<Database>(provideDatabase);

  await serviceLocator.isReady<Database>();
  serviceLocator.registerSingleton(LocalService(serviceLocator<Database>()));
}

Future<void> _initializeStorage() async {
  serviceLocator.registerLazySingleton(SecureStorageService.new);
}

Future<void> _initializeNetwork() async {
  serviceLocator
    ..registerLazySingleton(Dio.new)
    ..registerLazySingleton<ApiConfig>(() {
      if (kReleaseMode) {
        return ApiConfig.production();
      } else {
        return ApiConfig.development();
      }
    })
    ..registerLazySingleton(
      () => DioClient(
        dio: serviceLocator<Dio>(),
        apiConfig: serviceLocator<ApiConfig>(),
        secureStorageService: serviceLocator<SecureStorageService>(),
      ),
    )
    // Register AppRouter sebagai singleton
    ..registerLazySingleton<AppRouter>(() => AppRouter())
    // Register AuthGuard
    ..registerLazySingleton<AuthGuard>(() => AuthGuard());
}

Future<void> _initializeProviders() async {
  serviceLocator
    ..registerFactory(
      () => RemoteAuthProvider(
        dioClient: serviceLocator<DioClient>(),
        secureStorageService: serviceLocator<SecureStorageService>(),
      ),
    )
    ..registerFactory(
      () => RemoteVendorGoodsReceptionProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory(
      () => RemoteVerificationReceiptProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory(
      () => RemoteVendorGoodsReceptionDetailProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory(
      () => LocalAccessPermissionProvider(
        localService: serviceLocator<LocalService>(),
      ),
    )
    ..registerFactory(
      () => RemoteTestResultItemProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory(
      () => LocalTestResultItemProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory(() => LocalItemProvider(serviceLocator<LocalService>()))
    ..registerFactory<ILocalItemProvider>(
      () => LocalItemProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<IRemoteItemProvider>(
      () => RemoteItemProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteItemVendorConditionProvider>(
      () => RemoteItemVendorConditionProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<IRemoteItemVendorStatusProvider>(
      () => RemoteItemVendorStatusProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<IRemoteItemVendorReceptionProvider>(
      () => RemoteItemVendorReceptionProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<IRemoteItemVendorChecklistProvider>(
      () => RemoteItemVendorChecklistProvider(
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<IRemoteItemTestProvider>(
      () => RemoteItemTestProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteToolStatusProvider>(
      () => RemoteToolStatusProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteConditionProvider>(
      () => RemoteConditionProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteConditionCategoryProvider>(
      () => RemoteConditionCategoryProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteFileProvider>(
      () => RemoteFileProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteProjectProvider>(
      () => RemoteProjectProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteInspectionProvider>(
      () => RemoteInspectionProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteItemRequestItemScanProvider>(
      () => RemoteItemRequestItemScanProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteDashboardProvider>(
      () => RemoteDashboardProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteItemCodeProvider>(
      () => RemoteItemCodeProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<ILocalItemCodeProvider>(
      () => LocalItemCodeProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<ILocalConditionProvider>(
      () => LocalConditionProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<ILocalConditionCategoryProvider>(
      () => LocalConditionCategoryProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<IRemoteItemPreparationProvider>(
      () => RemoteItemPreparationProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteItemRequestProvider>(
      () => RemoteItemRequestProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteOnProjectItemProvider>(
      () => RemoteOnProjectItemProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<IRemoteReturnItemProvider>(
      () => RemoteReturnItemProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<ILocalItemPreparationScanProvider>(
      () => LocalItemPreparationScanProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<ILocalOnProjectItemScanProvider>(
      () => LocalOnProjectItemScanProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<ILocalReturnItemScanProvider>(
      () => LocalReturnItemScanProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<ILocalLogInspectionProvider>(
      () => LocalLogInspectionProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<IRemoteFCMTokenProvider>(
      () => RemoteFCMTokenProvider(serviceLocator<DioClient>()),
    )
    ..registerFactory<ILocalPrepareReturnItemScanProvider>(
      () => LocalPrepareReturnItemScanProvider(serviceLocator<LocalService>()),
    )
    ..registerFactory<IRemotePrepareReturnItemProvider>(
      () => RemotePrepareReturnItemProvider(serviceLocator<DioClient>()),
    );
}

Future<void> _initializeRepositories() async {
  serviceLocator
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteAuthProvider: serviceLocator<RemoteAuthProvider>(),
      ),
    )
    ..registerFactory<DashboardRepository>(
      () => DashboardRepositoryImpl(serviceLocator<IRemoteDashboardProvider>()),
    )
    ..registerFactory<VendorGoodsReceptionRepository>(
      () => VendorGoodsReceptionRepositoryImpl(
        remoteVendorGoodsReceptionProvider:
            serviceLocator<RemoteVendorGoodsReceptionProvider>(),
      ),
    )
    ..registerFactory<VerificationReceiptChecklistRepository>(
      () => VerificationReceiptChecklistRepositoryImpl(
        remoteVerificationReceiptProvider:
            serviceLocator<RemoteVerificationReceiptProvider>(),
      ),
    )
    ..registerFactory<VendorGoodsReceptionDetailRepository>(
      () => VendorGoodsReceptionDetailRepositoryImpl(
        remoteVendorGoodsReceptionDetailProvider:
            serviceLocator<RemoteVendorGoodsReceptionDetailProvider>(),
      ),
    )
    ..registerFactory<AccessPermissionRepository>(
      () => AccessPermissionRepositoryImpl(
        serviceLocator<LocalAccessPermissionProvider>(),
      ),
    )
    ..registerFactory<TestResultItemRepository>(
      () => TestResultItemRepositoryImpl(
        serviceLocator<LocalTestResultItemProvider>(),
        serviceLocator<RemoteTestResultItemProvider>(),
      ),
    )
    ..registerFactory<ItemRepository>(
      () => ItemRepositoryImpl(
        serviceLocator<ILocalConditionProvider>(),
        serviceLocator<ILocalItemCodeProvider>(),
        serviceLocator<ILocalItemProvider>(),
        serviceLocator<IRemoteItemProvider>(),
      ),
    )
    ..registerFactory<ItemVendorReceptionRepository>(
      () => ItemVendorReceptionRepositoryImpl(
        remoteItemVendorReceptionProvider:
            serviceLocator<IRemoteItemVendorReceptionProvider>(),
      ),
    )
    ..registerFactory<ItemVendorConditionRepository>(
      () => ItemVendorConditionRepositoryImpl(
        remoteItemVendorConditionProvider:
            serviceLocator<IRemoteItemVendorConditionProvider>(),
      ),
    )
    ..registerFactory<ItemVendorStatusRepository>(
      () => ItemVendorStatusRepositoryImpl(
        remoteItemVendorStatusProvider:
            serviceLocator<IRemoteItemVendorStatusProvider>(),
      ),
    )
    ..registerFactory<ItemVendorChecklistRepository>(
      () => ItemVendorChecklistRepositoryImpl(
        remoteItemVendorChecklistProvider:
            serviceLocator<IRemoteItemVendorChecklistProvider>(),
      ),
    )
    ..registerFactory<ItemTestRepository>(
      () => ItemTestRepositoryImpl(serviceLocator<IRemoteItemTestProvider>()),
    )
    ..registerFactory<ToolStatusRepository>(
      () =>
          ToolStatusRepositoryImpl(serviceLocator<IRemoteToolStatusProvider>()),
    )
    ..registerFactory<ConditionRepository>(
      () => ConditionRepositoryImpl(
        serviceLocator<IRemoteConditionProvider>(),
        serviceLocator<ILocalConditionProvider>(),
      ),
    )
    ..registerFactory<ConditionCategoryRepository>(
      () => ConditionCategoryRepositoryImpl(
        serviceLocator<IRemoteConditionCategoryProvider>(),
        serviceLocator<ILocalConditionCategoryProvider>(),
      ),
    )
    ..registerFactory<FileRepository>(
      () => FileRepositoryImpl(serviceLocator<IRemoteFileProvider>()),
    )
    ..registerFactory<ProjectRepository>(
      () => ProjectRepositoryImpl(serviceLocator.get<IRemoteProjectProvider>()),
    )
    ..registerFactory<InspectionRepository>(
      () => InspectionRepositoryImpl(
        serviceLocator.get<ILocalLogInspectionProvider>(),
        serviceLocator.get<IRemoteInspectionProvider>(),
      ),
    )
    ..registerFactory<ItemRequestItemScanRepository>(
      () => ItemRequestItemScanRepositoryImpl(
        serviceLocator.get<IRemoteItemRequestItemScanProvider>(),
      ),
    )
    ..registerFactory<ItemCodeRepository>(
      () => ItemCodeRepositoryImpl(
        serviceLocator<IRemoteItemCodeProvider>(),
        serviceLocator<ILocalItemCodeProvider>(),
      ),
    )
    ..registerFactory<ItemPreparationRepository>(
      () => ItemPreparationRepositoryImpl(
        serviceLocator.get<ILocalConditionProvider>(),
        serviceLocator.get<ILocalItemProvider>(),
        serviceLocator.get<ILocalItemPreparationScanProvider>(),
        serviceLocator.get<IRemoteItemPreparationProvider>(),
      ),
    )
    ..registerFactory<ItemRequestRepository>(
      () => ItemRequestRepositoryImpl(
        serviceLocator.get<IRemoteItemRequestProvider>(),
      ),
    )
    ..registerFactory<OnProjectItemRepository>(
      () => OnProjectItemRepositoryImpl(
        serviceLocator.get<ILocalOnProjectItemScanProvider>(),
        serviceLocator.get<IRemoteOnProjectItemProvider>(),
      ),
    )
    ..registerFactory<ReturnItemRepository>(
      () => ReturnItemRepositoryImpl(
        serviceLocator.get<ILocalReturnItemScanProvider>(),
        serviceLocator.get<IRemoteReturnItemProvider>(),
      ),
    )
    ..registerFactory<FCMTokenRepository>(
      () => FCMTokenRepositoryImpl(
        serviceLocator<SecureStorageService>(),
        serviceLocator<IRemoteFCMTokenProvider>(),
      ),
    )
    ..registerFactory<PrepareReturnItemRepository>(
      () => PrepareReturnItemRepositoryImpl(
        serviceLocator.get<ILocalPrepareReturnItemScanProvider>(),
        serviceLocator.get<IRemotePrepareReturnItemProvider>(),
      ),
    );
}

Future<void> _initializeUseCases() async {
  serviceLocator
    ..registerFactory(
      () => AuthLoginUseCase(authRepository: serviceLocator<AuthRepository>()),
    )
    ..registerFactory(
      () =>
          AuthGetTokenUseCase(authRepository: serviceLocator<AuthRepository>()),
    )
    ..registerFactory(
      () => FetchVendorGoodsReceptionUseCase(
        vendorGoodsReceptionRepository:
            serviceLocator<VendorGoodsReceptionRepository>(),
      ),
    )
    ..registerFactory(
      () => VerifyReceiptChecklistUseCase(
        verificationReceiptChecklistRepository:
            serviceLocator<VerificationReceiptChecklistRepository>(),
      ),
    )
    ..registerFactory(
      () => FetchVendorGoodsReceptionDetailUseCase(
        vendorGoodsReceptionDetailRepository:
            serviceLocator<VendorGoodsReceptionDetailRepository>(),
      ),
    )
    ..registerFactory(() => GetAllAccessPermissionUseCase(serviceLocator.get()))
    ..registerFactory(
      () => AddRangeAccessPermissionUseCase(serviceLocator.get()),
    );
}

class DependencyInitializationException implements Exception {
  DependencyInitializationException(this.message);
  final String message;

  @override
  String toString() => message;
}
