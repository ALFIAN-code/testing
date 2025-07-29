import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/item_request_item_scan/item_request_item_scan_paginated_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/item_request_item_scan_repository.dart';

part 'detail_preparation_state.dart';

class DetailPreparationBloc extends Cubit<DetailPreparationState>{

  final String projectId;
  final ItemRequestItemScanRepository _itemRequestItemScanRepository;

  DetailPreparationBloc(this.projectId, this._itemRequestItemScanRepository) : super(const DetailPreparationState());

  FilterRequestModel get _defaultFilterItemRequest => FilterRequestModel(
      field: 'itemRequestItem.itemRequest.projectId',
      operator: 'eq',
      value: projectId,
  );

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final result = _itemRequestItemScanRepository.getList(BaseListRequestModel(
        pagination: PaginationRequestModel(),
        filters: [_defaultFilterItemRequest]
      ));

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch(e) {
      emit(state.copyWith(errorMessage: e.toString(), status: FormzSubmissionStatus.failure));
    }
  }
}