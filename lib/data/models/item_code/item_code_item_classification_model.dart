// item_code_item_classification_model.dart
class ItemCodeItemClassificationModel {
  final String id;
  final String name;

  ItemCodeItemClassificationModel({
    required this.id,
    required this.name,
  });

  factory ItemCodeItemClassificationModel.fromJson(Map<String, dynamic> json) => ItemCodeItemClassificationModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
    };
}
