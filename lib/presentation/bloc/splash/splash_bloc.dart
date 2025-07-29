import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/preference_constants.dart';
import '../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../data/models/access_permission_model.dart';
import '../../../data/models/page_access/page_access_model.dart';
import '../../../data/models/user_info/user_info_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/condition_category_repository.dart';
import '../../../domain/repositories/condition_repository.dart';
import '../../../domain/repositories/fcm_token_repository.dart';
import '../../../domain/usecases/access_permission/add_range_access_permission_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  final AddRangeAccessPermissionUseCase addRangeAccessPermissionUseCase;
  final SecureStorageService secureStorageService;
  final AuthRepository authRepository;
  final ConditionRepository conditionRepository;
  final ConditionCategoryRepository conditionCategoryRepository;
  final FCMTokenRepository fcmTokenRepository;

  SplashBloc(
  this.addRangeAccessPermissionUseCase,
  this.secureStorageService,
  this.authRepository, this.conditionRepository,
      this.conditionCategoryRepository,
      this.fcmTokenRepository
  ) : super(SplashStateInitial()) {

    on<AccessPermissionRequested>(_onAccessPermissionRequested);
  }

  Future<void> _onAccessPermissionRequested(
      AccessPermissionRequested event,
      Emitter<SplashState> emit,
      ) async {
    emit(SplashStateLoading());

    try {
      final String? token = await secureStorageService.getToken();

      if (token == null) {
        throw Exception('No Authenticated');
      }

      final UserInfoModel userInfoModel = await authRepository.getUserInfo();

      await Future.wait([
        secureStorageService.set(PreferenceConstants.profileName, userInfoModel.name),
        secureStorageService.set(PreferenceConstants.userName, userInfoModel.username),
        secureStorageService.set(PreferenceConstants.email, userInfoModel.email),
        secureStorageService.set(PreferenceConstants.profileImagePath, userInfoModel.image),
        secureStorageService.set(PreferenceConstants.roleList, jsonEncode(userInfoModel.roles)),
      ]);

      final String? role = await secureStorageService.get(PreferenceConstants.roleCode);

      if (role == null) {
        emit(SplashStatePickRole());
        return;
      }

      final PageAccessModel pageAccessModel = await authRepository.getPageAccess();

      final List<AccessPermissionModel> permissions = [];

      pageAccessModel.permissions.forEach((String key, List<String> value) {
        permissions.add(
          AccessPermissionModel(
            module: key,
            view: value.any((String e) => e == 'view'),
            delete: value.any((String e) => e == 'delete'),
            history: value.any((String e) => e == 'history'),
            insert: value.any((String e) => e == 'insert'),
            update: value.any((String e) => e == 'update'),
            upsert: value.any((String e) => e == 'upsert'),
          ),
        );
      });


      await addRangeAccessPermissionUseCase.call(permissions);

      await fcmTokenRepository.register();

      emit(SplashStateSuccess(permissions));

      final Future<Null> future = Future<Null>(() async {
        await conditionCategoryRepository.sync();
        await conditionRepository.sync();
      });
    } catch (e) {
      emit(SplashStateFailure(e.toString()));
    }
  }
}
