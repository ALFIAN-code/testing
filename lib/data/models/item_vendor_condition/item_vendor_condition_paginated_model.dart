class ItemVendorConditionPaginatedModel {
  final int index;
  final String id;
  final String name;
  final String code;

  ItemVendorConditionPaginatedModel({
    required this.index,
    required this.id,
    this.name = '',
    this.code = '',
  });

  factory ItemVendorConditionPaginatedModel.fromJson(Map<String, dynamic> json) => ItemVendorConditionPaginatedModel(
      index: json['index'] as int,
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, dynamic >{
      'index': index,
      'id': id,
      'name': name,
      'code': code,
    };
}
