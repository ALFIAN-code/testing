import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/on_project_item/on_project_item_paginated_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/on_project_item_repository.dart';

part 'list_on_project_item_state.dart';

class ListOnProjectItemBloc extends Cubit<ListOnProjectItemState> {
  final OnProjectItemRepository _onProjectItemRepository;

  ListOnProjectItemBloc(this._onProjectItemRepository) : super(const ListOnProjectItemState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final PaginationResponseModel<
          OnProjectItemPaginatedModel> listProjects = await _onProjectItemRepository
          .getList(BaseListRequestModel.initial());
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
          OnProjectItemPaginatedModel> listProjects = await _onProjectItemRepository
          .getList(BaseListRequestModel.initial());
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
    final PaginationResponseModel<OnProjectItemPaginatedModel>? currentProjectList = state.projectList;
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
      final PaginationResponseModel<OnProjectItemPaginatedModel> nextPageResponse = await _onProjectItemRepository.getList(nextPageRequest);
      final List<OnProjectItemPaginatedModel> allItems = <OnProjectItemPaginatedModel>[...currentProjectList.items, ...nextPageResponse.items];

      final PaginationResponseModel<OnProjectItemPaginatedModel> mergedItemResponse = PaginationResponseModel<OnProjectItemPaginatedModel>(
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

      final PaginationResponseModel<OnProjectItemPaginatedModel> projectList =
      await _onProjectItemRepository.getList(listRequestModel);

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