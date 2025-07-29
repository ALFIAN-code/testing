part of 'item_vendor_arrival_bloc.dart';

class ItemVendorArrivalState extends Equatable {
  final PaginationResponseModel<ItemVendorArrivalModel>? itemTestList;
  final DateTime? latestUpdate;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus? statusLoadMore;
  final String? errorMessage;

  const ItemVendorArrivalState({
    this.itemTestList,
    this.latestUpdate,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore,
    this.errorMessage,
  });
  
  ItemVendorArrivalState copyWith({
    PaginationResponseModel<ItemVendorArrivalModel>? itemTestList,
    DateTime? latestUpdate,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusLoadMore,
    String? errorMessage,

    bool setErrorMessageToNull = false,
  }) => ItemVendorArrivalState(
    itemTestList: itemTestList ?? this.itemTestList,
    latestUpdate: latestUpdate ?? this.latestUpdate,
    listRequestModel: listRequestModel ?? this.listRequestModel,
    status: status ?? this.status,
    statusLoadMore: statusLoadMore ?? this.statusLoadMore,
    errorMessage: setErrorMessageToNull ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props => [
    itemTestList,
    latestUpdate,
    listRequestModel,
    status,
    statusLoadMore,
    errorMessage,
  ];
}
