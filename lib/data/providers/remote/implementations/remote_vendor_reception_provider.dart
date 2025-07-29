import 'dart:math';

import 'package:dio/dio.dart';

import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/vendor_goods_reception_model.dart';
import '../interfaces/i_vendor_reception_provider.dart';

class RemoteVendorGoodsReceptionProvider implements IVendorReceptionProvider {
  RemoteVendorGoodsReceptionProvider({required this.dioClient});
  final DioClient dioClient;

  final List<Map<String, dynamic>> _fullMockData =
      List<Map<String, dynamic>>.generate(
        100,
        (int index) => <String, dynamic>{
          'id': (index + 1).toString(),
          'code': 'PG-${(index + 1).toString().padLeft(5, '0')}',
          'vendor_name': _getRandomVendorName(index),
          'delivery_date':
              DateTime(2025, 5, (index % 28) + 1).toIso8601String(),
          'delivery_time':
              '${(8 + (index % 12)).toString().padLeft(2, '0')}.00 WIB',
          'po_number': 'PO-${(10100 + index + 1).toString()}',
          'item_count': (index % 5) + 1,
          'status': _getRandomStatus(index),
          'verification_status': _getRandomVerification(index),
          'submit_date': DateTime(2025, 5, (index % 28) + 1).toIso8601String(),
        },
      );

  static String _getRandomVendorName(int index) {
    final List<String> vendors = <String>[
      'PT. Gudang Makmur',
      'PT. Logistik Prima',
      'UD. Perkakas Nusantara',
      'CV. Sumber Rejeki',
      'PT. Mitra Sejahtera',
      'UD. Berkah Jaya',
      'PT. Cahaya Indah',
      'CV. Karya Mandiri',
    ];
    return vendors[index % vendors.length];
  }

  static String _getRandomStatus(int index) {
    final List<String> statuses = <String>[
      'Submitted',
      'Pengajuan Laporan',
      'Approved',
      'Rejected',
    ];
    return statuses[index % statuses.length];
  }

  static String _getRandomVerification(int index) {
    final List<String> verifications = <String>[
      'Belum diperiksa',
      'Tidak Sesuai',
      'Sesuai',
      'Perlu Review',
    ];
    return verifications[index % verifications.length];
  }

  @override
  Future<PaginationResponseModel<VendorGoodsReceptionModel>>
  getVendorGoodsReceptions({
    required int page,
    required int pageSize,
    String? filterByStatus,
    String? filterByVerification,
    String? searchQuery,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final Map<String, dynamic> requestBody = _prepareRequestBody(
        page,
        pageSize,
        filterByStatus,
        filterByVerification,
        searchQuery,
      );

      final List<Map<String, dynamic>> processedData = _processData(
        filterByStatus: filterByStatus,
        filterByVerification: filterByVerification,
        searchQuery: searchQuery,
      );

      final Map<String, dynamic> paginationResult = _applyPagination(
        processedData,
        page,
        pageSize,
      );

      final List<Map<String, dynamic>> pagedData =
          paginationResult['pagedData'] as List<Map<String, dynamic>>;
      final int totalItems = paginationResult['totalItems'] as int;
      final int totalPages = paginationResult['totalPages'] as int;

      final Response<dynamic> response = _createMockResponse(
        requestBody,
        pagedData,
        page,
        pageSize,
        totalItems,
        totalPages,
      );

      return _parseResponse(response);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to fetch vendor goods receptions: $e');
    }
  }

  Map<String, dynamic> _prepareRequestBody(
    int page,
    int pageSize,
    String? statusFilter,
    String? verificationFilter,
    String? searchQuery,
  ) {
    final List<Map<String, dynamic>> filters = <Map<String, dynamic>>[];

    if (statusFilter != null && statusFilter.isNotEmpty) {
      filters.add(<String, dynamic>{
        'field': 'status',
        'operator': 'eq',
        'value': statusFilter,
      });
    }

    if (verificationFilter != null && verificationFilter.isNotEmpty) {
      filters.add(<String, dynamic>{
        'field': 'verification_status',
        'operator': 'eq',
        'value': verificationFilter,
      });
    }

    return <String, dynamic>{
      'header': <String, String>{'Authorization': 'Bearer mock_token'},
      'data': <String, Object>{
        'filter': filters,
        'pagination': <String, int>{'page': page, 'pageSize': pageSize},
        'search': searchQuery ?? '',
      },
      'options': <String, bool>{
        'showError': true,
        'rollbackOnFailure': true,
        'showInfo': true,
      },
    };
  }

  List<Map<String, dynamic>> _processData({
    String? filterByStatus,
    String? filterByVerification,
    String? searchQuery,
  }) {
    List<Map<String, dynamic>> processedData = List<Map<String, dynamic>>.from(
      _fullMockData,
    );

    if (filterByStatus != null && filterByStatus.isNotEmpty) {
      processedData =
          processedData
              .where(
                (Map<String, dynamic> item) => item['status'] == filterByStatus,
              )
              .toList();
    }

    if (filterByVerification != null && filterByVerification.isNotEmpty) {
      processedData =
          processedData
              .where(
                (Map<String, dynamic> item) =>
                    item['verification_status'] == filterByVerification,
              )
              .toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final String query = searchQuery.toLowerCase().trim();
      processedData =
          processedData
              .where(
                (Map<String, dynamic> item) =>
                    (item['code']?.toString().toLowerCase() ?? '').contains(
                      query,
                    ) ||
                    (item['vendor_name']?.toString().toLowerCase() ?? '')
                        .contains(query) ||
                    (item['po_number']?.toString().toLowerCase() ?? '')
                        .contains(query),
              )
              .toList();
    }

    return processedData;
  }

  Map<String, dynamic> _applyPagination(
    List<Map<String, dynamic>> data,
    int page,
    int pageSize,
  ) {
    final int totalItems = data.length;
    final int totalPages = (totalItems / pageSize).ceil();
    final int startIndex = (page - 1) * pageSize;
    final int endIndex = min(startIndex + pageSize, totalItems);

    List<Map<String, dynamic>> pagedData = <Map<String, dynamic>>[];
    if (startIndex < data.length) {
      pagedData = data.sublist(startIndex, endIndex);
    }

    return <String, dynamic>{
      'pagedData': pagedData,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }

  Response<dynamic> _createMockResponse(
    Map<String, dynamic> requestBody,
    List<Map<String, dynamic>> pagedData,
    int page,
    int pageSize,
    int totalItems,
    int totalPages,
  ) {
    final Map<String, dynamic> mockResponse = <String, dynamic>{
      'status': 'success',
      'message': 'Vendor goods receptions retrieved successfully',
      'data': <String, Object>{
        'items': pagedData,
        'pagination': <String, int>{
          'currentPage': page,
          'pageSize': pageSize,
          'totalItems': totalItems,
          'totalPages': totalPages,
        },
      },
    };

    return Response<Map<String, dynamic>>(
      data: mockResponse,
      statusCode: 200,
      requestOptions: RequestOptions(
        path: '/vendor-goods-receptions',
        data: requestBody,
      ),
    );
  }

  PaginationResponseModel<VendorGoodsReceptionModel> _parseResponse(
    Response<dynamic> response,
  ) {
    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final Map<String, dynamic> responseMap =
        response.data as Map<String, dynamic>;
    if (!responseMap.containsKey('data') ||
        responseMap['data'] is! Map<String, dynamic>) {
      throw Exception('Missing or invalid "data" field in response');
    }

    final Map<String, dynamic> dataMap =
        responseMap['data'] as Map<String, dynamic>;
    return PaginationResponseModel<VendorGoodsReceptionModel>.fromJson(
      dataMap,
      VendorGoodsReceptionModel.fromJson,
    );
  }

  @override
  Future<VendorGoodsReceptionModel?> getVendorGoodsReceptionById(
    String id,
  ) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final Map<String, dynamic>? found = _fullMockData
          .cast<Map<String, dynamic>?>()
          .firstWhere(
            (Map<String, dynamic>? item) => item?['id'] == id,
            orElse: () => null,
          );

      return found != null ? VendorGoodsReceptionModel.fromJson(found) : null;
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to fetch vendor goods reception by id: $e');
    }
  }

  @override
  Future<Response<dynamic>> updateVendorGoodsReceptionStatus({
    required String id,
    required String status,
    String? verificationStatus,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final int index = _fullMockData.indexWhere(
        (Map<String, dynamic> item) => item['id'] == id,
      );
      if (index == -1) {
        throw Exception('Vendor goods reception not found');
      }

      _fullMockData[index]['status'] = status;
      if (verificationStatus != null) {
        _fullMockData[index]['verification_status'] = verificationStatus;
      }

      return Response<Map<String, dynamic>>(
        data: <String, Object>{
          'status': 'success',
          'message': 'Vendor goods reception updated successfully',
          'data': _fullMockData[index],
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/vendor-goods-receptions/$id'),
      );
    } catch (e) {
      throw Exception('Failed to update vendor goods reception: $e');
    }
  }
}
