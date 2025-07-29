part of 'list_prepare_return_item_bloc.dart';

class ListPrepareReturnItemState extends Equatable {

  final PaginationResponseModel<PrepareReturnItemPaginatedModel>? projectList;
  final String? errorMessage;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus? statusLoadMore;
  final DateTime? latestUpdate;

  const ListPrepareReturnItemState({
    this.projectList,
    this.errorMessage,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore,
    this.latestUpdate,
  });

  ListPrepareReturnItemState copyWith({
    PaginationResponseModel<PrepareReturnItemPaginatedModel>? projectList,
    String? errorMessage,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusLoadMore,
    DateTime? latestUpdate,

    bool setErrorMessageToNull = false,
  }) => ListPrepareReturnItemState(
    projectList: projectList ?? this.projectList,
    errorMessage: setErrorMessageToNull ? null : (errorMessage ?? this.errorMessage),
    listRequestModel: listRequestModel ?? this.listRequestModel,
    status: status ?? this.status,
    statusLoadMore: statusLoadMore ?? this.statusLoadMore,
    latestUpdate: latestUpdate ?? this.latestUpdate,
  );

  @override
  List<Object?> get props => [projectList, errorMessage, listRequestModel, status, statusLoadMore, latestUpdate];
}