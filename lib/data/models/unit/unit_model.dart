class UnitModel {
  final String id;
  final String name;
  final String code;

  UnitModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
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
