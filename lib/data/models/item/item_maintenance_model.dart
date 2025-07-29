import '../tools_status/tool_status_model.dart';
import 'item_maintenance_inspection_image_model.dart';
import 'item_maintenance_inspection_model.dart';

class ItemMaintenanceModel {
  final String id;
  final String itemId;
  final String toolStatusId;
  final DateTime testedDate;
  final ToolStatusModel? toolStatus;
  final List<ItemMaintenanceInspectionModel> itemMaintenanceInspections;
  final List<ItemMaintenanceInspectionImageModel> itemMaintenanceInspectionImages;

  ItemMaintenanceModel({
    required this.id,
    required this.itemId,
    required this.toolStatusId,
    required this.testedDate,
    this.toolStatus,
    required this.itemMaintenanceInspections,
    required this.itemMaintenanceInspectionImages,
  });

  factory ItemMaintenanceModel.fromJson(Map<String, dynamic> json) => ItemMaintenanceModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      toolStatusId: json['toolStatusId'] as String,
      testedDate: DateTime.parse(json['testedDate'] as String),
      toolStatus: json['toolStatus'] != null
          ? ToolStatusModel.fromJson(json['toolStatus'] as Map<String, dynamic>)
          : null,
      itemMaintenanceInspections: (json['itemMaintenanceInspections'] as List<dynamic>)
          .map((e) => ItemMaintenanceInspectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemMaintenanceInspectionImages: (json['itemMaintenanceInspectionImages'] as List<dynamic>)
          .map((e) => ItemMaintenanceInspectionImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'itemId': itemId,
      'toolStatusId': toolStatusId,
      'testedDate': testedDate.toIso8601String(),
      'toolStatus': toolStatus?.toJson(),
      'itemMaintenanceInspections': itemMaintenanceInspections.map((e) => e.toJson()).toList(),
      'itemMaintenanceInspectionImages': itemMaintenanceInspectionImages.map((e) => e.toJson()).toList(),
    };
}
