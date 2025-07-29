part of 'list_preparation_bloc.dart';

class ListPreparationState extends Equatable {

  final PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>? projectList;
  final String? errorMessage;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus? statusLoadMore;
  final DateTime? latestUpdate;

  const ListPreparationState({
    this.projectList,
    this.errorMessage,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore,
    this.latestUpdate,
  });

  ListPreparationState copyWith({
    PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>? projectList,
    String? errorMessage,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusLoadMore,
    DateTime? latestUpdate,

    bool setErrorMessageToNull = false,
  }) => ListPreparationState(
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