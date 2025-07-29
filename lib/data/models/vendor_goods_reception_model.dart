import '../../domain/entities/vendor_goods_reception_entity.dart';

class VendorGoodsReceptionModel extends VendorGoodsReceptionEntity {
  VendorGoodsReceptionModel({
    required super.id,
    required super.code,
    required super.vendorName,
    required super.deliveryDate,
    required super.deliveryTime,
    required super.poNumber,
    required super.itemCount,
    required super.status,
    required super.verificationStatus,
    required super.submitDate,
  });

  factory VendorGoodsReceptionModel.fromJson(Map<String, dynamic> json) =>
      VendorGoodsReceptionModel(
        id: json['id'] as String,
        code: json['code'] as String,
        vendorName: json['vendor_name'] as String,
        deliveryDate: DateTime.parse(json['delivery_date'] as String),
        deliveryTime: json['delivery_time'] as String,
        poNumber: json['po_number'] as String,
        itemCount: json['item_count'] as int,
        status: json['status'] as String,
        verificationStatus: json['verification_status'] as String,
        submitDate: DateTime.parse(json['submit_date'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'code': code,
    'vendor_name': vendorName,
    'delivery_date': deliveryDate.toIso8601String(),
    'delivery_time': deliveryTime,
    'po_number': poNumber,
    'item_count': itemCount,
    'status': status,
    'verification_status': verificationStatus,
    'submit_date': submitDate.toIso8601String(),
  };
}
