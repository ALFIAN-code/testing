class ItemPreparationCountModel {
  final int approvedCount;
  final int preparedCount;

  ItemPreparationCountModel({
    required this.approvedCount,
    required this.preparedCount,
  });

  factory ItemPreparationCountModel.fromJson(Map<String, dynamic> json) => ItemPreparationCountModel(
    approvedCount: json['approvedCount'] as int? ?? 0,
    preparedCount: json['preparedCount'] as int? ?? 0,
  );
}
