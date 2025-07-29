class ItemImageModel {
  final String id;
  final String itemId;
  final String imagePath;

  ItemImageModel({
    required this.id,
    required this.itemId,
    required this.imagePath,
  });

  factory ItemImageModel.fromJson(Map<String, dynamic> json) => ItemImageModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      imagePath: json['imagePath'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => <String, String>{
      'id': id,
      'itemId': itemId,
      'imagePath': imagePath,
    };
}
