import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../domain/entities/vendor_goods_entity.dart';
import '../../shared/table/generic_data_table_widget.dart';
import 'action_button_row_widget.dart';

class VendorGoodsTableWidget extends StatelessWidget {
  const VendorGoodsTableWidget({
    required this.vendorGoodsReceptions,
    required this.onSortRequested,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    required this.availableRowsPerPage,
    required this.onRefresh,
    required this.onSearch,
    required this.onViewPdf,
    this.sortField,
    this.sortAscending,
    super.key,
  });

  final List<VendorGoodsEntity> vendorGoodsReceptions;
  final Future<void> Function(String fieldName, bool ascending) onSortRequested;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final void Function(int) onPageChanged;
  final void Function(int) onPageSizeChanged;
  final List<int> availableRowsPerPage;
  final VoidCallback onRefresh;
  final void Function(String) onSearch;
  final VoidCallback onViewPdf;
  final String? sortField;
  final bool? sortAscending;

  @override
  Widget build(BuildContext context) {
    const Map<String, String> columnToFieldMap = <String, String>{
      'id': 'id',
      'code': 'code',
      'quantity': 'quantity',
    };

    String? sortColumnId;
    if (sortField != null) {
      for (MapEntry<String, String> entry in columnToFieldMap.entries) {
        if (entry.value == sortField) {
          sortColumnId = entry.key;
          break;
        }
      }
    }

    return GenericDataTable<VendorGoodsEntity>(
      headerWidget: ActionButtonRow(
        onRefresh: onRefresh,
        onSearch: onSearch,
        onViewPdf: onViewPdf,
      ),
      columns: const <TableColumn>[
        TableColumn(id: 'id', label: 'No.'),
        TableColumn(id: 'code', label: 'Kode Barang / Nama Barang\n/ Jenis Barang', sortable: true),
        TableColumn(id: 'quantity', label: 'Jumlah', sortable: true),
      ],
      data: vendorGoodsReceptions,
      onSort: (String columnId, bool ascending) async {
        final String? fieldName = columnToFieldMap[columnId];
        if (fieldName != null) {
          await onSortRequested(fieldName, ascending);
        }
      },
      getRow:
          (VendorGoodsEntity item, int index) => <DataCell>[
            DataCell(Text(item.id)),
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    item.code,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: regiJayaSecondaryText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    item.materialType,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: regiJayaSecondaryText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            DataCell(Text(item.quantity.toString())),
          ],
      rowsPerPage: pageSize,
      currentPage: currentPage,
      totalItems: totalItems,
      onPageChange: onPageChanged,
      onRowsPerPageChanged: onPageSizeChanged,
      sortColumnId: sortColumnId,
      sortAscending: sortAscending ?? true,
      availableRowsPerPage: availableRowsPerPage,
    );
  }
}
