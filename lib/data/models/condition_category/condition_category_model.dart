class ConditionCategoryModel {
  final String id;
  final String name;
  final String code;

  ConditionCategoryModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ConditionCategoryModel.fromJson(Map<String, dynamic> json) => ConditionCategoryModel(
      id: json['id'] as String,
      name: json['name']  as String ?? '',
      code: json['code'] as String ?? '',
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'code': code,
    };
}
