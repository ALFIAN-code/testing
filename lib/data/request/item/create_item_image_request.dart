class CreateItemImageRequest {
  final String imagePath;

  CreateItemImageRequest({
    required this.imagePath,
  });

  factory CreateItemImageRequest.fromJson(Map<String, dynamic> json) => CreateItemImageRequest(
    imagePath: json['image_path'] as String,
  );

  Map<String, dynamic> toJson() => {
    'image_path': imagePath,
  };
}
