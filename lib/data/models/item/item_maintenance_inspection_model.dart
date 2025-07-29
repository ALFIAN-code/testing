import '../inspection/inspection_model.dart';

class ItemMaintenanceInspectionModel {
  final String id;
  final String itemMaintenanceId;
  final String inspectionId;
  final String note;
  final InspectionModel? inspection;

  ItemMaintenanceInspectionModel({
    required this.id,
    required this.itemMaintenanceId,
    required this.inspectionId,
    required this.note,
    this.inspection,
  });

  factory ItemMaintenanceInspectionModel.fromJson(Map<String, dynamic> json) => ItemMaintenanceInspectionModel(
      id: json['id'] as String,
      itemMaintenanceId: json['itemMaintenanceId'] as String,
      inspectionId: json['inspectionId'] as String,
      note: json['note'] as String? ?? '',
      inspection: json['inspection'] != null
          ? InspectionModel.fromJson(json['inspection'] as Map<String, dynamic>)
          : null,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'itemMaintenanceId': itemMaintenanceId,
      'inspectionId': inspectionId,
      'note': note,
      'inspection': inspection?.toJson(),
    };
}
