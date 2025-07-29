import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../data/models/project/project_item_request_summary_pagination_model.dart';
import '../../../../domain/repositories/project_repository.dart';

part 'list_preparation_state.dart';

class ListPreparationBloc extends Cubit<ListPreparationState> {

  final ProjectRepository _projectRepository;

  ListPreparationBloc(this._projectRepository) : super(const ListPreparationState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final PaginationResponseModel<
          ProjectItemRequestSummaryPaginatedModel> listProjects = await _projectRepository
          .getItemRequestSummary(BaseListRequestModel.initial());
      emit(state.copyWith(
        projectList: listProjects,
        latestUpdate: DateTime.now(),
        listRequestModel: BaseListRequestModel.initial(),
        status: FormzSubmissionStatus.success,),);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        status: FormzSubmissionStatus.failure,
      ),);
    }
  }

  void refresh() => load(state.listRequestModel ?? BaseListRequestModel.initial());

  void load(BaseListRequestModel listRequest) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final PaginationResponseModel<
          ProjectItemRequestSummaryPaginatedModel> listProjects = await _projectRepository
          .getItemRequestSummary(BaseListRequestModel.initial());
      emit(state.copyWith(
        projectList: listProjects,
        latestUpdate: DateTime.now(),
        listRequestModel: BaseListRequestModel.initial(),
        status: FormzSubmissionStatus.success,),);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        status: FormzSubmissionStatus.failure,
      ),);
    }
  }

  Future<void> fetchMoreItems() async {
    final PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>? currentProjectList = state.projectList;
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

    emit(state.copyWith(
      statusLoadMore: FormzSubmissionStatus.inProgress,
    ));

    try {
      final PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel> nextPageResponse = await _projectRepository.getItemRequestSummary(nextPageRequest);
      final List<ProjectItemRequestSummaryPaginatedModel> allItems = <ProjectItemRequestSummaryPaginatedModel>[...currentProjectList.items, ...nextPageResponse.items];

      final PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel> mergedItemResponse = PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>(
        items: allItems,
        pagination: nextPageResponse.pagination,
      );

      emit(state.copyWith(
        projectList: mergedItemResponse,
        latestUpdate: DateTime.now(),
        statusLoadMore: FormzSubmissionStatus.success,
        setErrorMessageToNull: true,
      ));

    } catch (e) {
      emit(state.copyWith(
        statusLoadMore: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void setSearch(String? query) async {
    try {
      if (query == null) return;
      emit(state.copyWith(
          listRequestModel: state.listRequestModel?.copyWith(
              pagination: PaginationRequestModel(),
              search: query
          ),
          status: FormzSubmissionStatus.inProgress));

      final BaseListRequestModel listRequestModel = state.listRequestModel ?? BaseListRequestModel.initial();

      final PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel> projectList =
      await _projectRepository.getItemRequestSummary(listRequestModel);

      emit(state.copyWith(
        latestUpdate: DateTime.now(),
        listRequestModel: listRequestModel,
        projectList: projectList,
        status: FormzSubmissionStatus.success,),);
    } catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(), status: FormzSubmissionStatus.failure,),);
      rethrow;
    }
  }
}