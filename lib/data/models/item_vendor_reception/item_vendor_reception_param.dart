import '../item_vendor_item_vendor_checklist/item_vendor_item_vendor_checklist_param.dart';

class ItemVendorReceptionParam {
  String? id;
  String deliveryNoteNumber;
  String deliveryNoteImagePath;
  String reasonRejected;
  String? updatedBy;
  List<ItemVendorItemVendorChecklistParam> checklists;

  ItemVendorReceptionParam({
    this.id,
    this.deliveryNoteNumber = '',
    this.deliveryNoteImagePath = '',
    this.reasonRejected = '',
    this.updatedBy,
    this.checklists = const <ItemVendorItemVendorChecklistParam>[],
  });

  factory ItemVendorReceptionParam.fromJson(Map<String, dynamic> json) => ItemVendorReceptionParam(
      id: json['id'] as String?,
      deliveryNoteNumber: json['deliveryNoteNumber'] as String? ?? '',
      deliveryNoteImagePath: json['deliveryNoteImagePath'] as String? ?? '',
      reasonRejected: json['reasonRejected'] as String? ?? '',
      updatedBy: json['updatedBy'] as String?,
      checklists: (json['checklists'] as List<dynamic>?)
          ?.map((dynamic e) => ItemVendorItemVendorChecklistParam.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <ItemVendorItemVendorChecklistParam>[],
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'deliveryNoteNumber': deliveryNoteNumber,
      'deliveryNoteImagePath': deliveryNoteImagePath,
      'reasonRejected': reasonRejected,
      'updatedBy': updatedBy,
      'items': checklists.map((e) => e.toJson()).toList(),
    };

  ItemVendorReceptionParam copyWith({
    String? id,
    String? deliveryNoteNumber,
    String? deliveryNoteImagePath,
    String? reasonRejected,
    String? updatedBy,
    List<ItemVendorItemVendorChecklistParam>? checklists,
  }) => ItemVendorReceptionParam(
      id: id ?? this.id,
      deliveryNoteNumber: deliveryNoteNumber ?? this.deliveryNoteNumber,
      deliveryNoteImagePath: deliveryNoteImagePath ?? this.deliveryNoteImagePath,
      reasonRejected: reasonRejected ?? this.reasonRejected,
      updatedBy: updatedBy ?? this.updatedBy,
      checklists: checklists ?? this.checklists,
    );
}
