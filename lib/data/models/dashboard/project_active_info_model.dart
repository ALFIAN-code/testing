class ProjectActiveInfoModel {
  final int total;
  final int deadline;

  ProjectActiveInfoModel({
    required this.total,
    required this.deadline,
  });

  factory ProjectActiveInfoModel.fromJson(Map<String, dynamic> json) => ProjectActiveInfoModel(
      total: json['total'] as int? ?? 0,
      deadline: json['deadline'] as int? ?? 0,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'total': total,
      'deadline': deadline,
    };
}
