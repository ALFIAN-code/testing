import '../../../domain/entities/item_entity.dart';
import '../condition/condition_model.dart';
import '../item_code/item_code_model.dart';
import 'item_image_model.dart';
import 'item_test_inspection_model.dart';

class ItemModel {
  final String id;
  final ItemCodeModel? itemCode;
  final String? barcode;
  final String? description;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? specification;
  final String? poReference;
  final String? rackCode;
  final String? projectId;
  final DateTime? purchasedDate;
  final ConditionModel? condition;
  final String? lastLocationName;
  final double? quantity;
  final List<ItemTestInspectionModel> itemInspections;
  final List<ItemImageModel> itemImages;

  ItemModel({
    required this.id,
    this.itemCode,
    this.barcode,
    this.description,
    this.brand,
    this.model,
    this.serialNumber,
    this.specification,
    this.rackCode,
    this.poReference,
    this.purchasedDate,
    this.condition,
    this.lastLocationName,
    this.quantity,
    this.itemInspections = const <ItemTestInspectionModel>[],
    this.projectId,
    this.itemImages = const <ItemImageModel>[],
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as String,
    itemCode: json['itemCode'] != null
        ? ItemCodeModel.fromJson(json['itemCode'] as Map<String, dynamic>)
        : null,
    barcode: json['barcode'] as String?,
    description: json['description'] as String?,
    brand: json['brand'] as String?,
    model: json['model'] as String?,
    serialNumber: json['serialNumber'] as String?,
    specification: json['specification'] as String?,
    rackCode: json['rackCode'] as String?,
    poReference: json['poReference'] as String?,
    purchasedDate: json['purchasedDate'] != null
        ? DateTime.parse(json['purchasedDate'] as String)
        : null,
    condition: json['condition'] != null
        ? ConditionModel.fromJson(
        json['condition'] as Map<String, dynamic>)
        : null,
    lastLocationName: json['lastLocationName'] as String?,
    quantity: (json['quantity'] as num?)?.toDouble(),
    itemInspections: (json['itemInspections'] as List<dynamic>?)
        ?.map((e) => ItemTestInspectionModel.fromJson(
        e as Map<String, dynamic>))
        .toList() ??
        [],
    itemImages: (json['itemImages'] as List<dynamic>?)
        ?.map((e) =>
        ItemImageModel.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    projectId: json['projectId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (itemCode != null) 'itemCode': itemCode!.toJson(),
    'barcode': barcode,
    'description': description,
    'brand': brand,
    'model': model,
    'serialNumber': serialNumber,
    'specification': specification,
    'rackCode': rackCode,
    'poReference': poReference,
    'purchasedDate': purchasedDate?.toIso8601String(),
    if (condition != null) 'condition': condition!.toJson(),
    'lastLocationName': lastLocationName,
    'quantity': quantity,
    'itemInspections': itemInspections.map((e) => e.toJson()).toList(),
    'itemImages': itemImages.map((e) => e.toJson()).toList(),
    'projectId': projectId,
  };
}

