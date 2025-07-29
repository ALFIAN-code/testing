import 'dart:math';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/vendor_goods_model.dart';
import '../../../models/vendor_goods_reception_detail_model.dart';
import '../interfaces/i_vendor_reception_detail_provider.dart';

class RemoteVendorGoodsReceptionDetailProvider
    implements IVendorReceptionDetailProvider {
  RemoteVendorGoodsReceptionDetailProvider({required this.dioClient});
  final DioClient dioClient;

  VendorGoodsReceptionDetailModel _generateMockReceptionDetail(
    String receptionId,
  ) {
    final Random random = Random(receptionId.hashCode);

    final List<String> vendorNames = <String>[
      'PT. Gudang Makmur',
      'PT. Logistik Prima',
      'UD. Perkakas Nusantara',
      'CV. Sumber Rejeki',
    ];

    final List<String> materialTypes = <String>[
      'Elektronik',
      'Peralatan',
      'Bahan Baku',
      'Spare Part',
      'Konsumsi',
    ];

    final List<String> itemNames = <String>[
      'Kabel USB Type-C',
      'Power Supply 12V',
      'Resistor 1K Ohm',
      'Kapasitor 100uF',
      'LED 5mm',
      'Transistor BC547',
      'IC 555 Timer',
      'Relay 12V',
    ];

    final int itemCount = random.nextInt(10) + 5;
    final List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.generate(
          itemCount,
          (int index) => <String, dynamic>{
            'id': receptionId,
            'code': 'ITM-${(1000 + index).toString()}',
            'name': itemNames[random.nextInt(itemNames.length)],
            'materialType': materialTypes[random.nextInt(materialTypes.length)],
            'quantity': random.nextInt(100) + 1,
          },
        );

    final DateTime baseDate = DateTime(2025, 1, 15);
    final DateTime estimatedDate = baseDate.add(
      Duration(days: random.nextInt(30)),
    );
    final DateTime estimatedTime = DateTime(
      estimatedDate.year,
      estimatedDate.month,
      estimatedDate.day,
      8 + random.nextInt(10),
      random.nextInt(60),
    );

    return VendorGoodsReceptionDetailModel(
      id: receptionId,
      poNumber: 'PO-${(10000 + random.nextInt(9999)).toString()}',
      vendorName: vendorNames[random.nextInt(vendorNames.length)],
      estimatedArrivalDate: estimatedDate,
      estimatedArrivalTime: estimatedTime,
      submitDate: baseDate.subtract(Duration(days: random.nextInt(7))),
      items:
          items
              .map(
                (Map<String, dynamic> item) => VendorGoodsModel.fromJson(item),
              )
              .toList(),
      itemCount: itemCount,
      rejectionReason: random.nextBool() ? null : 'Dokumen tidak lengkap',
    );
  }

  @override
  Future<VendorGoodsReceptionDetailModel> getVendorGoodsReceptionDetail({
    required String receptionId,
    required int page,
    required int pageSize,
    String? sortField,
    bool? sortAscending,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));

      final VendorGoodsReceptionDetailModel detail =
          _generateMockReceptionDetail(receptionId);

      List<VendorGoodsModel> sortedItems = List<VendorGoodsModel>.from(
        detail.items,
      );
      if (sortField != null) {
        sortedItems = _applySorting(
          sortedItems,
          sortField,
          sortAscending ?? true,
        );
      }

      final Map<String, dynamic> paginationResult = _applyPaginationToItems(
        sortedItems,
        page,
        pageSize,
      );

      final List<VendorGoodsModel> pagedItems =
          paginationResult['pagedItems'] as List<VendorGoodsModel>;

      return VendorGoodsReceptionDetailModel(
        id: detail.id,
        poNumber: detail.poNumber,
        vendorName: detail.vendorName,
        estimatedArrivalDate: detail.estimatedArrivalDate,
        estimatedArrivalTime: detail.estimatedArrivalTime,
        submitDate: detail.submitDate,
        items: pagedItems,
        itemCount: detail.itemCount,
        rejectionReason: detail.rejectionReason,
      );
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to fetch vendor goods reception detail: $e');
    }
  }

  List<VendorGoodsModel> _applySorting(
    List<VendorGoodsModel> items,
    String sortField,
    bool sortAscending,
  ) {
    final List<VendorGoodsModel> sortedItems = List<VendorGoodsModel>.from(
      items,
    );

    sortedItems.sort((VendorGoodsModel a, VendorGoodsModel b) {
      int comparison = 0;

      switch (sortField.toLowerCase()) {
        case 'code':
          comparison = a.code.compareTo(b.code);
          break;
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'materialtype':
          comparison = a.materialType.compareTo(b.materialType);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }

      return sortAscending ? comparison : -comparison;
    });

    return sortedItems;
  }

  Map<String, dynamic> _applyPaginationToItems(
    List<VendorGoodsModel> items,
    int page,
    int pageSize,
  ) {
    final int totalItems = items.length;
    final int totalPages = (totalItems / pageSize).ceil();
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = min(startIndex + pageSize, totalItems);

    List<VendorGoodsModel> pagedItems = <VendorGoodsModel>[];
    if (startIndex < items.length) {
      pagedItems = items.sublist(startIndex, endIndex);
    }

    return <String, dynamic>{
      'pagedItems': pagedItems,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }
}
