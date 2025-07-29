class ItemVendorChecklistPaginatedModel {
  final String id;
  final String name;
  final String code;
  final int index;

  ItemVendorChecklistPaginatedModel({
    required this.id,
    required this.name,
    required this.code,
    required this.index,
  });

  factory ItemVendorChecklistPaginatedModel.fromJson(Map<String, dynamic> json) => ItemVendorChecklistPaginatedModel(
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
