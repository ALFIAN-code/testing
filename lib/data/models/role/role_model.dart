class RoleModel {
  final String id;
  final String name;
  final String code;

  RoleModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
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
