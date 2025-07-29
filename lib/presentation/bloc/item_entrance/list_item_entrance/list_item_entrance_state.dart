part of 'list_item_entrance_bloc.dart';

class ListItemEntranceState extends Equatable {

  final PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>? projectList;
  final String? errorMessage;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus? statusLoadMore;
  final DateTime? latestUpdate;

  const ListItemEntranceState({
    this.projectList,
    this.errorMessage,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore,
    this.latestUpdate,
  });

  ListItemEntranceState copyWith({
    PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>? projectList,
    String? errorMessage,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusLoadMore,
    DateTime? latestUpdate,

    bool setErrorMessageToNull = false,
  }) => ListItemEntranceState(
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