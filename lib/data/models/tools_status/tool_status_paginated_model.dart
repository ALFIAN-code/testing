class ToolStatusPaginatedModel {
  final int index;
  final String id;
  final String name;
  final String code;

  ToolStatusPaginatedModel({
    required this.index,
    required this.id,
    required this.name,
    required this.code,
  });

  factory ToolStatusPaginatedModel.fromJson(Map<String, dynamic> json) => ToolStatusPaginatedModel(
      index: int.tryParse(json['index']?.toString() ?? '0') ?? 0,
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'index': index,
      'id': id,
      'name': name,
      'code': code,
    };
}
