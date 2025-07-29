import '../item_code_category/item_code_category_model.dart';
import '../unit/unit_model.dart';
import '../utility_unit/utility_unit_model.dart';
import 'item_code_coa_model.dart';
import 'item_code_inspection_model.dart';
import 'item_code_item_classification_model.dart';

class ItemCodeModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final int? maintenanceIntervalDay;
  final ItemCodeCategoryModel? itemCodeCategory;
  final List<ItemCodeInspectionModel> itemCodeInspections;
  final ItemCodeCoaModel? coa;
  final ItemCodeItemClassificationModel? itemClassification;
  final UnitModel? unit;
  final UtilityUnitModel? utilityUnit;

  ItemCodeModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    this.maintenanceIntervalDay,
    this.itemCodeCategory,
    this.itemCodeInspections = const <ItemCodeInspectionModel>[],
    this.coa,
    this.itemClassification,
    this.unit,
    this.utilityUnit,
  });

  factory ItemCodeModel.fromJson(Map<String, dynamic> json) => ItemCodeModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    description: json['description'] as String,
    maintenanceIntervalDay: json['maintenanceIntervalDay'] as int?,
    itemCodeCategory: json['itemCodeCategory'] != null
        ? ItemCodeCategoryModel.fromJson(
        json['itemCodeCategory'] as Map<String, dynamic>)
        : null,
    itemCodeInspections:
    (json['itemCodeInspections'] as List<dynamic>?)
        ?.map((e) => ItemCodeInspectionModel.fromJson(
        e as Map<String, dynamic>))
        .toList() ??
        [],
    coa: json['coa'] != null
        ? ItemCodeCoaModel.fromJson(json['coa'] as Map<String, dynamic>)
        : null,
    itemClassification:  json['itemClassification'] != null ? ItemCodeItemClassificationModel.fromJson(
        json['itemClassification'] as Map<String, dynamic>) : null,
    unit: json['unit'] != null
        ? UnitModel.fromJson(json['unit'] as Map<String, dynamic>)
        : null,
    utilityUnit: json['utilityUnit'] != null
        ? UtilityUnitModel.fromJson(
        json['utilityUnit'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'description': description,
    'maintenanceIntervalDay': maintenanceIntervalDay,
    if (itemCodeCategory != null)
      'itemCodeCategory': itemCodeCategory!.toJson(),
    'itemCodeInspections':
    itemCodeInspections.map((e) => e.toJson()).toList(),
    if (coa != null) 'coa': coa!.toJson(),
    if (itemClassification != null) 'itemClassification': itemClassification!.toJson(),
    if (unit != null) 'unit': unit!.toJson(),
    if (utilityUnit != null) 'utilityUnit': utilityUnit!.toJson(),
  };
}
