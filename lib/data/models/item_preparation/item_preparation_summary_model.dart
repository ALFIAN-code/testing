class ItemPreparationSummaryModel {
  final String itemCodeId;
  final String itemCodeCode;
  final String itemCodeName;
  final double approvedCount;
  final double scannedCount;

  ItemPreparationSummaryModel({
    required this.itemCodeId,
    required this.itemCodeCode,
    required this.itemCodeName,
    required this.approvedCount,
    required this.scannedCount,
  });

  factory ItemPreparationSummaryModel.fromJson(Map<String, dynamic> json) => ItemPreparationSummaryModel(
      itemCodeId: json['itemCodeId'] as String,
      itemCodeCode: json['itemCodeCode'] as String? ?? '',
      itemCodeName: json['itemCodeName'] as String? ?? '',
      approvedCount: (json['approvedCount'] as num).toDouble(),
      scannedCount: (json['scannedCount'] as num).toDouble(),
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'itemCodeId': itemCodeId,
      'itemCodeCode': itemCodeCode,
      'itemCodeName': itemCodeName,
      'approvedCount': approvedCount,
      'scannedCount': scannedCount,
    };
}
