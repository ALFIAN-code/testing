class ScanStatusCountModel {
  final int onProjectItemCount ;
  final int returningItemCount ;

  ScanStatusCountModel({
    required this.onProjectItemCount,
    required this.returningItemCount,
  });

  factory ScanStatusCountModel.fromJson(Map<String, dynamic> json) => ScanStatusCountModel(
    onProjectItemCount: json['onProjectItemCount'] as int? ?? 0,
    returningItemCount: json['returningItemCount'] as int? ?? 0,
    );
}
