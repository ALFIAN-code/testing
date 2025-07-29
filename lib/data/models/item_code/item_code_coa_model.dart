class ItemCodeCoaModel {
  final String id;
  final String name;

  ItemCodeCoaModel({
    required this.id,
    required this.name,
  });

  factory ItemCodeCoaModel.fromJson(Map<String, dynamic> json) => ItemCodeCoaModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'name': name,
    };
}
