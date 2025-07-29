import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/on_project_item/scanned_item_list_model.dart';
import '../../bloc/prepare_return_item/detail_prepare_return_item/detail_prepare_return_item_bloc.dart';
import '../reception/vendor_goods_reception_detail/action_button_row_widget.dart';
import '../shared/button/metronic_button.dart';
import '../shared/dialog/confirm_dialog.dart';
import '../shared/table/generic_data_table_widget.dart';
import '../shared/view/error_retry_view.dart';
import '../state/base_ui_state.dart';

class ScannedItemTable extends StatefulWidget {
  const ScannedItemTable({super.key});

  @override
  State<ScannedItemTable> createState() => _ScannedItemTableState();
}

class _ScannedItemTableState extends BaseUiState<ScannedItemTable> {
  @override
  Widget build(BuildContext context) => BlocListener<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
    listenWhen: (DetailPrepareReturnItemState previous, DetailPrepareReturnItemState current) => previous.deleteStatus != current.deleteStatus,
    listener: (BuildContext context, DetailPrepareReturnItemState state) {
      if (state.deleteStatus.isInProgress) {
        showLoading();
      } else if (state.deleteStatus.isSuccess) {
        hideLoading();
        showSuccessMessage('Berhasil Menghapus');
      } else if (state.deleteStatus.isFailure) {
        hideLoading();
        showErrorMessage(state.errorMessage ?? 'Gagal Menghapus');
      }
    },
    child: BlocBuilder<DetailPrepareReturnItemBloc, DetailPrepareReturnItemState>(
          builder: (BuildContext context, DetailPrepareReturnItemState state) {

            final bool isScanned = state.listRequestModel?.isScanned ?? true;

            if (state.status.isFailure) {
              return ErrorRetryView(
                  errorMessage: state.errorMessage,
                  onRetry: () => context.read<DetailPrepareReturnItemBloc>().load()
              );
            }

            const Map<String, String> columnToFieldMap = <String, String>{
              'id': 'id',
              'code': 'code',
            };

            return GenericDataTable<ScannedItemListModel>(
              isLoading: state.status.isInProgress,
              headerWidget: ActionButtonRow(
                onRefresh: () => context.read<DetailPrepareReturnItemBloc>().load(),
                onSearch: (String value) => context.read<DetailPrepareReturnItemBloc>().setSearch(value),
              ),
              columns: <TableColumn>[
                const TableColumn(id: 'id', label: 'No.'),
                const TableColumn(id: 'code', label: 'Kode Barang', sortable: true),
                if (isScanned)
                  const TableColumn(id: 'action', label: 'Aksi', sortable: false)
              ],
              data: state.listScanned,
              onSort: (String columnId, bool ascending) async {
                final String? fieldName = columnToFieldMap[columnId];
                if (fieldName != null) {
                  //await onSortRequested(fieldName, ascending);
                }
              },
              getRow: (ScannedItemListModel item, int index) => <DataCell>[
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
                if (isScanned)
                  DataCell(
                      Center(
                        child: SizedBox(
                          width: 48,
                          child: MetronicButton(
                          color: Colors.red,
                          icon: KeenIconConstants.trashOutline,
                          onPressed: () => showDialog<void>(
                              context: context,
                              builder: (BuildContext ctx) => ConfirmDialog(
                                title: 'Hapus Scan',
                                content: 'Apakah anda yakin ingin menghapus scan ini?',
                                onConfirm: () {
                                  context.read<DetailPrepareReturnItemBloc>().deleteScan(item.itemRequestItemScanId);
                                  Navigator.of(ctx).pop();
                                }, onCancel: () => Navigator.of(ctx).pop(),
                              )
                          ),
                          ),
                        ),
                      ),
                    ),
              ],
              rowsPerPage: state.listScanned.length,
              currentPage: 0,
              totalItems: state.listScanned.length,
              onPageChange: (page) => {},
              onRowsPerPageChanged: (size) => {},
              sortAscending: false,
              availableRowsPerPage: [state.listScanned.length],
            );
          }
      ),
  );
}