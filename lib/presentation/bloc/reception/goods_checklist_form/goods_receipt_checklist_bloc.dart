import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/file_constants.dart';
import '../../../../core/utils/app/app_status.dart';
import '../../../../core/utils/app_util.dart';
import '../../../../core/utils/formz.dart';
import '../../../../core/utils/validations/default_validator.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/item_vendor_checklist/item_vendor_checklist_model.dart';
import '../../../../data/models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../../../../data/models/item_vendor_item_vendor_checklist/item_vendor_item_vendor_checklist_param.dart';
import '../../../../data/models/item_vendor_reception/item_vendor_reception_model.dart';
import '../../../../data/models/item_vendor_reception/item_vendor_reception_param.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../domain/repositories/file_repository.dart';
import '../../../../domain/repositories/item_vendor_checklist_repository.dart';
import '../../../../domain/repositories/item_vendor_reception_repository.dart';

part 'goods_receipt_checklist_state.dart';

class GoodsChecklistFormBloc extends Cubit<GoodsChecklistFormState> {
  final ItemVendorReceptionRepository itemVendorReceptionRepository;
  final ItemVendorChecklistRepository itemVendorChecklistRepository;
  final FileRepository fileRepository;

  GoodsChecklistFormBloc(this.itemVendorReceptionRepository, this.itemVendorChecklistRepository, this.fileRepository)
      : super(const GoodsChecklistFormState());

  Future<void> initial(String id) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final PaginationResponseModel<ItemVendorChecklistPaginatedModel> itemVendorChecklistModel = await itemVendorChecklistRepository.getList(BaseListRequestModel.initial());
      final ItemVendorReceptionModel result = await itemVendorReceptionRepository.getDetail(id);

      List<ItemVendorItemVendorChecklistParam> selectedChecklist = result.checklists.map((e) => ItemVendorItemVendorChecklistParam(
        id: e.id,
        itemVendorChecklistId: e.itemVendorChecklistId,
        note: e.note,
        isSuitable: e.isSuitable,
      ),).toList();

      if (result.checklists.isEmpty) {
        selectedChecklist = itemVendorChecklistModel.items.map((e) => ItemVendorItemVendorChecklistParam(
            itemVendorChecklistId: e.id,
        )).toList();
      }

      final List<String> selectedImage = [];

      if (result.deliveryNoteImagePath.isNotEmpty) {
        selectedImage.add(result.deliveryNoteImagePath);
      }

      emit(state.copyWith(
        status: AppStatus.success,
        deliveryNoteNumber: DefaultValidator.dirty(result.deliveryNoteNumber),
        reasonInput: DefaultValidator.dirty(result.reasonRejected),
        selectedChecklist: selectedChecklist,
        itemVendorReception: result,
        itemVendorChecklistPaginated: itemVendorChecklistModel.items,
        selectedImage: selectedImage
      ));

      emit(state.copyWith(
        statusAllSuitable: checkChecklistValidation(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateChecklistItem(ItemVendorItemVendorChecklistParam updatedItem) {
    final List<ItemVendorItemVendorChecklistParam> currentList = List<ItemVendorItemVendorChecklistParam>.from(
        state.selectedChecklist ?? []);

    final int index = currentList.indexWhere(
            (ItemVendorItemVendorChecklistParam item) => item.itemVendorChecklistId == updatedItem.itemVendorChecklistId);

    if (index >= 0) {
      currentList[index] = updatedItem;
    } else {
      currentList.add(updatedItem);
    }

    emit(state.copyWith(
      selectedChecklist: currentList
    ),);

    emit(state.copyWith(
      statusAllSuitable: checkChecklistValidation(),
    ));
  }

  Future<void> submit() async {
    try {
      if (state.selectedImage.isEmpty) {
        throw Exception('Dokumentasi Surat Jalan Tidak Boleh Kosong');
      }
      emit(state.copyWith(
        submitStatus: FormzSubmissionStatus.inProgress
      ));

      String? imageUpload;

      if (!AppUtil.isNetworkImage(state.selectedImage.first)) {
        imageUpload = await fileRepository.uploadSingleFile(FileConstants.folderItemReception, state.selectedImage.first);
      }

      final ItemVendorReceptionParam data = ItemVendorReceptionParam(
        deliveryNoteNumber: state.deliveryNoteNumber.value,
        deliveryNoteImagePath: imageUpload ?? state.selectedImage.first,
        reasonRejected: state.reasonInput.value,
          checklists: state.selectedChecklist ?? [],
      );
      await itemVendorReceptionRepository.updateChecklist(state.itemVendorReception?.id ?? '', data);

      emit(state.copyWith(
          submitStatus: FormzSubmissionStatus.success
      ));
    } catch(e) {
      print(e.toString());
      emit(state.copyWith(
        errorMessage: e.toString(),
          submitStatus: FormzSubmissionStatus.failure
      ));
      rethrow;
    }
  }

  void changeReasonInput(String? value) {
    emit(state.copyWith(
        reasonInput: DefaultValidator.dirty(value ?? ''))
    );
  }

  void changeDeliveryNoteNumber(String? value) {
    emit(state.copyWith(
        deliveryNoteNumber: DefaultValidator.dirty(value ?? '')));
  }

  bool? checkChecklistValidation() {
    final List<ItemVendorItemVendorChecklistParam>? checklists = state.selectedChecklist;

    if (checklists == null || checklists.isEmpty) return null;

    for (final ItemVendorItemVendorChecklistParam checklist in checklists) {
      if (checklist.isSuitable == null) {
        return null;
      }
    }
    final bool allTrue = checklists.every((c) => c.isSuitable == true);
    return allTrue;
  }


  bool get isValid => Formz.validate([state.deliveryNoteNumber, state.reasonInput]);

  void updateSelectedImage(List<String> imagePaths) {
    emit(state.copyWith(selectedImage: imagePaths));
  }
}
