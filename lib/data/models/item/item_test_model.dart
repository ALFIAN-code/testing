import '../condition/condition_model.dart';
import '../item_code/item_code_model.dart';
import 'item_test_inspection_model.dart';

class ItemTestModel {
  final String id;
  final String? barcode;
  final DateTime? lastTestedDate;
  final String itemCodeId;
  final ItemCodeModel? itemCode;
  final ConditionModel? condition;
  final List<ItemTestInspectionModel> itemInspections;

  ItemTestModel({
    required this.id,
    this.barcode,
    this.lastTestedDate,
    required this.itemCodeId,
    this.itemCode,
    this.condition,
    List<ItemTestInspectionModel>? itemInspections,
  }) : itemInspections = itemInspections ?? [];

  factory ItemTestModel.fromJson(Map<String, dynamic> json) => ItemTestModel(
      id: json['id'] as String,
      barcode: json['barcode'] as String?,
      lastTestedDate: json['lastTestedDate'] != null
          ? DateTime.parse(json['lastTestedDate'] as String)
          : null,
      itemCodeId: json['itemCodeId'] as String,
      itemCode: json['itemCode'] != null
          ? ItemCodeModel.fromJson(json['itemCode'] as Map<String, dynamic>)
          : null,
      condition: json['condition'] != null
          ? ConditionModel.fromJson(json['condition'] as Map<String, dynamic>)
          : null,
      itemInspections: (json['itemInspections'] as List<dynamic>?)
          ?.map((e) =>
          ItemTestInspectionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'barcode': barcode,
      'lastTestedDate': lastTestedDate?.toIso8601String(),
      'itemCodeId': itemCodeId,
      'itemCode': itemCode?.toJson(),
      'condition': condition?.toJson(),
      'itemInspections': itemInspections.map((e) => e.toJson()).toList(),
    };
}
