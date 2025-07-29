class ItemRequestPaginatedModel {
  final String id;
  final String projectId;
  final String code;
  final bool isProcessed;
  final DateTime? updatedDate;

  ItemRequestPaginatedModel({
    required this.id,
    required this.projectId,
    required this.code,
    required this.isProcessed,
    this.updatedDate,
  });

  factory ItemRequestPaginatedModel.fromJson(Map<String, dynamic> json) => ItemRequestPaginatedModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      code: json['code'] as String? ?? '',
      isProcessed: json['isProcessed'] as bool,
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'] as String)
          : null,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'code': code,
      'isProcessed': isProcessed,
      'updatedDate': updatedDate?.toIso8601String(),
    };
}
