import 'item_test_inspection_parameter_param.dart';

class ItemTestInspectionParam {
  final String inspectionId;
  final String inspectionName;
  final String note;
  final List<String> imageList;
  final List<ItemTestInspectionParameterParam> itemTestInspectionParameters;

  ItemTestInspectionParam({
    required this.inspectionId,
    this.inspectionName = '',
    this.note = '',
    this.imageList = const <String>[],
    this.itemTestInspectionParameters = const <ItemTestInspectionParameterParam>[],
  });

  factory ItemTestInspectionParam.fromJson(Map<String, dynamic> json) => ItemTestInspectionParam(
      inspectionId: json['inspectionId'] as String,
      note: json['note'] as String? ?? '',
      itemTestInspectionParameters: (json['itemTestInspectionParameters'] as List<dynamic>?)
          ?.map((e) => ItemTestInspectionParameterParam.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'inspectionId': inspectionId,
    'inspectionName': inspectionName,
      'note': note,
      'itemTestInspectionParameters':
      itemTestInspectionParameters.map((e) => e.toJson()).toList(),
    };

  ItemTestInspectionParam copyWith({
    String? inspectionId,
    String? inspectionName,
    String? note,
    List<String>? imageList,
    List<ItemTestInspectionParameterParam>? itemTestInspectionParameters,
  }) => ItemTestInspectionParam(
      inspectionId: inspectionId ?? this.inspectionId,
      inspectionName: inspectionName ?? this.inspectionName,
      note: note ?? this.note,
      itemTestInspectionParameters:
      itemTestInspectionParameters ?? this.itemTestInspectionParameters,
    imageList: imageList ?? this.imageList
    );
}
