class ItemMaintenanceInspectionImageModel {
  final String id;
  final String itemMaintenanceInspectionId;
  final String imagePath;

  ItemMaintenanceInspectionImageModel({
    required this.id,
    required this.itemMaintenanceInspectionId,
    required this.imagePath,
  });

  factory ItemMaintenanceInspectionImageModel.fromJson(Map<String, dynamic> json) => ItemMaintenanceInspectionImageModel(
      id: json['id'] as String,
      itemMaintenanceInspectionId: json['itemMaintenanceInspectionId'] as String,
      imagePath: json['imagePath'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'itemMaintenanceInspectionId': itemMaintenanceInspectionId,
      'imagePath': imagePath,
    };
}
