class ItemVendorConditionModel {
  final String id;
  final String name;
  final String code;

  ItemVendorConditionModel({
    required this.id,
    this.name = '',
    this.code = '',
  });

  factory ItemVendorConditionModel.fromJson(Map<String, dynamic> json) => ItemVendorConditionModel(
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
