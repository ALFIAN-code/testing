import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/dashboard/item_vendor_arrival_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/dashboard_repository.dart';

part 'item_vendor_arrival_state.dart';

class ItemVendorArrivalBloc extends Cubit<ItemVendorArrivalState> {
  final PaginationResponseModel<ItemVendorArrivalModel>? lastItemVendorArrivalList;
  final DashboardRepository _dashboardRepository;

  ItemVendorArrivalBloc(this.lastItemVendorArrivalList, this._dashboardRepository)
    : super(const ItemVendorArrivalState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      emit(
        state.copyWith(
          itemTestList: lastItemVendorArrivalList,
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
      final PaginationResponseModel<ItemVendorArrivalModel> itemTests =
          await _dashboardRepository.getItemVendorArrivalPagination(
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
    final PaginationResponseModel<ItemVendorArrivalModel>?
    currentItemVendorArrivalList = state.itemTestList;
    final BaseListRequestModel? currentRequestModel = state.listRequestModel;

    if (currentItemVendorArrivalList == null || currentRequestModel == null) {
      return;
    }

    final int currentPage = currentItemVendorArrivalList.pagination.currentPage;
    final int totalPages = currentItemVendorArrivalList.pagination.totalPages;
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
      final PaginationResponseModel<ItemVendorArrivalModel> nextPageResponse =
          await _dashboardRepository.getItemVendorArrivalPagination(nextPageRequest);

      final List<ItemVendorArrivalModel> allItems = <ItemVendorArrivalModel>[
        ...currentItemVendorArrivalList.items,
        ...nextPageResponse.items,
      ];

      final PaginationResponseModel<ItemVendorArrivalModel>
      mergedItemResponse = PaginationResponseModel<ItemVendorArrivalModel>(
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

      final PaginationResponseModel<ItemVendorArrivalModel> itemTestList =
          await _dashboardRepository.getItemVendorArrivalPagination(listRequestModel);

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
