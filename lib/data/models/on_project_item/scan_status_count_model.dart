class ScanStatusCountModel {
  final int receivedCount;
  final int shippedCount;

  ScanStatusCountModel({
    required this.receivedCount,
    required this.shippedCount,
  });

  factory ScanStatusCountModel.fromJson(Map<String, dynamic> json) => ScanStatusCountModel(
      receivedCount: json['receivedCount'] as int? ?? 0,
      shippedCount: json['shippedCount'] as int? ?? 0,
    );
}
