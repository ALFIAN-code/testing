part of 'detail_item_return_bloc.dart';

class DetailItemReturnState extends Equatable {
  final String? scannedItem;
  final String? scannedRequestId;
  final int? totalNotSynchronized;
  final String? errorMessage;
  final FormzSubmissionStatus syncStatus;
  final FormzSubmissionStatus scanStatus;

  const DetailItemReturnState({
    this.scannedItem,
    this.scannedRequestId,
    this.errorMessage,
    this.totalNotSynchronized,
    this.syncStatus = FormzSubmissionStatus.initial,
    this.scanStatus = FormzSubmissionStatus.initial,
  });

  DetailItemReturnState copyWith({
    String? scannedItem,
    String? scannedRequestId,
    int? totalNotSynchronized,
    String? errorMessage,
    FormzSubmissionStatus? syncStatus,
    FormzSubmissionStatus? scanStatus,
    bool resetScannedItem = false,
    bool resetScannedRequestId = false,
  }) => DetailItemReturnState(
      scannedItem: resetScannedItem ? null : scannedItem ?? this.scannedItem,
      scannedRequestId: resetScannedRequestId
          ? null
          : scannedRequestId ?? this.scannedRequestId,
      totalNotSynchronized: totalNotSynchronized ?? this.totalNotSynchronized,
      errorMessage: errorMessage ?? this.errorMessage,
      syncStatus: syncStatus ?? this.syncStatus,
      scanStatus: scanStatus ?? this.scanStatus,
    );

  @override
  List<Object?> get props => [
        scannedItem,
        scannedRequestId,
        totalNotSynchronized,
        errorMessage,
        syncStatus,
        scanStatus,
      ];
}