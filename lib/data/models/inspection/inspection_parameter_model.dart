
class InspectionParameterModel {
  final String id;
  final String inspectionId;
  final String name;

  InspectionParameterModel({
    required this.id,
    required this.inspectionId,
    required this.name,
  });

  factory InspectionParameterModel.fromJson(Map<String, dynamic> json) => InspectionParameterModel(
    id: json['id'] as String,
    inspectionId: json['inspectionId'] as String,
    name: json['name'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'inspectionId': inspectionId,
    'name': name,
  };
}
