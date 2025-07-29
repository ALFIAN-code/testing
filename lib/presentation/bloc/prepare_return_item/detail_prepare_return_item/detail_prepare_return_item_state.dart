part of 'detail_prepare_return_item_bloc.dart';

class DetailPrepareReturnItemState extends Equatable {
  final PrepareReturnItemPaginatedModel? project;
  final String? scannedItem;
  final String? scannedRequestId;
  final int? totalScanned;
  final int? totalNotSynchronized;
  final GetScannedItemListRequest? listRequestModel;
  final FormzSubmissionStatus scanStatus;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus deleteStatus;
  final FormzSubmissionStatus syncStatus;
  final ScanStatusCountModel? scanStatusCount;
  final List<ScannedItemListModel> listScanned;
  final String? errorMessage;

  const DetailPrepareReturnItemState({
    this.project,
    this.scannedItem,
    this.scannedRequestId,
    this.totalNotSynchronized,
    this.totalScanned,
    this.listRequestModel,
    this.scanStatus = FormzSubmissionStatus.initial,
    this.deleteStatus = FormzSubmissionStatus.initial,
    this.syncStatus = FormzSubmissionStatus.initial,
    this.status = FormzSubmissionStatus.initial,
    this.listScanned = const <ScannedItemListModel>[],
    this.scanStatusCount,
    this.errorMessage,
  });

  DetailPrepareReturnItemState copyWith({
    PrepareReturnItemPaginatedModel? project,
    String? scannedItem,
    String? scannedRequestId,
    int? totalNotSynchronized,
    int? totalScanned,
    GetScannedItemListRequest? listRequestModel,
    FormzSubmissionStatus? scanStatus,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? deleteStatus,
    FormzSubmissionStatus? syncStatus,
    ScanStatusCountModel? scanStatusCount,
    List<ScannedItemListModel>? listScanned,
    String? errorMessage,

    bool resetScannedItem = false,
    bool resetScannedRequestId = false,
  }) => DetailPrepareReturnItemState(
      project: project ?? this.project,
      scannedItem: resetScannedItem ? null : (scannedItem ?? this.scannedItem),
      scannedRequestId: resetScannedRequestId ? null : (scannedRequestId ?? this.scannedRequestId),
      totalNotSynchronized: totalNotSynchronized ?? this.totalNotSynchronized,
      totalScanned: totalScanned ?? this.totalScanned,
      listRequestModel: listRequestModel ?? this.listRequestModel,
      scanStatus: scanStatus ?? this.scanStatus,
      status: status ?? this.status,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      scanStatusCount: scanStatusCount ?? this.scanStatusCount,
      listScanned: listScanned ?? this.listScanned,
      errorMessage: errorMessage ?? this.errorMessage,
    );

  @override
  List<Object?> get props => [
    project,
    scannedItem,
    scannedRequestId,
    totalNotSynchronized,
    totalScanned,
    listRequestModel,
    scanStatus,
    status,
    deleteStatus,
    syncStatus,
    scanStatusCount,
    listScanned,
    errorMessage,
  ];
}