class ItemTestInfoModel {
  final int total;
  final int today;
  final int late;

  ItemTestInfoModel({required this.total, required this.today, required this.late});

  factory ItemTestInfoModel.fromJson(Map<String, dynamic> json) => ItemTestInfoModel(
      total: json['total'] as int? ?? 0,
      today: json['today'] as int? ?? 0,
      late: json['late'] as int? ?? 0,
    );

  Map<String, dynamic> toJson() => <String, dynamic >{
    'total': total,
    'today': today,
    'late': late,
  };
}
