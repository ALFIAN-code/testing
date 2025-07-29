class VendorGoodsReceptionEntity {
  final String id;
  final String code;
  final String vendorName;
  final DateTime deliveryDate;
  final String deliveryTime;
  final String poNumber;
  final int itemCount;
  final String status;
  final String verificationStatus;
  final DateTime submitDate;

  const VendorGoodsReceptionEntity({
    required this.id,
    required this.code,
    required this.vendorName,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.poNumber,
    required this.itemCount,
    required this.status,
    required this.verificationStatus,
    required this.submitDate,
  });
}
