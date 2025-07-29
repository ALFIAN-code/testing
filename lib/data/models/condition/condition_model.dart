import '../condition_category/condition_category_model.dart';

class ConditionModel {
  final String id;
  final String name;
  final String code;
  final String conditionCategoryId;
  final ConditionCategoryModel? conditionCategory;

  ConditionModel({
    required this.id,
    required this.name,
    required this.code,
    required this.conditionCategoryId,
    this.conditionCategory,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) => ConditionModel(
      id: json['id'] as String,
      name: json['name']  as String ?? '',
      code: json['code']  as String ?? '',
      conditionCategoryId: json['conditionCategoryId'] as String,
      conditionCategory: json['conditionCategory'] != null
          ? ConditionCategoryModel.fromJson(json['conditionCategory'] as Map<String, dynamic>)
          : null,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'code': code,
      'conditionCategoryId': conditionCategoryId,
      'conditionCategory': conditionCategory?.toJson(),
    };
}


