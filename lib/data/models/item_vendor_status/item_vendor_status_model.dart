class ItemVendorStatusModel {
  final String id;
  final String name;
  final String code;

  ItemVendorStatusModel({
    required this.id,
    this.name = '',
    this.code = '',
  });

  factory ItemVendorStatusModel.fromJson(Map<String, dynamic> json) => ItemVendorStatusModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
    };
}
