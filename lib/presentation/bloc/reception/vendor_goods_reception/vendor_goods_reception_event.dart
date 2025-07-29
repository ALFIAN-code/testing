part of 'vendor_goods_reception_bloc.dart';

sealed class VendorGoodsReceptionEvent extends Equatable {
  const VendorGoodsReceptionEvent();

  @override
  List<Object> get props => <Object>[];
}

class FetchVendorGoodsReceptions extends VendorGoodsReceptionEvent {
  const FetchVendorGoodsReceptions();
}

class RefreshVendorGoodsReceptions extends VendorGoodsReceptionEvent {
  const RefreshVendorGoodsReceptions();
}

class LoadMoreVendorGoodsReceptions extends VendorGoodsReceptionEvent {
  const LoadMoreVendorGoodsReceptions();
}

class SearchVendorGoodsReceptions extends VendorGoodsReceptionEvent {
  final String query;

  const SearchVendorGoodsReceptions(this.query);

  @override
  List<Object> get props => <Object>[query];
}

class FilterByStatus extends VendorGoodsReceptionEvent {
  final String status;

  const FilterByStatus(this.status);

  @override
  List<Object> get props => <Object>[status];
}

class FilterByVerification extends VendorGoodsReceptionEvent {
  final String verification;

  const FilterByVerification(this.verification);

  @override
  List<Object> get props => <Object>[verification];
}

class ViewGoodsReceptionDetails extends VendorGoodsReceptionEvent {
  final BuildContext context;
  final String id;

  const ViewGoodsReceptionDetails(this.context, this.id);

  @override
  List<Object> get props => <Object>[context, id];
}

class CheckGoodsReception extends VendorGoodsReceptionEvent {
  final BuildContext context;
  final String id;

  const CheckGoodsReception(this.id, this.context);

  @override
  List<Object> get props => <Object>[id, context];
}

class ResetSorting extends VendorGoodsReceptionEvent {
  const ResetSorting();
}
