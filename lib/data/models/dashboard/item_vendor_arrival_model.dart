import '../supplier/supplier_model.dart';

class ItemVendorArrivalModel {
  final String id;
  final String code;
  final String poNumber;
  final SupplierModel? supplier;
  final DateTime estimatedDate;
  final String? estimatedTime;
  final int totalItemCode;
  final int totalItem;
  final int index;

  ItemVendorArrivalModel({
    required this.id,
    required this.code,
    required this.poNumber,
    this.supplier,
    required this.estimatedDate,
    this.estimatedTime,
    required this.totalItemCode,
    required this.totalItem,
    required this.index,
  });

  factory ItemVendorArrivalModel.fromJson(Map<String, dynamic> json) => ItemVendorArrivalModel(
      id: json['id'] as String,
      code: json['code'] as String? ?? '',
      poNumber: json['poNumber'] as String? ?? '',
      supplier: json['supplier'] != null
          ? SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>)
          : null,
      estimatedDate: DateTime.parse(json['estimatedDate'] as String),
      estimatedTime: json['estimatedTime'] as String?,
      totalItemCode: json['totalItemCode'] as int? ?? 0,
      totalItem: json['totalItem'] as int? ?? 0,
      index: json['index'] as int? ?? 0,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'code': code,
      'poNumber': poNumber,
      'supplier': supplier?.toJson(),
      'estimatedDate': estimatedDate.toIso8601String().split('T')[0],
      'estimatedTime': estimatedTime,
      'totalItemCode': totalItemCode,
      'totalItem': totalItem,
      'index': index,
    };
}