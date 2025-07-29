import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../data/models/project/project_pagination_model.dart';
import '../../../../domain/repositories/dashboard_repository.dart';

part 'active_project_state.dart';

class ActiveProjectBloc extends Cubit<ActiveProjectState> {
  final PaginationResponseModel<ProjectPaginatedModel> lastProjectList;
  final DashboardRepository _dashboardRepository;

  ActiveProjectBloc(this.lastProjectList, this._dashboardRepository)
    : super(const ActiveProjectState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      emit(
        state.copyWith(
          projectList: lastProjectList,
          latestUpdate: DateTime.now(),
          listRequestModel: BaseListRequestModel.initial(),
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  void refresh() =>
      load(state.listRequestModel ?? BaseListRequestModel.initial());

  void load(BaseListRequestModel listRequest) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final PaginationResponseModel<ProjectPaginatedModel> listProjects =
          await _dashboardRepository.getProjectActive(
            BaseListRequestModel.initial(),
          );
      emit(
        state.copyWith(
          projectList: listProjects,
          latestUpdate: DateTime.now(),
          listRequestModel: BaseListRequestModel.initial(),
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  Future<void> fetchMoreItems() async {
    final PaginationResponseModel<ProjectPaginatedModel>? currentProjectList =
        state.projectList;
    final BaseListRequestModel? currentRequestModel = state.listRequestModel;

    if (currentProjectList == null || currentRequestModel == null) {
      return;
    }

    final int currentPage = currentProjectList.pagination.currentPage;
    final int totalPages = currentProjectList.pagination.totalPages;
    if (currentPage >= totalPages) {
      return;
    }

    final BaseListRequestModel nextPageRequest = currentRequestModel.copyWith(
      pagination: PaginationRequestModel(
        page: currentPage + 1,
        pageSize: currentRequestModel.pagination.pageSize,
      ),
    );

    emit(state.copyWith(statusLoadMore: FormzSubmissionStatus.inProgress));

    try {
      final PaginationResponseModel<ProjectPaginatedModel> nextPageResponse =
          await _dashboardRepository.getProjectActive(nextPageRequest);
      final List<ProjectPaginatedModel> allItems = <ProjectPaginatedModel>[
        ...currentProjectList.items,
        ...nextPageResponse.items,
      ];

      final PaginationResponseModel<ProjectPaginatedModel> mergedItemResponse =
          PaginationResponseModel<ProjectPaginatedModel>(
            items: allItems,
            pagination: nextPageResponse.pagination,
          );

      emit(
        state.copyWith(
          projectList: mergedItemResponse,
          latestUpdate: DateTime.now(),
          statusLoadMore: FormzSubmissionStatus.success,
          setErrorMessageToNull: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          statusLoadMore: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void setSearch(String? query) async {
    try {
      if (query == null) return;
      emit(
        state.copyWith(
          listRequestModel: state.listRequestModel?.copyWith(
            pagination: PaginationRequestModel(),
            search: query,
          ),
          status: FormzSubmissionStatus.inProgress,
        ),
      );

      final BaseListRequestModel listRequestModel =
          state.listRequestModel ?? BaseListRequestModel.initial();

      final PaginationResponseModel<ProjectPaginatedModel> projectList =
          await _dashboardRepository.getProjectActive(listRequestModel);

      emit(
        state.copyWith(
          latestUpdate: DateTime.now(),
          listRequestModel: listRequestModel,
          projectList: projectList,
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure,
        ),
      );
      rethrow;
    }
  }
}
