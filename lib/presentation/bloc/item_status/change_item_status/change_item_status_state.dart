part of 'change_item_status_bloc.dart';

class ChangeItemStatusState extends Equatable {
  final ItemModel? itemModel;
  final ItemTestModel? itemTestModel;
  final String? selectedConditionId;
  final String? selectedConditionCategoryId;
  final String? scannedBarcode;
  final String? errorMessage;
  final List<ConditionPaginatedModel> conditions;
  final List<ConditionCategoryPaginatedModel> conditionCategories;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus submitStatus;

  const ChangeItemStatusState({
    this.itemModel,
    this.itemTestModel,
    this.selectedConditionId,
    this.selectedConditionCategoryId,
    this.errorMessage,
    this.scannedBarcode,
    this.conditions = const <ConditionPaginatedModel>[],
    this.conditionCategories = const <ConditionCategoryPaginatedModel>[],
    this.status = FormzSubmissionStatus.initial,
    this.submitStatus = FormzSubmissionStatus.initial,
  });

  ChangeItemStatusState copyWith({
    ItemModel? itemModel,
    ItemTestModel? itemTestModel,
    String? selectedConditionId,
    String? selectedConditionCategoryId,
    String? errorMessage,
    String? scannedBarcode,
    List<ConditionPaginatedModel>? conditions,
    List<ConditionCategoryPaginatedModel>? conditionCategories,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? submitStatus,

    bool setItemModelToNull = false,
    bool setItemTestModelToNull = false,
    bool setSelectedConditionIdToNull = false,
    bool setSelectedConditionCategoryIdToNull = false,
    bool setErrorMessageToNull = false,
    bool setScannedBarcodeToNull = false,
  }) => ChangeItemStatusState(
      itemModel: setItemModelToNull ? null : (itemModel ?? this.itemModel),
      itemTestModel: setItemTestModelToNull ? null : (itemTestModel ?? this.itemTestModel),
      selectedConditionId: setSelectedConditionIdToNull ? null : (selectedConditionId ?? this.selectedConditionId),
      selectedConditionCategoryId: setSelectedConditionCategoryIdToNull ? null : (selectedConditionCategoryId ?? this.selectedConditionCategoryId),
      errorMessage: setErrorMessageToNull ? null : (errorMessage ?? this.errorMessage),
      scannedBarcode: setScannedBarcodeToNull ? null : (scannedBarcode ?? this.scannedBarcode),
      conditions: conditions ?? this.conditions,
      conditionCategories: conditionCategories ?? this.conditionCategories,
      status: status ?? this.status,
      submitStatus: submitStatus ?? this.submitStatus,
    );

  @override
  List<Object?> get props => [
    itemModel,
    itemTestModel,
    selectedConditionId,
    selectedConditionCategoryId,
    errorMessage,
    conditions,
    conditionCategories,
    status,
    scannedBarcode,
    submitStatus,
  ];
}
