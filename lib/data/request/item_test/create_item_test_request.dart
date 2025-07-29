import 'create_item_test_inspection_request.dart';

class CreateItemTestRequest {
  final String toolStatusId;
  final String conditionId;
  final DateTime testedDate;
  final List<CreateItemTestInspectionRequest> itemTestInspections;

  CreateItemTestRequest({
    required this.toolStatusId,
    required this.conditionId,
    DateTime? testedDate,
    List<CreateItemTestInspectionRequest>? itemTestInspections,
  })  : testedDate = testedDate ?? DateTime.now().toUtc(),
        itemTestInspections = itemTestInspections ?? [];

  factory CreateItemTestRequest.fromJson(Map<String, dynamic> json) => CreateItemTestRequest(
      toolStatusId: json['toolStatusId'] as String,
      conditionId: json['coditionId'] as String,
      testedDate: DateTime.parse(json['testedDate'] as String),
      itemTestInspections: (json['itemTestInspections'] as List<dynamic>?)
          ?.map((e) => CreateItemTestInspectionRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );

  Map<String, dynamic> toJson() => {
      'toolStatusId': toolStatusId,
      'coditionId': conditionId,
      'testedDate': testedDate.toIso8601String(),
      'itemTestInspections': itemTestInspections.map((e) => e.toJson()).toList(),
    };
}
