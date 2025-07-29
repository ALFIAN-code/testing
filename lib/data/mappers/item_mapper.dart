
import '../../domain/entities/item_entity.dart';
import '../models/item/item_model.dart';

extension ItemModelMapper on ItemModel {
  ItemEntity toEntity() => ItemEntity(
      id: id,
      itemCodeId: itemCode?.id ?? '',
      barcode: barcode,
      description: description ?? '',
      brand: brand,
      model: model,
      serialNumber: serialNumber,
      specification: specification,
      poReference: poReference,
      purchasedDate: purchasedDate,
      conditionId: condition?.id ?? '',
      projectId: projectId,
      lastLocationName: lastLocationName ?? '',
      quantity: quantity ?? 0.0,
      lastUpdate: DateTime.now(),
    );
}