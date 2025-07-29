// item_code_inspection_model.dart
class ItemCodeInspectionModel {
  final String id;
  final String name;

  ItemCodeInspectionModel({
    required this.id,
    required this.name,
  });

  factory ItemCodeInspectionModel.fromJson(Map<String, dynamic> json) => ItemCodeInspectionModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
    };
}
