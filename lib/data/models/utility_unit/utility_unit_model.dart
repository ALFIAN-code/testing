class UtilityUnitModel {
  final String id;
  final String name;
  final String code;

  UtilityUnitModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory UtilityUnitModel.fromJson(Map<String, dynamic> json) =>
      UtilityUnitModel(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
  };
}
