import '../../../domain/entities/condition_entity.dart';

class ConditionPaginatedModel {
  final int index;
  final String id;
  final String name;
  final String code;
  final String conditionCategoryId;

  ConditionPaginatedModel({
    required this.index,
    required this.id,
    required this.name,
    required this.code,
    required this.conditionCategoryId
  });

  factory ConditionPaginatedModel.fromJson(Map<String, dynamic> json) => ConditionPaginatedModel(
    index: int.tryParse(json['index']?.toString() ?? '0') ?? 0,
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
    conditionCategoryId: json['conditionCategoryId']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'index': index,
    'id': id,
    'name': name,
    'code': code,
    'conditionCategoryId': conditionCategoryId
  };
}