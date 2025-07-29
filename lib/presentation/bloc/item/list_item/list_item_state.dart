part of 'list_item_bloc.dart';

class ListItemState extends Equatable {
  final String? errorMessage;
  final List<ConditionPaginatedModel> listCondition;
  final List<ConditionCategoryPaginatedModel>listConditionCategory;
  final PaginationResponseModel<ItemPaginatedModel>? listItem;
  final BaseListRequestModel? listRequestModel;
  final FormzSubmissionStatus status;
  final AppStatus? statusLoadMore;
  final DateTime? latestUpdate;

  const ListItemState({
    this.errorMessage,
    this.listCondition = const <ConditionPaginatedModel>[],
    this.listConditionCategory = const <ConditionCategoryPaginatedModel>[],
    this.listItem,
    this.listRequestModel,
    this.status = FormzSubmissionStatus.initial,
    this.statusLoadMore = AppStatus.initial,
    this.latestUpdate
  });

  ListItemState copyWith({
    String? selectedCondition,
    String? selectedConditionCategory,
    String? selectedItemCode,
    String? errorMessage,
    List<ConditionPaginatedModel>? listCondition,
    List<ConditionCategoryPaginatedModel>? listConditionCategory,
    PaginationResponseModel<ItemPaginatedModel>? listItem,
    BaseListRequestModel? listRequestModel,
    FormzSubmissionStatus? status,
    AppStatus? statusLoadMore,
    DateTime? latestUpdate
  }) =>
      ListItemState(
        errorMessage: errorMessage ,
        listCondition: listCondition ?? this.listCondition,
        listConditionCategory: listConditionCategory ?? this.listConditionCategory,
        listItem: listItem ?? this.listItem,
        status: status ?? this.status,
        listRequestModel: listRequestModel ?? this.listRequestModel,
        statusLoadMore: statusLoadMore ?? this.statusLoadMore,
        latestUpdate: latestUpdate ?? this.latestUpdate,
      );

  @override
  List<Object?> get props => [
    errorMessage,
    listCondition,
    listConditionCategory,
    listItem,
    status,
    listRequestModel,
    statusLoadMore,
    latestUpdate
  ];
}