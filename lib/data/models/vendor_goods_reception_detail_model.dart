import '../../domain/entities/vendor_goods_entity.dart';
import '../../domain/entities/vendor_goods_reception_detail_entity.dart';
import 'vendor_goods_model.dart';

class VendorGoodsReceptionDetailModel extends VendorGoodsReceptionDetailEntity {
  const VendorGoodsReceptionDetailModel({
    required super.id,
    required super.poNumber,
    required super.vendorName,
    required super.estimatedArrivalDate,
    required super.estimatedArrivalTime,
    required super.submitDate,
    required super.items,
    required super.itemCount,
    super.rejectionReason,
  });

  factory VendorGoodsReceptionDetailModel.fromJson(Map<String, dynamic> json) =>
      VendorGoodsReceptionDetailModel(
        id: json['id'] as String,
        poNumber: json['poNumber'] as String,
        vendorName: json['vendorName'] as String,
        estimatedArrivalDate: DateTime.parse(
          json['estimatedArrivalDate'] as String,
        ),
        estimatedArrivalTime: DateTime.parse(
          json['estimatedArrivalTime'] as String,
        ),
        submitDate: DateTime.parse(json['submitDate'] as String),
        items:
            (json['items'] as List<dynamic>)
                .map(
                  (dynamic item) =>
                      VendorGoodsModel.fromJson(item as Map<String, dynamic>),
                )
                .toList(),
        itemCount: json['itemCount'] as int,
        rejectionReason: json['rejectionReason'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'poNumber': poNumber,
    'vendorName': vendorName,
    'estimatedArrivalDate': estimatedArrivalDate.toIso8601String(),
    'estimatedArrivalTime': estimatedArrivalTime.toIso8601String(),
    'submitDate': submitDate.toIso8601String(),
    'items':
        items
            .map(
              (VendorGoodsEntity item) => <String, Object>{
                'id': item.id,
                'code': item.code,
                'name': item.name,
                'materialType': item.materialType,
                'quantity': item.quantity,
              },
            )
            .toList(),
    'itemCount': itemCount,
    'rejectionReason': rejectionReason,
  };
}
