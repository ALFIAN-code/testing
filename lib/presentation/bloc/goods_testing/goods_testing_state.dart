part of 'goods_testing_cubit.dart';

class GoodsTestingState extends Equatable {
  final AppStatus status;
  final String? scannedItem;
  final String? errorMessage;
  final ItemTestModel? itemTestModel;

  const GoodsTestingState({
    this.status = AppStatus.initial,
    this.scannedItem,
    this.errorMessage,
    this.itemTestModel,
  });

  @override
  List<Object?> get props => <Object?>[
    status,
    scannedItem,
    errorMessage,
    itemTestModel,
  ];

  GoodsTestingState copyWith({
    AppStatus? status,
    String? scannedItem,
    String? errorMessage,
    ItemTestModel? itemTestModel,
  }) => GoodsTestingState(
    status: status ?? this.status,
    scannedItem: scannedItem ?? this.scannedItem,
    errorMessage: errorMessage ?? this.errorMessage,
    itemTestModel: itemTestModel ?? this.itemTestModel,
  );
}
