import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/app/app_status.dart';
import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/condition/condition_paginated_model.dart';
import '../../../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../../../data/models/item/item_paginated_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/condition_category_repository.dart';
import '../../../../domain/repositories/condition_repository.dart';
import '../../../../domain/repositories/item_repository.dart';

part 'list_item_state.dart';

class ListItemBloc extends Cubit<ListItemState> {
  final ItemRepository itemRepository;
  final ConditionRepository conditionRepository;
  final ConditionCategoryRepository conditionCategoryRepository;

  ListItemBloc(this.itemRepository, this.conditionRepository, this.conditionCategoryRepository):super(const ListItemState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final List<dynamic> results = await Future.wait([
        conditionRepository.getListLocal(),
        conditionCategoryRepository.getListLocal(),
        itemRepository.getList(BaseListRequestModel.initial()),
      ]);
      final List<ConditionPaginatedModel> conditions = results[0] as List<ConditionPaginatedModel>;
      final List<ConditionCategoryPaginatedModel> conditionCategories = results[1] as List<ConditionCategoryPaginatedModel>;
      final PaginationResponseModel<ItemPaginatedModel> items = results[2] as PaginationResponseModel<ItemPaginatedModel>;
      emit(state.copyWith(
        listCondition: conditions,
        listConditionCategory: conditionCategories,
        listItem: items,
        latestUpdate: DateTime.now(),
        listRequestModel: BaseListRequestModel.initial(),
        status: FormzSubmissionStatus.success,
      ));
    }
    catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        status: FormzSubmissionStatus.failure,
      ));
      rethrow;
    }
  }

  void setFilter(String field, String value) {
    final List<FilterRequestModel> newFilters = List.from(state.listRequestModel?.filters ?? []);

    if (field == 'condition.conditionCategoryId') {
      newFilters.removeWhere((FilterRequestModel filter) => filter.field == 'condition.id');
    }

    newFilters.removeWhere((FilterRequestModel filter) => filter.field == field);
    newFilters.add(FilterRequestModel(field: field, value: value, operator: 'eq'));

    newFilters.removeWhere((FilterRequestModel filter) => filter.value.isEmpty);

    emit(state.copyWith(
      listRequestModel: (state.listRequestModel ?? BaseListRequestModel.initial()).copyWith(
        filters: newFilters,
      ),
    ));
    load();
  }

  void load() async {
    try {
      emit(state.copyWith(
          status: FormzSubmissionStatus.inProgress,
      ));

      final PaginationResponseModel<ItemPaginatedModel> listItem =  await itemRepository.getList(state.listRequestModel ?? BaseListRequestModel.initial());

      emit(state.copyWith(
        latestUpdate: DateTime.now(),
        listItem: listItem,
        status: FormzSubmissionStatus.success,),);
    } catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(), status: FormzSubmissionStatus.failure,),);
      rethrow;
    }
  }

  Future<void> fetchMoreItems() async {
    final PaginationResponseModel<ItemPaginatedModel>? currentItemResponse = state.listItem;
    final BaseListRequestModel? currentRequestModel = state.listRequestModel;

    if (currentItemResponse == null || currentRequestModel == null) {
      return;
    }

    final int currentPage = currentItemResponse.pagination.currentPage;
    final int totalPages = currentItemResponse.pagination.totalPages;
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
      statusLoadMore: AppStatus.loading,
    ));

    try {
      final PaginationResponseModel<ItemPaginatedModel> nextPageResponse = await itemRepository.getList(nextPageRequest);
      final List<ItemPaginatedModel> allItems = <ItemPaginatedModel>[...currentItemResponse.items, ...nextPageResponse.items];

      final PaginationResponseModel<ItemPaginatedModel> mergedItemResponse = PaginationResponseModel<ItemPaginatedModel>(
        items: allItems,
        pagination: nextPageResponse.pagination,
      );

      emit(state.copyWith(
        listItem: mergedItemResponse,
        latestUpdate: DateTime.now(),
        statusLoadMore: AppStatus.success,
        errorMessage: null,
      ));

    } catch (e) {
      emit(state.copyWith(
        statusLoadMore: AppStatus.failure,
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

      final PaginationResponseModel<ItemPaginatedModel> listItem =
      await itemRepository.getList(listRequestModel);

      emit(state.copyWith(
        latestUpdate: DateTime.now(),
        listRequestModel: listRequestModel,
        listItem: listItem,
        status: FormzSubmissionStatus.success,),);
    } catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(), status: FormzSubmissionStatus.failure,),);
      rethrow;
    }
  }
}