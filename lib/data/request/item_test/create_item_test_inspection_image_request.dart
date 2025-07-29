class CreateItemTestInspectionImageRequest {
  final String imagePath;

  CreateItemTestInspectionImageRequest({
    required this.imagePath,
  });

  factory CreateItemTestInspectionImageRequest.fromJson(Map<String, dynamic> json) => CreateItemTestInspectionImageRequest(
      imagePath: json['imagePath'] as String,
    );

  Map<String, dynamic> toJson() => {
      'imagePath': imagePath,
    };
}
