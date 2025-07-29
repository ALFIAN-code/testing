class ItemRequestItemStatusModel {
  final String id;
  final String name;
  final String code;

  ItemRequestItemStatusModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ItemRequestItemStatusModel.fromJson(Map<String, dynamic> json) => ItemRequestItemStatusModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
      'code': code,
    };
}
