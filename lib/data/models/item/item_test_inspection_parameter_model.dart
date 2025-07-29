class ItemTestInspectionParameterModel {
  String id;
  String name;

  ItemTestInspectionParameterModel({
    required this.id,
    required this.name,
  });

  factory ItemTestInspectionParameterModel.fromJson(Map<String, dynamic> json) => ItemTestInspectionParameterModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'name': name,
    };
}
