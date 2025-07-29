part of 'item_inspection_bloc.dart';

class ItemInspectionState extends Equatable {
  final ItemModel? itemModel;
  final String? scannedBarcode;
  final int totalNotSynchronized;
  final String? errorMessage;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus syncStatus;

  const ItemInspectionState({
    this.itemModel,
    this.errorMessage,
    this.scannedBarcode,
    this.totalNotSynchronized = 0,
    this.status = FormzSubmissionStatus.initial,
    this.syncStatus = FormzSubmissionStatus.initial,
  });

  ItemInspectionState copyWith({
    ItemModel? itemModel,
    String? errorMessage,
    int? totalNotSynchronized,
    String? scannedBarcode,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? syncStatus,

    bool setItemModelToNull = false,
    bool setErrorMessageToNull = false,
    bool setScannedBarcodeToNull = false,
  }) => ItemInspectionState(
      itemModel: setItemModelToNull ? null : (itemModel ?? this.itemModel),
      errorMessage: setErrorMessageToNull ? null : (errorMessage ?? this.errorMessage),
      scannedBarcode: setScannedBarcodeToNull ? null : (scannedBarcode ?? this.scannedBarcode),
      totalNotSynchronized: totalNotSynchronized ?? this.totalNotSynchronized,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
    );

  @override
  List<Object?> get props => [
    itemModel,
    errorMessage,
    status,
    totalNotSynchronized,
    scannedBarcode,
    syncStatus,
  ];
}
