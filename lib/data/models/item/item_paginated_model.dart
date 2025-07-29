import '../condition/condition_model.dart';
import '../item_code/item_code_model.dart';

class ItemPaginatedModel {
  final String id;
  final ItemCodeModel? itemCode;
  final String? barcode;
  final String description;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? specification;
  final String? poReference;
  final String? rackCode;
  final DateTime? purchasedDate;
  final ConditionModel? condition;
  final String? projectId;
  final String lastLocationName;
  final double quantity;

  ItemPaginatedModel({
    required this.id,
    this.itemCode,
    this.barcode = '',
    required this.description,
    this.brand,
    this.model,
    this.serialNumber,
    this.specification,
    this.poReference,
    this.purchasedDate,
    this.condition,
    this.rackCode,
    this.projectId,
    this.lastLocationName = '',
    required this.quantity,
  });

  factory ItemPaginatedModel.fromJson(Map<String, dynamic> json) => ItemPaginatedModel(
    id: (json['id'] as String?) ?? '',
    itemCode: json['itemCode'] != null
        ? ItemCodeModel.fromJson(json['itemCode'] as Map<String, dynamic>)
        : null,
    barcode: json['barcode'] as String?,
    description: (json['description'] as String?) ?? '',
    brand: json['brand'] as String?,
    model: json['model'] as String?,
    serialNumber: json['serialNumber'] as String?,
    specification: json['specification'] as String?,
    poReference: json['poReference'] as String?,
    rackCode: json['rackCode'] as String?,
    purchasedDate: json['purchasedDate'] != null
        ? DateTime.parse(json['purchasedDate'] as String)
        : null,
    condition: json['condition'] != null
        ? ConditionModel.fromJson(json['condition'] as Map<String, dynamic>)
        : null,
    projectId: json['projectId'] as String?,
    lastLocationName: (json['lastLocationName'] as String?) ?? '',
    quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'itemCode': itemCode?.toJson(),
      'barcode': barcode,
      'description': description,
      'brand': brand,
      'model': model,
      'serialNumber': serialNumber,
      'specification': specification,
      'rackCode': rackCode,
      'poReference': poReference,
      'purchasedDate': purchasedDate?.toIso8601String(),
      'condition': condition?.toJson(),
      'projectId': projectId,
      'lastLocationName': lastLocationName,
      'quantity': quantity,
    };
}