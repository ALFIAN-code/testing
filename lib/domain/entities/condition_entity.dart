
import '../../data/mappers/condition_category_mapper.dart';
import '../../data/models/condition/condition_model.dart';
import 'condition_category_entity.dart';

class ConditionEntity {
  final String id;
  final String name;
  final String code;
  final String conditionCategoryId;
  final ConditionCategoryEntity? conditionCategory;

  ConditionEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.conditionCategoryId,
    this.conditionCategory,
  });

  factory ConditionEntity.fromJson(Map<String, dynamic> json) => ConditionEntity(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
    conditionCategoryId: json['conditionCategoryId']?.toString() ?? '',
    conditionCategory: json['conditionCategory'] == null
        ? null
        : ConditionCategoryEntity.fromJson(json['conditionCategory'] as Map<String, dynamic>),
  );

  factory ConditionEntity.fromJoinRow(Map<String, dynamic> json) => ConditionEntity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      conditionCategoryId: json['conditionCategoryId']?.toString() ?? '',
      conditionCategory: json['cc_id'] == null
          ? null
          : ConditionCategoryEntity(
        id: json['cc_id']?.toString() ?? '',
        name: json['cc_name']?.toString() ?? '',
        code: json['cc_code']?.toString() ?? '',
      ),
    );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'conditionCategoryId': conditionCategoryId,
    'conditionCategory': conditionCategory?.toJson(),
  };
}

