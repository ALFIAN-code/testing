import 'item_statistic_condition_category_model.dart';

class ItemStatisticModel {
  final int total;
  final List<ItemStatisticConditionCategoryModel> itemStatisticConditionCategories;

  ItemStatisticModel({
    required this.total,
    required this.itemStatisticConditionCategories,
  });

  factory ItemStatisticModel.fromJson(Map<String, dynamic> json) => ItemStatisticModel(
      total: json['total'] as int? ?? 0,
      itemStatisticConditionCategories: (json['itemStatisticConditionCategories'] as List<dynamic>?)
          ?.map((e) => ItemStatisticConditionCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'total': total,
      'itemStatisticConditionCategories': itemStatisticConditionCategories.map((e) => e.toJson()).toList(),
    };
}
