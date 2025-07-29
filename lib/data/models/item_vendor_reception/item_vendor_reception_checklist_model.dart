import '../item_vendor_checklist/item_vendor_checklist_model.dart';

class ItemVendorReceptionChecklistModel {
  final String id;
  final String note;
  final bool isSuitable;
  final String itemVendorId;
  final String itemVendorChecklistId;
  final ItemVendorChecklistModel? itemVendorChecklist;

  ItemVendorReceptionChecklistModel({
    required this.id,
    required this.note,
    required this.isSuitable,
    required this.itemVendorId,
    required this.itemVendorChecklistId,
    this.itemVendorChecklist,
  });

  factory ItemVendorReceptionChecklistModel.fromJson(Map<String, dynamic> json) => ItemVendorReceptionChecklistModel(
      id: json['id'] as String,
      note: json['note'] as String ?? '',
      isSuitable: json['isSuitable'] as bool,
      itemVendorId: json['itemVendorId'] as String ?? '',
      itemVendorChecklistId: json['itemVendorChecklistId'] as String ?? '',
      itemVendorChecklist: json['itemVendorChecklist'] != null
          ? ItemVendorChecklistModel.fromJson(json['itemVendorChecklist'] as Map<String, dynamic>)
          : null,
    );


  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'note': note,
      'isSuitable': isSuitable,
      'itemVendorId': itemVendorId,
      'itemVendorChecklistId': itemVendorChecklistId,
      'itemVendorChecklist': itemVendorChecklist?.toJson(),
    };
}
