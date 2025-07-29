part of 'detail_item_testing_bloc.dart';

class DetailItemTestingState extends Equatable {
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus formStatus;
  final String? errorMessage;
  final ItemTestModel item;
  final String? selectedToolStatusId;
  final String? selectedConditionId;
  final String? selectedConditionCategoryId;
  final List<ItemTestInspectionParam> listItemTestInspectionParam;
  final List<ToolStatusPaginatedModel>? listToolStatus;
  final List<ConditionPaginatedModel>? listCondition;
  final List<ConditionCategoryPaginatedModel>? listConditionCategory;
  final List<TextEditingController> listNoteControllers;
  final List<ItemMaintenanceModel>? itemMaintenance;
  final bool isValid;

  const DetailItemTestingState({
    required this.item,
    this.status = FormzSubmissionStatus.initial,
    this.formStatus = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.selectedToolStatusId,
    this.selectedConditionId,
    this.selectedConditionCategoryId,
    this.listToolStatus,
    this.listItemTestInspectionParam = const <ItemTestInspectionParam>[],
    this.listCondition,
    this.listConditionCategory,
    this.listNoteControllers = const <TextEditingController>[],
    this.itemMaintenance,
    this.isValid = false,
  });

  DetailItemTestingState copyWith({
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? formStatus,
    String? errorMessage,
    ItemTestModel? item,
    String? selectedToolStatusId,
    String? selectedConditionId,
    String? selectedConditionCategoryId,
    List<ItemTestInspectionParam>? listItemTestInspectionParam,
    List<ToolStatusPaginatedModel>? listToolStatus,
    List<ConditionPaginatedModel>? listCondition,
    List<ConditionCategoryPaginatedModel>? listConditionCategory,
    List<TextEditingController>? listNoteControllers,
    List<ItemMaintenanceModel>? itemMaintenance,
    bool? isValid,
  }) =>
      DetailItemTestingState(
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        item: item ?? this.item,
        selectedToolStatusId: selectedToolStatusId ?? this.selectedToolStatusId,
        selectedConditionId: selectedConditionId ?? this.selectedConditionId,
        selectedConditionCategoryId: selectedConditionCategoryId ?? this.selectedConditionCategoryId,
        listItemTestInspectionParam: listItemTestInspectionParam ?? this.listItemTestInspectionParam,
        listToolStatus: listToolStatus ?? this.listToolStatus,
        listCondition: listCondition ?? this.listCondition,
        listConditionCategory: listConditionCategory ?? this.listConditionCategory,
        listNoteControllers: listNoteControllers ?? this.listNoteControllers,
          itemMaintenance: itemMaintenance ?? this.itemMaintenance,
        isValid: isValid ?? this.isValid
      );

  @override
  List<Object?> get props => <Object?>[
    status,
    formStatus,
    errorMessage,
    item,
    selectedToolStatusId,
    selectedConditionId,
    selectedConditionCategoryId,
    listToolStatus,
    listItemTestInspectionParam,
    listCondition,
    listConditionCategory,
    listNoteControllers,
    itemMaintenance,
    isValid
  ];
}