class ItemVendorItemVendorChecklistParam {
  String? id;
  bool? isSuitable;
  String note;
  String itemVendorChecklistId;

  ItemVendorItemVendorChecklistParam({
    this.id,
    this.isSuitable,
    this.note = '',
    required this.itemVendorChecklistId,
  });

  factory ItemVendorItemVendorChecklistParam.fromJson(Map<String, dynamic> json) => ItemVendorItemVendorChecklistParam(
      id: json['id'] as String?,
      isSuitable: json['isSuitable'] as bool? ?? true,
      note: json['note'] as String? ?? '',
      itemVendorChecklistId: json['itemVendorChecklistId'] as String,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'isSuitable': isSuitable,
      'note': note,
      'itemVendorChecklistId': itemVendorChecklistId,
    };
}
