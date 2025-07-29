part of 'goods_receipt_checklist_bloc.dart';

class GoodsChecklistFormState extends Equatable {
  const GoodsChecklistFormState({
    this.itemVendorReception,
    this.itemVendorReceptionParam,
    this.statusAllSuitable,
    this.selectedChecklist = const <ItemVendorItemVendorChecklistParam>[],
    this.errorMessage,
    this.reasonInput = const DefaultValidator.pure(),
    this.status = AppStatus.initial,
    this.submitStatus = FormzSubmissionStatus.initial,
    this.itemVendorChecklistPaginated,
    this.deliveryNoteNumber = const DefaultValidator.pure(),
    this.selectedImage = const <String>[]
  });

  final ItemVendorReceptionModel? itemVendorReception;
  final ItemVendorReceptionParam? itemVendorReceptionParam;
  final String? errorMessage;
  final bool? statusAllSuitable;
  final DefaultValidator reasonInput;
  final AppStatus status;
  final FormzSubmissionStatus submitStatus;
  final DefaultValidator deliveryNoteNumber;
  final List<ItemVendorChecklistPaginatedModel>? itemVendorChecklistPaginated;
  final List<ItemVendorItemVendorChecklistParam>? selectedChecklist;
  final List<String> selectedImage;

  GoodsChecklistFormState copyWith({
    ItemVendorReceptionModel? itemVendorReception,
    ItemVendorReceptionParam? itemVendorReceptionParam,
    String? errorMessage,
    FormzSubmissionStatus? submitStatus,
    DefaultValidator? reasonInput,
    List<ItemVendorItemVendorChecklistParam>? selectedChecklist,
    bool? statusAllSuitable,
    AppStatus? status,
    List<ItemVendorChecklistPaginatedModel>? itemVendorChecklistPaginated,
    DefaultValidator? deliveryNoteNumber,
    List<String>? selectedImage,
  }) => GoodsChecklistFormState(
      itemVendorReception: itemVendorReception ?? this.itemVendorReception,
      itemVendorReceptionParam: itemVendorReceptionParam ?? this.itemVendorReceptionParam,
      statusAllSuitable: statusAllSuitable ?? this.statusAllSuitable,
      errorMessage: errorMessage ?? this.errorMessage,
      reasonInput: reasonInput ?? this.reasonInput,
      submitStatus: submitStatus ?? this.submitStatus,
      selectedChecklist: selectedChecklist ?? this.selectedChecklist,
      status: status ?? this.status,
    itemVendorChecklistPaginated: itemVendorChecklistPaginated ?? this.itemVendorChecklistPaginated,
    deliveryNoteNumber: deliveryNoteNumber ?? this.deliveryNoteNumber,
    selectedImage: selectedImage ?? this.selectedImage

    );

  @override
  List<Object?> get props => <Object?>[
    itemVendorReception,
    itemVendorReceptionParam,
    errorMessage,
    reasonInput,
    selectedChecklist,
    status,
    submitStatus,
    statusAllSuitable,
    itemVendorChecklistPaginated,
    deliveryNoteNumber,
    selectedImage
  ];
}
