import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app/app_status.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/item_vendor_condition/item_vendor_condition_paginated_model.dart';
import '../../../../data/models/item_vendor_reception/item_vendor_reception_paginated_model.dart';
import '../../../../data/models/item_vendor_status/item_vendor_status_paginated_model.dart';
import '../../../../data/models/pagination_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/entities/vendor_goods_reception_entity.dart';
import '../../../../domain/repositories/item_vendor_condition_repository.dart';
import '../../../../domain/repositories/item_vendor_reception_repository.dart';
import '../../../../domain/repositories/item_vendor_status_repository.dart';

part 'vendor_goods_reception_event.dart';
part 'vendor_goods_reception_state.dart';

class VendorGoodsReceptionBloc extends Cubit<VendorGoodsReceptionState> {

  final ItemVendorReceptionRepository itemVendorReceptionRepository;
  final ItemVendorConditionRepository itemVendorConditionRepository;
  final ItemVendorStatusRepository itemVendorStatusRepository;

  VendorGoodsReceptionBloc(
      this.itemVendorReceptionRepository,
      this.itemVendorConditionRepository,
      this.itemVendorStatusRepository,) :  super(const VendorGoodsReceptionState());

  Future<void> initial() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      BaseListRequestModel listRequestModel = BaseListRequestModel.initial();

      final PaginationResponseModel<ItemVendorConditionPaginatedModel> listCondition =
      await itemVendorConditionRepository.getList(listRequestModel);

      final PaginationResponseModel<ItemVendorStatusPaginatedModel> listStatus =
      await itemVendorStatusRepository.getList(listRequestModel);

      final PaginationResponseModel<ItemVendorReceptionPaginatedModel> listReception =
      await itemVendorReceptionRepository.getList(listRequestModel);

      emit(state.copyWith(
        latestUpdate: DateTime.now(),
        listRequestModel: listRequestModel,
          listItemCondition: listCondition.items,
          listItemStatus: listStatus.items,
          listItemReception: listReception,
          status: AppStatus.success,),);
    } catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(), status: AppStatus.failure,),);
      rethrow;
    }
  }

  String getStatusFilter() {
    final filters = state.listRequestModel?.filters ?? <FilterRequestModel>[];

    final statusFilter = filters.firstWhere(
          (f) => f.field == 'itemStatus',
      orElse: () => FilterRequestModel(
        field: 'itemStatus',
        operator: 'eq',
        value: '',
      ),
    );

    return statusFilter.value.trim();
  }


  void setFilter(String field, String? value) {
    final BaseListRequestModel? currentRequest = state.listRequestModel;
    if (currentRequest == null) return;

    final List<FilterRequestModel> filters = List.from(currentRequest.filters ?? []);

    filters.removeWhere((FilterRequestModel f) => f.field == field);

    if (value != null) {
      final String trimmedValue = value.trim();
      if (trimmedValue.isNotEmpty && trimmedValue != 'Semua') {
        filters.add(FilterRequestModel(
          field: field,
          operator: 'eq',
          value: trimmedValue,
        ));
      }
    }

    emit(state.copyWith(
      listRequestModel: currentRequest.copyWith(

          filters: filters),
    ));
  }

  void load(BaseListRequestModel listRequest) async {
    try {
      emit(state.copyWith(
        listRequestModel: listRequest.copyWith(
          pagination: PaginationRequestModel(),
        ),
          listItemReception: null,
          status: AppStatus.loading));

      final BaseListRequestModel listRequestModel = state.listRequestModel ?? BaseListRequestModel.initial();

      final PaginationResponseModel<ItemVendorReceptionPaginatedModel> listReception =
          await itemVendorReceptionRepository.getList(listRequestModel);

      emit(state.copyWith(
        latestUpdate: DateTime.now(),
        listRequestModel: listRequestModel,
        listItemReception: listReception,
        status: AppStatus.success,),);
    } catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(), status: AppStatus.failure,),);
      rethrow;
    }
  }

  Future<void> fetchMoreReceptions() async {
    final resp = state.listItemReception;
    final request = state.listRequestModel;
    if (resp == null || request == null) return;

    final current = resp.pagination.currentPage;
    final total = resp.pagination.totalPages;
    if (current >= total) return;

    final nextPageRequest = request.copyWith(
      pagination: PaginationRequestModel(page: current + 1, pageSize: request.pagination.pageSize),
    );

    emit(state.copyWith(
      statusLoadMore: AppStatus.loading,
      listRequestModel: nextPageRequest,
    ));

    try {
      final nextResp = await itemVendorReceptionRepository.getList(nextPageRequest);

      final allItems = [...resp.items, ...nextResp.items];
      final merged = PaginationResponseModel<ItemVendorReceptionPaginatedModel>(
        items: allItems,
        pagination: nextResp.pagination,
      );

      emit(state.copyWith(
        statusLoadMore: AppStatus.success,
        listItemReception: merged,
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
          listItemReception: null,
          status: AppStatus.loading));

      final BaseListRequestModel listRequestModel = state.listRequestModel ?? BaseListRequestModel.initial();

      final PaginationResponseModel<ItemVendorReceptionPaginatedModel> listReception =
          await itemVendorReceptionRepository.getList(listRequestModel);

      emit(state.copyWith(
        latestUpdate: DateTime.now(),
        listRequestModel: listRequestModel,
        listItemReception: listReception,
        status: AppStatus.success,),);
    } catch(e) {
      emit(state.copyWith(
        errorMessage: e.toString(), status: AppStatus.failure,),);
      rethrow;
    }
  }
}
