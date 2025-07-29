part of 'list_on_project_item_bloc.dart';

class ListOnProjectItemState extends Equatable {

  final PaginationResponseModel<OnProjectItemPaginatedModel>? projectList;
  final String? errorMessage;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus? statusLoadMore;
  final DateTime? latestUpdate;

  const ListOnProjectItemState({
    this.projectList,
    this.errorMessage,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore,
    this.latestUpdate,
  });

  ListOnProjectItemState copyWith({
    PaginationResponseModel<OnProjectItemPaginatedModel>? projectList,
    String? errorMessage,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusLoadMore,
    DateTime? latestUpdate,

    bool setErrorMessageToNull = false,
  }) => ListOnProjectItemState(
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