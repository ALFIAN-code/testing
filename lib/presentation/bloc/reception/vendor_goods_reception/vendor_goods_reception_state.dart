part of 'vendor_goods_reception_bloc.dart';

class VendorGoodsReceptionState extends Equatable {
  final PaginationResponseModel<ItemVendorReceptionPaginatedModel>? listItemReception;
  final List<ItemVendorStatusPaginatedModel> listItemStatus;
  final List<ItemVendorConditionPaginatedModel> listItemCondition;
  final BaseListRequestModel? listRequestModel;
  final DateTime? latestUpdate;
  final String? errorMessage;
  final AppStatus status;
  final AppStatus statusLoadMore;

  const VendorGoodsReceptionState({
    this.listItemReception,
    this.listItemStatus = const <ItemVendorStatusPaginatedModel>[],
    this.listItemCondition = const <ItemVendorConditionPaginatedModel>[],
    this.listRequestModel,
    this.latestUpdate,
    this.errorMessage,
    this.status = AppStatus.initial,
    this.statusLoadMore = AppStatus.initial,
  });

  VendorGoodsReceptionState copyWith({
    PaginationResponseModel<ItemVendorReceptionPaginatedModel>? listItemReception,
    List<ItemVendorStatusPaginatedModel>? listItemStatus,
    List<ItemVendorConditionPaginatedModel>? listItemCondition,
    BaseListRequestModel? listRequestModel,
    DateTime? latestUpdate,
    String? errorMessage,
    AppStatus? status,
    AppStatus? statusLoadMore,
  }) => VendorGoodsReceptionState(
      listItemReception: listItemReception ?? this.listItemReception,
      listItemStatus: listItemStatus ?? this.listItemStatus,
      listItemCondition: listItemCondition ?? this.listItemCondition,
      listRequestModel: listRequestModel ?? this.listRequestModel,
      latestUpdate: latestUpdate ?? this.latestUpdate,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      statusLoadMore: statusLoadMore ?? this.statusLoadMore
    );

  @override
  List<Object?> get props => <Object?>[
    listItemReception,
    listItemStatus,
    listItemCondition,
    listRequestModel,
    latestUpdate,
    errorMessage,
    status,
    statusLoadMore
  ];
}
