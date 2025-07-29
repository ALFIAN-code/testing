class OnProjectItemPaginatedModel {
  final String id;
  final String name;
  final String code;
  final int itemRequestCount;
  final double itemReceivedCount;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final int index;

  OnProjectItemPaginatedModel({
    required this.id,
    required this.name,
    required this.code,
    required this.itemRequestCount,
    required this.itemReceivedCount,
    required this.createdDate,
    this.updatedDate,
    this.index = 0,
  });

  factory OnProjectItemPaginatedModel.fromJson(Map<String, dynamic> json, {int index = 0}) => OnProjectItemPaginatedModel(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    code: json['code'] as String? ?? '',
    itemRequestCount: (json['itemRequestCount'] as num).toInt(),
    itemReceivedCount: (json['itemReceivedCount'] as num).toDouble(),
    createdDate: DateTime.parse(json['createdDate'] as String),
    updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate'] as String) : null,
    index: index,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'code': code,
    'itemRequestCount': itemRequestCount,
    'itemReceivedCount': itemReceivedCount,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate?.toIso8601String(),
  };

}
