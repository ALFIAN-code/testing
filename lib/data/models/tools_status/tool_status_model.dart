class ToolStatusModel {
  final String id;
  final String name;
  final String code;

  ToolStatusModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ToolStatusModel.fromJson(Map<String, dynamic> json) => ToolStatusModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'code': code,
    };
}
