class ItemTestInspectionParameterParam {
  final String inspectionParameterId;
  final String inspectionParameterName;
  final bool? isQualified;

  ItemTestInspectionParameterParam({
    required this.inspectionParameterId,
    this.inspectionParameterName = '',
    this.isQualified,
  });

  factory ItemTestInspectionParameterParam.fromJson(Map<String, dynamic> json) => ItemTestInspectionParameterParam(
      inspectionParameterId: json['inspectionParameterId'] as String,
      isQualified: json['isQualified'] as bool?,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'inspectionParameterId': inspectionParameterId,
      'isQualified': isQualified,
    };

  ItemTestInspectionParameterParam copyWith({
    String? inspectionParameterId,
    String? inspectionParameterName,
    bool? isQualified,
  }) => ItemTestInspectionParameterParam(
      inspectionParameterId: inspectionParameterId ?? this.inspectionParameterId,
      inspectionParameterName: inspectionParameterName ?? this.inspectionParameterName,
      isQualified: isQualified ?? this.isQualified,
    );
}
