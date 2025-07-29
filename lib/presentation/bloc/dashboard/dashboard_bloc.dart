import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/preference_constants.dart';
import '../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/base_list_request_model.dart';
import '../../../data/models/dashboard/item_request_unprocessed_model.dart';
import '../../../data/models/dashboard/item_statistic_model.dart';
import '../../../data/models/dashboard/item_test_info_model.dart';
import '../../../data/models/dashboard/item_test_pagination_model.dart';
import '../../../data/models/dashboard/item_vendor_arrival_model.dart';
import '../../../data/models/pagination_response_model.dart';
import '../../../data/models/project/project_pagination_model.dart';
import '../../../dependency_injection.dart';
import '../../../domain/entities/project_active_info_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/dashboard_repository.dart';
import '../../../domain/repositories/fcm_token_repository.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Cubit<DashboardState> {
  final SecureStorageService secureStorageService;
  final AuthRepository _authRepository;
  final DashboardRepository _dashboardRepository;

  DashboardBloc(
    this.secureStorageService,
    this._dashboardRepository,
    this._authRepository,
  ) : super(const DashboardState());

  Future<void> initial() async {
    emit(state.copyWith(statusProfile: FormzSubmissionStatus.inProgress));
    final List<String?> profileData = await Future.wait([
      secureStorageService.get(PreferenceConstants.profileName),
      secureStorageService.get(PreferenceConstants.roleCode),
      secureStorageService.get(PreferenceConstants.profileImagePath),
    ]);

    emit(state.copyWith(
      name: profileData[0],
      role: profileData[1],
      imagePath: profileData[2],
      statusProfile: FormzSubmissionStatus.success,
    ),);

    await load();
  }

  Future<void> load() async {
    emit(state.copyWith(statusFirstSection: FormzSubmissionStatus.inProgress));
    try {
      final List<Object> results = await Future.wait([
        _dashboardRepository.getItemRequestUnprocessed(),
        _dashboardRepository.getItemStatistic(),
        _dashboardRepository.getItemVendorArrivalPagination(BaseListRequestModel.initial()),
      ]);

      final ItemRequestUnprocessedModel itemRequestUnprocessed = results[0] as ItemRequestUnprocessedModel;
      final ItemStatisticModel itemStatisticModel = results[1] as ItemStatisticModel;
      final PaginationResponseModel<ItemVendorArrivalModel> itemVendorArrivalPaginationModel = results[2] as PaginationResponseModel<ItemVendorArrivalModel>;

      emit(state.copyWith(
        itemStatisticModel: itemStatisticModel,
        itemRequestUnprocessedModel: itemRequestUnprocessed,
        itemVendorArrivalModel: itemVendorArrivalPaginationModel,
        statusFirstSection: FormzSubmissionStatus.success,
      ));


    } catch(e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          statusProfile: FormzSubmissionStatus.initial,
          statusFirstSection: FormzSubmissionStatus.failure));

    }

    emit(state.copyWith(statusSecondSection: FormzSubmissionStatus.inProgress));
    try {
      final List<Object> results = await Future.wait([
        _dashboardRepository.getProjectActiveInfo(),
        _dashboardRepository.getProjectActive(BaseListRequestModel.initial()),
        _dashboardRepository.getItemTestInfo(),
        _dashboardRepository.getItemTestPagination(BaseListRequestModel.initial(),),
      ]);

      final ProjectActiveInfoEntity projectActiveInfoEntity = results[0] as ProjectActiveInfoEntity;
      final PaginationResponseModel<ProjectPaginatedModel> projectPaginatedModel = results[1] as PaginationResponseModel<ProjectPaginatedModel>;
      final ItemTestInfoModel itemTestInfoModel = results[2] as ItemTestInfoModel;
      final PaginationResponseModel<ItemTestPaginationModel> itemTestPaginationModel = results[3] as PaginationResponseModel<ItemTestPaginationModel>;


      emit(state.copyWith(
        itemTestInfoModel: itemTestInfoModel,
        projectActiveInfo: projectActiveInfoEntity,
        projectPaginatedModel: projectPaginatedModel,
        itemTestPaginationModel: itemTestPaginationModel,
        statusSecondSection: FormzSubmissionStatus.success,
      ));


    } catch(e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          statusProfile: FormzSubmissionStatus.initial,
          statusSecondSection: FormzSubmissionStatus.failure));
    }
  }


  Future<void> logout() async {
    emit(state.copyWith(logoutStatus: FormzSubmissionStatus.inProgress));
    try {
      final FCMTokenRepository fcmTokenRepository = serviceLocator.get<FCMTokenRepository>();
      await fcmTokenRepository.unregister();
      await _authRepository.logout();

      await secureStorageService.deleteAll();

      emit(state.copyWith(logoutStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          logoutStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
