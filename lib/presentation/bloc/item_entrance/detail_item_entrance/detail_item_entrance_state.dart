part of 'detail_item_entrance_bloc.dart';

class DetailItemEntranceState extends Equatable {
  final ProjectItemRequestSummaryPaginatedModel? project;
  final String? scannedItem;
  final String? scannedRequestId;
  final int? totalScanned;
  final int? totalSynchronized;
  final int? totalNotSynchronized;
  final FormzSubmissionStatus scanStatus;
  final FormzSubmissionStatus detailStatus;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus deleteStatus;
  final FormzSubmissionStatus syncStatus;
  final List<ItemPreparationSummaryModel> items;
  final List<ItemPreparationDetailModel> detailItems;
  final ItemPreparationCountModel? scanStatusCount;
  final String? search;
  final String? itemRequestId;
  final bool hasReachedMax;
  final String? errorMessage;

  const DetailItemEntranceState({
    this.project,
    this.totalScanned,
    this.scannedItem,
    this.totalNotSynchronized,
    this.totalSynchronized,
    this.scannedRequestId,
    this.scanStatus = FormzSubmissionStatus.initial,
    this.detailStatus = FormzSubmissionStatus.initial,
    this.deleteStatus = FormzSubmissionStatus.initial,
    this.syncStatus = FormzSubmissionStatus.initial,
    this.status = FormzSubmissionStatus.initial,
    this.items = const <ItemPreparationSummaryModel>[],
    this.detailItems = const <ItemPreparationDetailModel>[],
    this.scanStatusCount,
    this.search,
    this.itemRequestId,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        project,
        totalScanned,
        totalNotSynchronized,
        totalSynchronized,
        scannedItem,
        scannedRequestId,
        scanStatus,
        detailStatus,
        deleteStatus,
        syncStatus,
        status,
        items,
        scanStatusCount,
        detailItems,
        search,
        itemRequestId,
        hasReachedMax,
        errorMessage,
      ];

  DetailItemEntranceState copyWith({
    ProjectItemRequestSummaryPaginatedModel? project,
    int? totalScanned,
    int? totalNotSynchronized,
    int? totalSynchronized,
    String? scannedItem,
    String? scannedRequestId,
    FormzSubmissionStatus? scanStatus,
    FormzSubmissionStatus? detailStatus,
    FormzSubmissionStatus? deleteStatus,
    FormzSubmissionStatus? syncStatus,
    FormzSubmissionStatus? status,
    List<ItemPreparationSummaryModel>? items,
    ItemPreparationCountModel? scanStatusCount,
    List<ItemPreparationDetailModel>? detailItems,
    bool? hasReachedMax,
    String? search,
    String? itemRequestId,
    String? errorMessage,

    bool resetItemRequestId = false,
    bool resetScannedItem = false,
    bool resetScannedRequestId = false,
  }) => DetailItemEntranceState(
      project: project ?? this.project,
      totalScanned: totalScanned ?? this.totalScanned,
      totalNotSynchronized: totalNotSynchronized ?? this.totalNotSynchronized,
      totalSynchronized: totalSynchronized ?? this.totalSynchronized,
      scannedItem: resetScannedItem ? null : (scannedItem ?? this.scannedItem),
      scannedRequestId: resetScannedRequestId ? null : (scannedRequestId ?? this.scannedRequestId),
      scanStatus: scanStatus ?? this.scanStatus,
      detailStatus: detailStatus ?? this.detailStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      status: status ?? this.status,
      items: items ?? this.items,
      scanStatusCount: scanStatusCount ?? this.scanStatusCount,
      detailItems: detailItems ?? this.detailItems,
      search: search ?? this.search,
      itemRequestId: resetItemRequestId ? null : (itemRequestId ?? this.itemRequestId),
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );

}