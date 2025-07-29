// item_code_category_model.dart

class ItemCodeCategoryModel {
  final String id;
  final String name;
  final String code;

  ItemCodeCategoryModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ItemCodeCategoryModel.fromJson(Map<String, dynamic> json) => ItemCodeCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
      'code': code,
    };
}
