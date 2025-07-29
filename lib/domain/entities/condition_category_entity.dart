
class ConditionCategoryEntity {
  final String id;
  final String name;
  final String code;

  ConditionCategoryEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ConditionCategoryEntity.fromJson(Map<String, dynamic> json) =>
      ConditionCategoryEntity(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => <String, String>{
    'id': id,
    'name': name,
    'code': code,
  };
}
