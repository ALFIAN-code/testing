class ItemVendorStatusPaginatedModel {
  final String id;
  final String name;
  final String code;
  final int index;

  ItemVendorStatusPaginatedModel({
    required this.id,
    this.name = '',
    this.code = '',
    this.index = 0,
  });

  factory ItemVendorStatusPaginatedModel.fromJson(Map<String, dynamic> json) => ItemVendorStatusPaginatedModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      index: json['index'] as int? ?? 0,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'index': index,
    };
}
