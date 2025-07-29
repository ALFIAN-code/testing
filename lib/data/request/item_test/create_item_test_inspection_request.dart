import 'create_item_test_inspection_image_request.dart';
import 'create_item_test_inspection_parameter_request.dart';

class CreateItemTestInspectionRequest {
  final String inspectionId;
  final String note;
  final List<CreateItemTestInspectionParameterRequest> itemTestInspectionParameters;
  final List<CreateItemTestInspectionImageRequest> itemTestInspectionImages;

  CreateItemTestInspectionRequest({
    required this.inspectionId,
    required this.note,
    List<CreateItemTestInspectionParameterRequest>? itemTestInspectionParameters,
    List<CreateItemTestInspectionImageRequest>? itemTestInspectionImages,
  })  : itemTestInspectionParameters = itemTestInspectionParameters ?? [],
        itemTestInspectionImages = itemTestInspectionImages ?? [];

  factory CreateItemTestInspectionRequest.fromJson(Map<String, dynamic> json) => CreateItemTestInspectionRequest(
      inspectionId: json['inspectionId'] as String,
      note: json['note'] as String,
      itemTestInspectionParameters:
      (json['itemTestInspectionParameters'] as List<dynamic>?)
          ?.map((e) => CreateItemTestInspectionParameterRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      itemTestInspectionImages:
      (json['itemTestInspectionImages'] as List<dynamic>?)
          ?.map((e) => CreateItemTestInspectionImageRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'inspectionId': inspectionId,
      'note': note,
      'itemTestInspectionParameters': itemTestInspectionParameters.map((CreateItemTestInspectionParameterRequest e) => e.toJson()).toList(),
      'itemTestInspectionImages': itemTestInspectionImages.map((CreateItemTestInspectionImageRequest e) => e.toJson()).toList(),
    };
}
