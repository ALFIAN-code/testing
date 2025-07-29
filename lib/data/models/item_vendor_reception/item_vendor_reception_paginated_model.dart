import '../item_vendor_condition/item_vendor_condition_model.dart';
import '../item_vendor_status/item_vendor_status_model.dart';
import '../supplier/supplier_model.dart';

class ItemVendorReceptionPaginatedModel {
  final String id;
  final String code;
  final String poNumber;
  final String poFilePath;
  final SupplierModel? supplier;
  final String estimatedDate; // Format: 'yyyy-MM-dd'
  final String? estimatedTime; // Format: 'HH:mm' or null
  final int totalItemCode;
  final int totalItem;
  final String itemVendorStatusId;
  final String itemVendorConditionId;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String? updatedBy;
  final bool? isDoubleCheck;
  final ItemVendorStatusModel? itemVendorStatus;
  final ItemVendorConditionModel? itemVendorCondition;
  final int index;

  ItemVendorReceptionPaginatedModel({
    required this.id,
    required this.code,
    required this.poNumber,
    required this.poFilePath,
    required this.supplier,
    required this.estimatedDate,
    this.estimatedTime,
    required this.totalItemCode,
    required this.totalItem,
    required this.itemVendorStatusId,
    required this.itemVendorConditionId,
    required this.createdDate,
    this.updatedDate,
    this.updatedBy,
    this.isDoubleCheck,
    this.itemVendorStatus,
    this.itemVendorCondition,
    this.index = 0,
  });

  factory ItemVendorReceptionPaginatedModel.fromJson(Map<String, dynamic> json) => ItemVendorReceptionPaginatedModel(
    id: json['id'] as String,
    code: json['code'] as String? ?? '',
    poNumber: json['poNumber'] as String? ?? '',
    poFilePath: json['poFilePath'] as String? ?? '',
    supplier: json['supplier'] != null ? SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>) : null,
    estimatedDate: json['estimatedDate'] as String? ?? '',
    estimatedTime: json['estimatedTime'] as String?,
    totalItemCode: json['totalItemCode'] as int? ?? 0,
    totalItem: json['totalItem'] as int? ?? 0,
    itemVendorStatusId: json['itemVendorStatusId'] as String? ?? '',
    itemVendorConditionId: json['itemVendorConditionId'] as String? ?? '',
    createdDate: DateTime.parse(json['createdDate'] as String),
    updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate'] as String) : null,
    updatedBy: json['updatedBy'] as String?,
    isDoubleCheck: json['isDoubleCheck'] as bool?,
    itemVendorStatus: json['itemVendorStatus'] != null
        ? ItemVendorStatusModel.fromJson(json['itemVendorStatus'] as Map<String, dynamic>)
        : null,
    itemVendorCondition: json['itemVendorCondition'] != null
        ? ItemVendorConditionModel.fromJson(json['itemVendorCondition'] as Map<String, dynamic>)
        : null,
    index: json['index'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'code': code,
      'poNumber': poNumber,
      'poFilePath': poFilePath,
      'supplier': supplier,
      'estimatedDate': estimatedDate,
      'estimatedTime': estimatedTime,
      'totalItemCode': totalItemCode,
      'totalItem': totalItem,
      'itemVendorStatusId': itemVendorStatusId,
      'itemVendorConditionId': itemVendorConditionId,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'updatedBy': updatedBy,
      'isDoubleCheck': isDoubleCheck,
      'itemVendorStatus': itemVendorStatus?.toJson(),
      'itemVendorCondition': itemVendorCondition?.toJson(),
      'index': index,
    };
}
