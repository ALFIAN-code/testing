import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/item_request_item_scan/item_request_item_scan_paginated_model.dart';
import '../../../bloc/preparation/detail_preparation/detail_preparation_bloc.dart';
import '../../reception/vendor_goods_reception_detail/action_button_row_widget.dart';
import '../../shared/table/generic_data_table_widget.dart';
import 'test_result_dialog.dart';

class ItemStatusTable extends StatelessWidget {
  const ItemStatusTable({super.key});


  @override
  Widget build(BuildContext context) => BlocBuilder<DetailPreparationBloc, DetailPreparationState>(
        builder: (BuildContext context, DetailPreparationState state) {
          const Map<String, String> columnToFieldMap = <String, String>{
            'id': 'id',
            'code': 'code',
            'status': 'usedQuantity',
          };

          return GenericDataTable<ItemRequestItemScanPaginatedModel>(
            headerWidget: ActionButtonRow(
              onRefresh: () => {},
              onSearch: (_) => {},
            ),
            columns: const <TableColumn>[
              TableColumn(id: 'id', label: 'No.'),
              TableColumn(id: 'code', label: 'Kode Barang', sortable: true),
              TableColumn(id: 'status', label: 'Status'),
            ],
            data: state.listItems?.items ?? [],
            onSort: (String columnId, bool ascending) async {
              final String? fieldName = columnToFieldMap[columnId];
              if (fieldName != null) {
                //await onSortRequested(fieldName, ascending);
              }
            },
            getRow: (ItemRequestItemScanPaginatedModel item, int index) => <DataCell>[
              DataCell(Text('${index + 1}')),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      item.item?.barcode ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(_buildStatusBadge(context,
                  item.id,item.itemRequestItem?.approvedCount ?? 0, item.itemRequestItem?.preparedCount?.toInt() ?? 0)),
            ],
            rowsPerPage: 3,
            currentPage: 1,
            totalItems: 3,
            onPageChange: (page) => {},
            onRowsPerPageChanged: (size) => {},
            sortAscending: false,
            availableRowsPerPage: [3],
          );
        }
    );

  Widget _buildStatusBadge(BuildContext context, String id, int used, int total) {
    Color bgColor;
    Color textColor;

    if (used == 0) {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade600;
    } else if (used < total) {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
    } else {
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
    }

    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (BuildContext ctx) => BlocProvider.value(
        value: context.read<DetailPreparationBloc>(),
          child: TestResultDialog(id: id,)
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Text(
          '$used/$total',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}