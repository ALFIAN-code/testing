class CreateItemTestInspectionParameterRequest {
  final String inspectionParameterId;
  final bool isQualified;

  CreateItemTestInspectionParameterRequest({
    required this.inspectionParameterId,
    required this.isQualified,
  });

  factory CreateItemTestInspectionParameterRequest.fromJson(Map<String, dynamic> json) => CreateItemTestInspectionParameterRequest(
      inspectionParameterId: json['inspectionParameterId'] as String,
      isQualified: json['isQualified'] as bool,
    );

  Map<String, dynamic> toJson() => {
      'inspectionParameterId': inspectionParameterId,
      'isQualified': isQualified,
    };
}
