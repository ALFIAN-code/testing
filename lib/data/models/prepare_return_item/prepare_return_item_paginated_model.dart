class PrepareReturnItemPaginatedModel {
  final String id;
  final String name;
  final String code;
  final double onProjectItemCount;
  final double returningItemCount;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final int index;

  PrepareReturnItemPaginatedModel({
    required this.id,
    required this.name,
    required this.code,
    required this.onProjectItemCount,
    required this.returningItemCount,
    required this.createdDate,
    this.updatedDate,
    this.index = 0,
  });

  factory PrepareReturnItemPaginatedModel.fromJson(Map<String, dynamic> json, {int index = 0}) => PrepareReturnItemPaginatedModel(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    code: json['code'] as String? ?? '',
    onProjectItemCount: (json['onProjectItemCount'] as num?)?.toDouble() ?? 0.0,
    returningItemCount: (json['returningItemCount'] as num?)?.toDouble() ?? 0.0,
    createdDate: DateTime.parse(json['createdDate'] as String),
    updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate'] as String) : null,
    index: index,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'code': code,
    'onProjectItemCount': onProjectItemCount,
    'returningItemCount': returningItemCount,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate?.toIso8601String(),
  };

}
