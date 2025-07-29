import 'item_statistic_condition_model.dart';

class ItemStatisticConditionCategoryModel {
  final String? id;
  final String name;
  final String code;
  final int total;
  final List<ItemStatisticConditionModel> itemStatisticConditions;

  ItemStatisticConditionCategoryModel({
    this.id,
    required this.name,
    required this.code,
    required this.total,
    required this.itemStatisticConditions,
  });

  factory ItemStatisticConditionCategoryModel.fromJson(Map<String, dynamic> json) => ItemStatisticConditionCategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      itemStatisticConditions: (json['itemStatisticConditions'] as List<dynamic>?)
          ?.map((e) => ItemStatisticConditionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <ItemStatisticConditionModel>[],
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'total': total,
      'itemStatisticConditions': itemStatisticConditions.map((e) => e.toJson()).toList(),
    };
}
