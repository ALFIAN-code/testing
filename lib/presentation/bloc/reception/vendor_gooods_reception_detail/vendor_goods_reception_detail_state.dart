part of 'vendor_goods_reception_detail_bloc.dart';

class VendorGoodsReceptionDetailState extends Equatable {
  const VendorGoodsReceptionDetailState({
    this.itemVendorReception,
    this.errorMessage,
    this.status = AppStatus.initial,
  });

  final ItemVendorReceptionModel? itemVendorReception;
  final String? errorMessage;
  final AppStatus status;

  VendorGoodsReceptionDetailState copyWith({
    ItemVendorReceptionModel? itemVendorReception,
    String? errorMessage,
    AppStatus? status,
  }) => VendorGoodsReceptionDetailState(
      itemVendorReception: itemVendorReception ?? this.itemVendorReception,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );

  @override
  List<Object?> get props => <Object?>[
    itemVendorReception,
    errorMessage,
    status,
  ];
}
