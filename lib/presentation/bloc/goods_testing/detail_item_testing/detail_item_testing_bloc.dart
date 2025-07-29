import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/formz.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/condition/condition_paginated_model.dart';
import '../../../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../../../data/models/item/item_maintenance_model.dart';
import '../../../../data/models/item/item_test_inspection_model.dart';
import '../../../../data/models/item/item_test_inspection_param.dart';
import '../../../../data/models/item/item_test_inspection_parameter_param.dart';
import '../../../../data/models/item/item_test_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../../../../data/models/tools_status/tool_status_paginated_model.dart';
import '../../../../data/request/item_test/create_item_test_inspection_image_request.dart';
import '../../../../data/request/item_test/create_item_test_inspection_parameter_request.dart';
import '../../../../data/request/item_test/create_item_test_inspection_request.dart';
import '../../../../data/request/item_test/create_item_test_request.dart';
import '../../../../domain/repositories/condition_category_repository.dart';
import '../../../../domain/repositories/condition_repository.dart';
import '../../../../domain/repositories/file_repository.dart';
import '../../../../domain/repositories/item_test_repository.dart';
import '../../../../domain/repositories/tool_status_repository.dart';

part 'detail_item_testing_state.dart';

class DetailItemTestingBloc extends Cubit<DetailItemTestingState> {
  final ItemTestModel itemTestModel;
  final ItemTestRepository itemTestRepository;
  final ToolStatusRepository toolStatusRepository;
  final ConditionRepository conditionRepository;
  final ConditionCategoryRepository conditionCategoryRepository;
  final FileRepository fileRepository;

  DetailItemTestingBloc(
    this.itemTestModel,
    this.itemTestRepository,
    this.toolStatusRepository,
    this.conditionRepository,
    this.conditionCategoryRepository,
      this.fileRepository
  ) : super(DetailItemTestingState(item: itemTestModel));

  Future<void> initial() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final List<ItemMaintenanceModel> itemMaintenance = await itemTestRepository.getHistories(itemTestModel.barcode ?? '');
      final List<ItemTestInspectionParam> currentList =
          List<ItemTestInspectionParam>.from(
            state.item.itemInspections.map(
              (ItemTestInspectionModel e) =>
                  ItemTestInspectionParam(inspectionId: e.id),
            ),
          );

      for (ItemTestInspectionModel e in itemTestModel.itemInspections) {
        final int existingIndex = currentList.indexWhere(
          (ItemTestInspectionParam element) => element.inspectionId == e.id,
        );

        final List<ItemTestInspectionParameterParam> parameters =
            e.parameters
                .map(
                  (p) => ItemTestInspectionParameterParam(
                    inspectionParameterId: p.id,
                    inspectionParameterName: p.name,
                  ),
                )
                .toList();

        if (existingIndex != -1) {
          final ItemTestInspectionParam existingItem =
              currentList[existingIndex];
          currentList[existingIndex] = existingItem.copyWith(
            inspectionName: e.name,
            itemTestInspectionParameters: parameters,
          );
        } else {
          currentList.add(
            ItemTestInspectionParam(
              inspectionId: e.id,
              inspectionName: e.name,
              itemTestInspectionParameters: parameters,
            ),
          );
        }
      }

      final PaginationResponseModel<ToolStatusPaginatedModel> toolStatuses =
          await toolStatusRepository.getList(BaseListRequestModel.initial());

      final PaginationResponseModel<ConditionPaginatedModel> listCondition =
      await conditionRepository.getList(BaseListRequestModel.initial(pageSize: 20));
      final PaginationResponseModel<ConditionCategoryPaginatedModel> listConditionCategory =
      await conditionCategoryRepository.getList(BaseListRequestModel(pagination: PaginationRequestModel(), filters: [])
          .copyWith(sort: [SortRequestModel(field: 'createdDate', direction: 'asc')]));

      final List<ConditionCategoryPaginatedModel> newList = listConditionCategory.items.where((e) => e.code != 'tidak-aktif').toList();

      final List<TextEditingController> noteControllers = List.generate(
        state.listItemTestInspectionParam.length,
            (int index) => TextEditingController(),
      );

      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          selectedConditionCategoryId: itemTestModel.condition?.conditionCategoryId,
          listToolStatus: toolStatuses.items,
          listCondition: listCondition.items,
          listConditionCategory: newList,
          listItemTestInspectionParam: currentList,
          listNoteControllers: noteControllers,
          itemMaintenance: itemMaintenance,
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

  void updateItem(String inspectionId, String id, bool? value) {
    final List<ItemTestInspectionParam> currentList =
        List<ItemTestInspectionParam>.from(state.listItemTestInspectionParam);

    final int existingIndex = currentList.indexWhere(
      (ItemTestInspectionParam element) => element.inspectionId == inspectionId,
    );
    if (existingIndex != -1) {
      final ItemTestInspectionParam existingItem = currentList[existingIndex];
      final List<ItemTestInspectionParameterParam> updatedParams = List.from(
        existingItem.itemTestInspectionParameters,
      );
      final int existingIndexParameter = currentList[existingIndex]
          .itemTestInspectionParameters
          .indexWhere(
            (ItemTestInspectionParameterParam element) =>
                element.inspectionParameterId == id,
          );
      if (existingIndexParameter != -1) {
        final targetParam = updatedParams[existingIndexParameter];
        updatedParams[existingIndexParameter] = targetParam.copyWith(
          isQualified: value,
        );

        currentList[existingIndex] = existingItem.copyWith(
          itemTestInspectionParameters: updatedParams,
        );
      }
    }

    emit(state.copyWith(
        listItemTestInspectionParam: currentList));
  }

  void updateNote(String inspectionId, String note) {
    final List<ItemTestInspectionParam> currentList =
        List<ItemTestInspectionParam>.from(state.listItemTestInspectionParam);

    final int existingIndex = currentList.indexWhere(
      (ItemTestInspectionParam element) => element.inspectionId == inspectionId,
    );
    if (existingIndex != -1) {
      final ItemTestInspectionParam existingItem = currentList[existingIndex];
      currentList[existingIndex] = existingItem.copyWith(note: note);
    }

    emit(state.copyWith(listItemTestInspectionParam: currentList));
    emit(state.copyWith(isValid: checkFormValidation(),));
  }

  void updateImageList(String inspectionId, List<String> imagePaths) {
    final List<ItemTestInspectionParam> currentList =
        List<ItemTestInspectionParam>.from(state.listItemTestInspectionParam);

    final int existingIndex = currentList.indexWhere(
      (ItemTestInspectionParam element) => element.inspectionId == inspectionId,
    );
    if (existingIndex != -1) {
      final ItemTestInspectionParam existingItem = currentList[existingIndex];
      currentList[existingIndex] = existingItem.copyWith(imageList: imagePaths);
    }

    emit(state.copyWith(
        listItemTestInspectionParam: currentList));
    emit(state.copyWith(isValid: checkFormValidation(),));
  }

  void updateSelectedToolStatus(String id) {
    emit(state.copyWith(
        selectedToolStatusId: id));
    emit(state.copyWith(isValid: checkFormValidation(),));
  }

  void updateSelectedCondition(String id) {
    emit(state.copyWith(
        selectedConditionId: id));
    emit(state.copyWith(isValid: checkFormValidation(),));
  }

  void updateSelectedConditionCategory(String id) {
    emit(state.copyWith(
      selectedConditionId: '',
        selectedConditionCategoryId: id));
    emit(state.copyWith(isValid: checkFormValidation(),));
  }

  Future<void> submit() async {
    try {
      emit(state.copyWith(formStatus: FormzSubmissionStatus.inProgress));

      final List<CreateItemTestInspectionRequest> inspectionRequests = [];

      for (final e in state.listItemTestInspectionParam) {
        final List<String> uploadedImagePaths = await fileRepository.uploadMultipleFile(
          'ItemTest',
          e.imageList,
        );

        final inspectionRequest = CreateItemTestInspectionRequest(
          inspectionId: e.inspectionId,
          note: e.note,
          itemTestInspectionParameters: e.itemTestInspectionParameters.map(
                (p) => CreateItemTestInspectionParameterRequest(
              inspectionParameterId: p.inspectionParameterId,
              isQualified: p.isQualified ?? false,
            ),
          ).toList(),
          itemTestInspectionImages: uploadedImagePaths.map(
                (path) => CreateItemTestInspectionImageRequest(imagePath: path),
          ).toList(),
        );

        inspectionRequests.add(inspectionRequest);
      }

      final CreateItemTestRequest request = CreateItemTestRequest(
        toolStatusId: state.selectedToolStatusId ?? '',
        conditionId: state.selectedConditionId ?? '',
        testedDate: DateTime.now(),
        itemTestInspections: inspectionRequests,
      );

      await itemTestRepository.update(state.item.barcode ?? '', request);

      emit(state.copyWith(formStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        formStatus: FormzSubmissionStatus.failure,
      ));
      rethrow;
    }
  }

  bool checkFormValidation() {
    bool status = true;
    if (state.selectedConditionId == null || (state.selectedConditionId ?? '').isEmpty) {
      status = false;
    }

    if (state.selectedToolStatusId == null || (state.selectedToolStatusId ?? '').isEmpty) {
      status = false;
    }

    if (state.selectedConditionCategoryId == null || (state.selectedConditionCategoryId ?? '').isEmpty) {
      status = false;
    }

    for (ItemTestInspectionParam e in state.listItemTestInspectionParam) {
      for (ItemTestInspectionParameterParam x in e.itemTestInspectionParameters) {
        if (x.isQualified == null) {
          status = false;
        }
      }
      if (e.note.isEmpty) {
        status = false;
      }
    }

    return status;
  }

}
