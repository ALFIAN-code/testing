import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/dashboard/item_test_pagination_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/dashboard_repository.dart';

part 'item_test_state.dart';

class ItemTestBloc extends Cubit<ItemTestState> {
  final PaginationResponseModel<ItemTestPaginationModel>? lastItemTestList;
  final DashboardRepository _dashboardRepository;

  ItemTestBloc(this.lastItemTestList, this._dashboardRepository)
    : super(const ItemTestState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      // final PaginationResponseModel<ItemTestPaginationModel> itemTests =
      //     await _dashboardRepository.getItemTests(
      //       BaseListRequestModel.initial(),
      //     );
      emit(
        state.copyWith(
          itemTestList: lastItemTestList,
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
      final PaginationResponseModel<ItemTestPaginationModel> itemTests =
          await _dashboardRepository.getItemTestPagination(
            BaseListRequestModel.initial(),
          );
      emit(
        state.copyWith(
          itemTestList: itemTests,
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
    final PaginationResponseModel<ItemTestPaginationModel>?
    currentItemTestList = state.itemTestList;
    final BaseListRequestModel? currentRequestModel = state.listRequestModel;

    if (currentItemTestList == null || currentRequestModel == null) {
      return;
    }

    final int currentPage = currentItemTestList.pagination.currentPage;
    final int totalPages = currentItemTestList.pagination.totalPages;
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
      final PaginationResponseModel<ItemTestPaginationModel> nextPageResponse =
          await _dashboardRepository.getItemTestPagination(nextPageRequest);

      final List<ItemTestPaginationModel> allItems = <ItemTestPaginationModel>[
        ...currentItemTestList.items,
        ...nextPageResponse.items,
      ];

      final PaginationResponseModel<ItemTestPaginationModel>
      mergedItemResponse = PaginationResponseModel<ItemTestPaginationModel>(
        items: allItems,
        pagination: nextPageResponse.pagination,
      );

      emit(
        state.copyWith(
          itemTestList: mergedItemResponse,
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

      final PaginationResponseModel<ItemTestPaginationModel> itemTestList =
          await _dashboardRepository.getItemTestPagination(listRequestModel);

      emit(
        state.copyWith(
          latestUpdate: DateTime.now(),
          listRequestModel: listRequestModel,
          itemTestList: itemTestList,
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
