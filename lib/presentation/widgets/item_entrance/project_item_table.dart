import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/formz.dart';
import '../../../data/models/item_preparation/item_preparation_summary_model.dart';
import '../../bloc/item_entrance/detail_item_entrance/detail_item_entrance_bloc.dart';
import '../reception/vendor_goods_reception_detail/action_button_row_widget.dart';
import '../shared/table/generic_data_table_widget.dart';
import '../shared/view/error_retry_view.dart';
import 'test_result_dialog.dart';

class ProjectItemTable extends StatelessWidget {
  const ProjectItemTable({super.key});


  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
        builder: (BuildContext context, DetailItemEntranceState state) {

          if (state.status.isFailure) {
            return ErrorRetryView(
                errorMessage: state.errorMessage,
                onRetry: () => context.read<DetailItemEntranceBloc>().load()
            );
          }


          const Map<String, String> columnToFieldMap = <String, String>{
            'id': 'id',
            'code': 'code',
            'status': 'usedQuantity',
          };

          return GenericDataTable<ItemPreparationSummaryModel>(
            isLoading: state.status.isInProgress,
            headerWidget: ActionButtonRow(
              onRefresh: () => context.read<DetailItemEntranceBloc>().load(),
              onSearch: (String value) => context.read<DetailItemEntranceBloc>().setSearch(value),
            ),
            columns: const <TableColumn>[
              TableColumn(id: 'id', label: 'No.'),
              TableColumn(id: 'code', label: 'Kode Barang', sortable: true),
              TableColumn(id: 'status', label: 'Status'),
            ],
            data: state.items,
            onSort: (String columnId, bool ascending) async {
              final String? fieldName = columnToFieldMap[columnId];
              if (fieldName != null) {
                //await onSortRequested(fieldName, ascending);
              }
            },
            getRow: (ItemPreparationSummaryModel item, int index) => <DataCell>[
              DataCell(Text('${index + 1}')),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      item.itemCodeCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      item.itemCodeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(_buildStatusBadge(context,
                  item, item.scannedCount.toInt(), item.approvedCount.toInt(),),),
            ],
            rowsPerPage: state.items.length,
            currentPage: 0,
            totalItems: state.items.length,
            onPageChange: (page) => {},
            onRowsPerPageChanged: (size) => {},
            sortAscending: false,
            availableRowsPerPage: [state.items.length],
          );
        }
    );

  Widget _buildStatusBadge(BuildContext context, ItemPreparationSummaryModel model,int used, int total) {
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
      onTap: () => showDialog<void>(context: context, builder: (BuildContext ctx) => BlocProvider<DetailItemEntranceBloc>.value(
        value: context.read<DetailItemEntranceBloc>()..loadDetail(model.itemCodeId),
          child: TestResultDialog(model: model,)
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: textColor.withValues(alpha: 0.3)),
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