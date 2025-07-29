import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/condition/condition_paginated_model.dart';
import '../../../../data/models/condition_category/condition_category_model.dart';
import '../../../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../../../data/models/item/item_model.dart';
import '../../../../data/models/item/item_test_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/condition_category_repository.dart';
import '../../../../domain/repositories/condition_repository.dart';
import '../../../../domain/repositories/item_repository.dart';
import '../../../../domain/repositories/item_test_repository.dart';

part 'change_item_status_state.dart';

class ChangeItemStatusBloc extends Cubit<ChangeItemStatusState> {

  final ItemRepository itemRepository;
  final ItemTestRepository itemTestRepository;
  final ConditionRepository conditionRepository;
  final ConditionCategoryRepository conditionCategoryRepository;

  ChangeItemStatusBloc(this.itemRepository, this.conditionRepository,
      this.conditionCategoryRepository, this.itemTestRepository) : super(const ChangeItemStatusState());

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress, submitStatus: FormzSubmissionStatus.initial));
    try {
      final PaginationResponseModel<ConditionPaginatedModel> listConditions = await conditionRepository.getList(BaseListRequestModel.initial());
      final PaginationResponseModel<ConditionCategoryPaginatedModel> listConditionCategories = await conditionCategoryRepository.getList(BaseListRequestModel(pagination: PaginationRequestModel(), filters: [])
          .copyWith(sort: [SortRequestModel(field: 'createdDate', direction: 'asc')]));

      emit(state.copyWith(
        selectedConditionCategoryId: listConditionCategories.items.firstOrNull?.id,
        conditions: listConditions.items,
        conditionCategories: listConditionCategories.items.where((ConditionCategoryPaginatedModel e) => e.code != 'tidak-aktif').toList(),
        status: FormzSubmissionStatus.success,
      ));
    }
    catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
          status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> getItemData(String barcode) async {

    try {
      if (barcode.isEmpty) throw Exception('Barcode kosong');
      emit(state.copyWith(
        setItemModelToNull: true,
          scannedBarcode: barcode,
          submitStatus: FormzSubmissionStatus.initial,
          status: FormzSubmissionStatus.inProgress));

      final ItemModel itemModel = await itemRepository.getDetailBarcode(
          barcode);

      emit(state.copyWith(
        selectedConditionCategoryId: itemModel.condition?.conditionCategoryId,
        itemModel: itemModel, status: FormzSubmissionStatus.success,
      ),);
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          itemModel: null,
          status: FormzSubmissionStatus.failure),);
      rethrow;
    }
  }

  void updateSelectedConditionCategory(String conditionCategoryId) {
    emit(state.copyWith(selectedConditionCategoryId: conditionCategoryId));
  }

  Future<void> submit(bool isTest, { String? conditionId}) async {
    emit(state.copyWith(submitStatus: FormzSubmissionStatus.inProgress));
    try {
      if (isTest) {
        final ItemTestModel itemTest = await itemTestRepository.getDetailBarcode(state.scannedBarcode ?? '');
        emit(state.copyWith(itemTestModel: itemTest,itemModel: null));
      } else {
        await itemRepository.updateCondition(state.itemModel?.id ?? '', conditionId ?? '');
        emit(state.copyWith(
            status: FormzSubmissionStatus.initial,
            itemModel: null, selectedConditionId: null));
      }
      emit(state.copyWith(
          status: FormzSubmissionStatus.initial,
          submitStatus: FormzSubmissionStatus.success));
      await getItemData(state.scannedBarcode ?? '');
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          submitStatus: FormzSubmissionStatus.failure),);
    }
  }
}