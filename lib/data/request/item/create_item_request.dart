import '../item_test/create_item_test_inspection_image_request.dart';
import 'create_item_image_request.dart';

class CreateItemRequest {
  final String itemCodeId;
  final String? barcode;
  final String description;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? specification;
  final String? poReference;
  final DateTime? purchasedDate;
  final List<CreateItemImageRequest> itemImages;
  final double? quantity;

  CreateItemRequest({
    required this.itemCodeId,
    this.barcode,
    required this.description,
    this.brand,
    this.model,
    this.serialNumber,
    this.specification,
    this.poReference,
    this.purchasedDate,
    this.itemImages = const [],
    this.quantity,
  });

  factory CreateItemRequest.fromJson(Map<String, dynamic> json) => CreateItemRequest(
      itemCodeId: json['item_code_id'] as String,
      barcode: json['barcode'] as String?,
      description: json['description'] as String? ?? '',
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      serialNumber: json['serial_number'] as String?,
      specification: json['specification'] as String?,
      poReference: json['po_reference'] as String?,
      purchasedDate: json['purchased_date'] != null
          ? DateTime.parse(json['purchased_date'] as String)
          : null,
      itemImages: (json['item_images'] as List<dynamic>?)
          ?.map((e) =>
          CreateItemImageRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <CreateItemImageRequest>[],
      quantity: (json['quantity'] as num?)?.toDouble(),
    );

  Map<String, dynamic> toJson() => {
      'item_code_id': itemCodeId,
      'barcode': barcode,
      'description': description,
      'brand': brand,
      'model': model,
      'serial_number': serialNumber,
      'specification': specification,
      'po_reference': poReference,
      'purchased_date': purchasedDate?.toIso8601String(),
      'item_images': itemImages.map((CreateItemImageRequest e) => e.toJson()).toList(),
      'quantity': quantity,
    };
}
