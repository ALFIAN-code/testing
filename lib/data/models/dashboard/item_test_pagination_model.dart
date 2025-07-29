class ItemTestPaginationModel {
  final String id;
  final String barcode;
  final String lastTestedDate;
  final int nextTestDay;
  final bool hasTested;
  final bool isRetested;
  final String itemCodeId;
  final ItemCode itemCode;
  final List<ItemInspection> itemInspections;
  final int index;

  ItemTestPaginationModel({
    required this.id,
    required this.barcode,
    required this.lastTestedDate,
    required this.nextTestDay,
    required this.hasTested,
    required this.isRetested,
    required this.itemCodeId,
    required this.itemCode,
    required this.itemInspections,
    required this.index,
  });

  factory ItemTestPaginationModel.fromJson(Map<String, dynamic> json) => ItemTestPaginationModel(
      id: json['id'] as String,
      barcode: json['barcode'] as String,
      lastTestedDate: json['lastTestedDate'] as String,
      nextTestDay: json['nextTestDay'] as int,
      hasTested: json['hasTested'] as bool,
      isRetested: json['isRetested'] as bool,
      itemCodeId: json['itemCodeId'] as String,
      itemCode: ItemCode.fromJson(json['itemCode'] as Map<String, dynamic>),
      itemInspections:
          List<ItemInspection>.from(
                (json['itemInspections'] as List<dynamic>).map((x) => ItemInspection.fromJson(x as Map<String, dynamic>)),
              ),

      index: json['index'] as int,
    );
}

class ItemCode {
  final String id;
  final String name;
  final String code;
  final String description;
  final int maintenanceIntervalDay;
  final ItemCodeCategory itemCodeCategory;

  ItemCode({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.maintenanceIntervalDay,
    required this.itemCodeCategory,
  });

  factory ItemCode.fromJson(Map<String, dynamic> json) => ItemCode(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String,
    description: json['description'] as String,
    maintenanceIntervalDay: json['maintenanceIntervalDay'] as int,
    itemCodeCategory: ItemCodeCategory.fromJson(
      json['itemCodeCategory'] as Map<String, dynamic>,
    ),
  );
}

class ItemCodeCategory {
  final String id;
  final String name;
  final String code;

  ItemCodeCategory({required this.id, required this.name, required this.code});

  factory ItemCodeCategory.fromJson(Map<String, dynamic> json) =>
      ItemCodeCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
      );
}

class ItemInspection {
  final String id;
  final String name;
  final List<dynamic> parameters;

  ItemInspection({
    required this.id,
    required this.name,
    required this.parameters,
  });

  factory ItemInspection.fromJson(Map<String, dynamic> json) => ItemInspection(
    id: json['id'] as String,
    name: json['name'] as String,
    parameters: json['parameters'] as List<dynamic>,
  );
}
