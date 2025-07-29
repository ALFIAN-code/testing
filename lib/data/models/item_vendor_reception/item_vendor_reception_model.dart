import '../supplier/supplier_model.dart';
import 'item_vendor_reception_checklist_model.dart';

class ItemVendorReceptionModel {
  final String id;
  final String code;
  final String poNumber;
  final String poFilePath;
  final SupplierModel? supplier;
  final DateTime createdDate;
  final DateTime estimatedDate;
  final String? estimatedTime;
  final String reasonRejected;
  final String deliveryNoteNumber;
  final String deliveryNoteImagePath;
  final String reasonRevised;
  final String reasonApproved;
  final List<ItemVendorReceptionChecklistModel> checklists;

  ItemVendorReceptionModel({
    required this.id,
    required this.code,
    required this.poNumber,
    required this.poFilePath,
    required this.supplier,
    required this.createdDate,
    required this.estimatedDate,
    this.estimatedTime,
    required this.reasonRejected,
    required this.deliveryNoteNumber,
    required this.deliveryNoteImagePath,
    required this.reasonRevised,
    required this.reasonApproved,
    required this.checklists,
  });

  factory ItemVendorReceptionModel.fromJson(Map<String, dynamic> json) => ItemVendorReceptionModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      poNumber: json['poNumber'] as String? ?? '',
      poFilePath: json['poFilePath'] as String? ?? '',
      supplier: json['supplier'] != null ? SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>) : null,
      createdDate: DateTime.parse(json['createdDate'] as String),
      estimatedDate: DateTime.parse(json['estimatedDate'] as String),
      estimatedTime: json['estimatedTime'] as String?,
      reasonRejected: json['reasonRejected'] as String? ?? '',
      deliveryNoteNumber: json['deliveryNoteNumber'] as String? ?? '',
      deliveryNoteImagePath: json['deliveryNoteImagePath'] as String? ?? '',
      reasonRevised: json['reasonRevised'] as String? ?? '',
      reasonApproved: json['reasonApproved'] as String? ?? '',
      checklists: (json['checklists'] as List<dynamic>?)
          ?.map((e) => ItemVendorReceptionChecklistModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'poNumber': poNumber,
    'poFilePath': poFilePath,
    'supplier': supplier,
    'createdDate': createdDate.toIso8601String(),
    'estimatedDate': estimatedDate.toIso8601String(),
    'estimatedTime': estimatedTime,
    'reasonRejected': reasonRejected,
    'deliveryNoteNumber': deliveryNoteNumber,
    'deliveryNoteImagePath': deliveryNoteImagePath,
    'reasonRevised': reasonRevised,
    'reasonApproved': reasonApproved,
    'checklists': checklists.map((e) => e.toJson()).toList(),
  };
}
