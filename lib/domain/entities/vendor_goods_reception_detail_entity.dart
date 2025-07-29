import 'vendor_goods_entity.dart';

class VendorGoodsReceptionDetailEntity {
  final String id;
  final String poNumber;
  final String vendorName;
  final DateTime estimatedArrivalDate;
  final DateTime estimatedArrivalTime;
  final DateTime submitDate;
  final List<VendorGoodsEntity> items;
  final int itemCount;
  final String? rejectionReason;

  const VendorGoodsReceptionDetailEntity({
    required this.id,
    required this.poNumber,
    required this.vendorName,
    required this.estimatedArrivalDate,
    required this.estimatedArrivalTime,
    required this.submitDate,
    required this.items,
    required this.itemCount,
    this.rejectionReason,
  });
}
