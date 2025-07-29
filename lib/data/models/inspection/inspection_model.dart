import 'inspection_parameter_model.dart';

class InspectionModel {
  final String id;
  final String name;
  final List<InspectionParameterModel>? inspectionParameters;

  InspectionModel({
    required this.id,
    required this.name,
    this.inspectionParameters,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) => InspectionModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      inspectionParameters: json['inspectionParameters'] != null
          ? (json['inspectionParameters'] as List<dynamic>)
          .map((e) => InspectionParameterModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'inspectionParameters': inspectionParameters?.map((e) => e.toJson()).toList(),
    };
}