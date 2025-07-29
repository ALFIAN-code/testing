import 'item_test_inspection_parameter_model.dart';

class ItemTestInspectionModel {
  String id;
  String name;
  List<ItemTestInspectionParameterModel> parameters;

  ItemTestInspectionModel({
    required this.id,
    required this.name,
    List<ItemTestInspectionParameterModel>? parameters,
  }) : parameters = parameters ?? [];

  factory ItemTestInspectionModel.fromJson(Map<String, dynamic> json) => ItemTestInspectionModel(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    parameters: (json['parameters'] as List<dynamic>?)
        ?.map((e) => ItemTestInspectionParameterModel.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );


  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'parameters': parameters.map((e) => e.toJson()).toList(),
    };
}
