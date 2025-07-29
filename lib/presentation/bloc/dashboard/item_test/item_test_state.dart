part of 'item_test_bloc.dart';

class ItemTestState extends Equatable {
  final PaginationResponseModel<ItemTestPaginationModel>? itemTestList;
  final DateTime? latestUpdate;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus? statusLoadMore;
  final String? errorMessage;

  const ItemTestState({
    this.itemTestList,
    this.latestUpdate,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore,
    this.errorMessage,
  });
  
  ItemTestState copyWith({
    PaginationResponseModel<ItemTestPaginationModel>? itemTestList,
    DateTime? latestUpdate,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusLoadMore,
    String? errorMessage,

    bool setErrorMessageToNull = false,
  }) => ItemTestState(
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
