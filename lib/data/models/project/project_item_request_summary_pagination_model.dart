class ProjectItemRequestSummaryPaginatedModel {
  final String id;
  final String name;
  final String code;
  final int itemRequestCount;
  final double itemRequestItemApprovedCount;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final int index;

  ProjectItemRequestSummaryPaginatedModel({
    required this.id,
    required this.name,
    required this.code,
    required this.itemRequestCount,
    required this.itemRequestItemApprovedCount,
    required this.createdDate,
    this.updatedDate,
    this.index = 0,
  });

  factory ProjectItemRequestSummaryPaginatedModel.fromJson(Map<String, dynamic> json, {int index = 0}) => ProjectItemRequestSummaryPaginatedModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      itemRequestCount: (json['itemRequestCount'] as num).toInt(),
      itemRequestItemApprovedCount: (json['itemRequestItemApprovedCount'] as num).toDouble(),
      createdDate: DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] != null ? DateTime.parse(json['updatedDate'] as String) : null,
      index: index,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'itemRequestCount': itemRequestCount,
      'itemRequestItemApprovedCount': itemRequestItemApprovedCount,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };


}
