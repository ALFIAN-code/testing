import '../../data/models/condition/condition_model.dart';
import '../../data/models/item/item_model.dart';
import '../../data/models/item/item_sync_paginated_model.dart';
import '../../data/models/item_code/item_code_model.dart';

class ItemEntity {
  final String id;
  final String itemCodeId;
  final String? barcode;
  final String description;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? specification;
  final String? poReference;
  final DateTime? purchasedDate;
  final String conditionId;
  final String? projectId;
  final String lastLocationName;
  final double quantity;
  final DateTime lastUpdate;

  ItemEntity({
    required this.id,
    required this.itemCodeId,
    this.barcode,
    required this.description,
    this.brand,
    this.model,
    this.serialNumber,
    this.specification,
    this.poReference,
    this.purchasedDate,
    required this.conditionId,
    this.projectId,
    required this.lastLocationName,
    required this.quantity,
    required this.lastUpdate,
  });

  factory ItemEntity.fromJson(Map<String, dynamic> json) => ItemEntity(
    id: json['id'] as String,
    itemCodeId: json['itemCodeId'] as String,
    barcode: json['barcode'] as String?,
    description: json['description'] as String,
    brand: json['brand'] as String?,
    model: json['model'] as String?,
    serialNumber: json['serialNumber'] as String?,
    specification: json['specification'] as String?,
    poReference: json['poReference'] as String?,
    purchasedDate: json['purchasedDate'] != null
        ? DateTime.parse(json['purchasedDate'] as String)
        : null,
    conditionId: json['conditionId'] as String,
    projectId: json['projectId'] as String?,
    lastLocationName: json['lastLocationName'] as String,
    quantity: (json['quantity'] as num).toDouble(),
    lastUpdate: json['lastUpdate'] as DateTime,
  );

  factory ItemEntity.fromModel(ItemSyncPaginatedModel model) => ItemEntity(
    id: model.id,
    itemCodeId: model.itemCodeId,
    barcode: model.barcode,
    description: model.description,
    brand: model.brand,
    model: model.model,
    serialNumber: model.serialNumber,
    specification: model.specification,
    poReference: model.poReference,
    purchasedDate: model.purchasedDate,
    conditionId: model.conditionId,
    projectId: model.projectId,
    lastLocationName: model.lastLocationName,
    quantity: model.quantity,
    lastUpdate: model.lastUpdate,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemCodeId': itemCodeId,
    'barcode': barcode,
    'description': description,
    'brand': brand,
    'model': model,
    'serialNumber': serialNumber,
    'specification': specification,
    'poReference': poReference,
    'purchasedDate': purchasedDate?.toIso8601String(),
    'conditionId': conditionId,
    'projectId': projectId,
    'lastLocationName': lastLocationName,
    'quantity': quantity,
    'lastUpdate': lastUpdate.toIso8601String(),
  };
}

extension ItemEntityMapper on ItemEntity {
  ItemModel toModel({
    ItemCodeModel? itemCode,
    ConditionModel? condition,
  }) => ItemModel(
      id: id,
      itemCode: itemCode,
      barcode: barcode,
      description: description,
      brand: brand,
      model: model,
      serialNumber: serialNumber,
      specification: specification,
      poReference: poReference,
      purchasedDate: purchasedDate,
      condition: condition,
      lastLocationName: lastLocationName,
      quantity: quantity,
      itemInspections: const [],
      itemImages: const [],
    );
}
