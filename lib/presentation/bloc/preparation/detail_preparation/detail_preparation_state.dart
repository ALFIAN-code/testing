part of 'detail_preparation_bloc.dart';

class DetailPreparationState extends Equatable {
  final String? scannedItem;
  final PaginationResponseModel<ItemRequestItemScanPaginatedModel>? listItems;
  final String? errorMessage;
  final FormzSubmissionStatus scanStatus;
  final FormzSubmissionStatus status;

  const DetailPreparationState({
    this.scannedItem,
    this.listItems,
    this.errorMessage,
    this.scanStatus = FormzSubmissionStatus.initial,
    this.status = FormzSubmissionStatus.initial,
  });

  @override
  List<Object?> get props => <Object?>[
    status,
    errorMessage,
    scanStatus,
    scannedItem,
    listItems,
  ];

  DetailPreparationState copyWith({
    String? scannedItem,
    PaginationResponseModel<ItemRequestItemScanPaginatedModel>? listItems,
    String? errorMessage,
    FormzSubmissionStatus? scanStatus,
    FormzSubmissionStatus? status,
  }) => DetailPreparationState(
      scannedItem: scannedItem ?? this.scannedItem,
      listItems: listItems ?? this.listItems,
      errorMessage: errorMessage ?? this.errorMessage,
      scanStatus: scanStatus ?? this.scanStatus,
      status: status ?? this.status,
    );
}
