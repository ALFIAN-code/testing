import '../../domain/entities/vendor_goods_entity.dart';

class VendorGoodsModel extends VendorGoodsEntity {
  const VendorGoodsModel({
    required super.id,
    required super.code,
    required super.name,
    required super.materialType,
    required super.quantity,
  });

  factory VendorGoodsModel.fromJson(Map<String, dynamic> json) =>
      VendorGoodsModel(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        materialType: json['materialType'] as String,
        quantity: json['quantity'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'code': code,
    'name': name,
    'materialType': materialType,
    'quantity': quantity,
  };
}
