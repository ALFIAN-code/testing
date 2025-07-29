import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class GenericDataTable<T> extends StatelessWidget {
  const GenericDataTable({
    required this.data,
    required this.columns,
    required this.getRow,
    required this.rowsPerPage,
    required this.totalItems,
    required this.onPageChange,
    required this.onRowsPerPageChanged,
    required this.availableRowsPerPage,
    this.onSort,
    this.sortColumnId,
    this.sortAscending = true,
    this.currentPage = 1,
    this.headerWidget,
    this.isLoading,
    super.key,
  });

  final List<T> data;
  final List<TableColumn> columns;
  final List<DataCell> Function(T item, int index) getRow;
  final int rowsPerPage;
  final int totalItems;
  final void Function(int) onPageChange;
  final void Function(int) onRowsPerPageChanged;
  final List<int> availableRowsPerPage;
  final void Function(String columnId, bool ascending)? onSort;
  final String? sortColumnId;
  final bool sortAscending;
  final int currentPage;
  final Widget? headerWidget;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final int actualTotalItems = totalItems;
    final int totalPages = rowsPerPage == 0 ? rowsPerPage :(actualTotalItems / rowsPerPage).ceil();

    final List<T> paginatedData = _calculatePaginatedData(
      data,
      currentPage,
      rowsPerPage,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: <Widget>[
              if (headerWidget != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: headerWidget!,
                ),

              if (isLoading == null || isLoading == false)
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: _buildColumns(context),
                  rows: _buildRows(paginatedData),
                  headingRowColor: WidgetStateProperty.all(
                    regiJayaPrimaryContainerBackground,
                  ),
                  dividerThickness: 0.25,
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 100,
                  border: const TableBorder(
                    horizontalInside: BorderSide(color: regiJayaPrimaryBorder),
                    verticalInside: BorderSide(color: regiJayaPrimaryBorder),
                  ),
                ),
              ),

              if (isLoading != null && isLoading == true)
                const Center(child: CircularProgressIndicator(),),

              if (actualTotalItems > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border(
                      top: BorderSide(color: regiJayaPrimaryBorder),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder:
                        (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Show',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildPageSizeDropdown(context),
                                    const SizedBox(width: 8),
                                    Text(
                                      'per page',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildPaginationInfo(
                                  paginatedData.length,
                                  actualTotalItems,
                                ),
                                _buildPaginationControls(context, totalPages),
                              ],
                            ),
                          ],
                        ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<T> _calculatePaginatedData(List<T> allData, int page, int pageSize) {
    if (allData.isEmpty) {
      return <T>[];
    }

    int startIndex = page * pageSize;
    if (startIndex >= allData.length) {
      startIndex = 0;
    }

    final int endIndex =
        (startIndex + pageSize) > allData.length
            ? allData.length
            : (startIndex + pageSize);

    return allData.sublist(startIndex, endIndex);
  }

  List<DataColumn> _buildColumns(BuildContext context) =>
      columns.map((TableColumn column) {
        final bool isCurrentSortColumn = sortColumnId == column.id;

        return DataColumn(
          label: InkWell(
            onTap:
                column.sortable && onSort != null
                    ? () => onSort!(
                      column.id,
                      !isCurrentSortColumn || !sortAscending,
                    )
                    : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      column.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            isCurrentSortColumn
                                ? Colors.blue.shade800
                                : Colors.grey.shade700,
                      ),
                    ),
                    if (column.sortable) ...<Widget>[
                      const SizedBox(width: 4),
                      if (isCurrentSortColumn)
                        Icon(
                          sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 16,
                          color: Colors.blue.shade800,
                        )
                      else
                        Icon(
                          Icons.unfold_more,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          numeric: column.numeric,
          tooltip: column.tooltip,
        );
      }).toList();

  List<DataRow> _buildRows(List<T> paginatedItems) =>
      List<DataRow>.generate(paginatedItems.length, (int index) {
        final T item = paginatedItems[index];
        final int globalIndex = currentPage * rowsPerPage + index;

        final List<DataCell> cells = getRow(item, globalIndex);

        return DataRow(cells: cells);
      });

  Widget _buildPageSizeDropdown(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(4),
      color: Colors.white,
    ),
    child: DropdownButton<int>(
      value: rowsPerPage,
      icon: Icon(
        Icons.keyboard_arrow_down,
        size: 16,
        color: Colors.grey.shade700,
      ),
      underline: const SizedBox(),
      isDense: true,
      style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
      items:
          availableRowsPerPage
              .map(
                (int value) =>
                    DropdownMenuItem<int>(value: value, child: Text('$value')),
              )
              .toList(),
      onChanged: (int? value) {
        if (value != null) {
          onRowsPerPageChanged(value);
        }
      },
    ),
  );

  Widget _buildPaginationInfo(int itemsOnPage, int totalItems) => Text(
    '${currentPage * rowsPerPage + 1}-${currentPage * rowsPerPage + itemsOnPage} of $totalItems',
    style: TextStyle(
      color: Colors.grey.shade700,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildPaginationControls(BuildContext context, int totalPages) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          icon: const Icon(Icons.chevron_left, size: 18),
          padding: EdgeInsets.zero,
          color: currentPage > 0 ? Colors.grey.shade700 : Colors.grey.shade400,
          onPressed:
              currentPage > 0 ? () => onPageChange(currentPage - 1) : null,
        ),
      ),
      const SizedBox(width: 4),
      _buildPageNumber(context, '$currentPage'),
      const SizedBox(width: 4),
      SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          icon: const Icon(Icons.chevron_right, size: 18),
          padding: EdgeInsets.zero,
          color:
              currentPage < totalPages - 1
                  ? Colors.grey.shade700
                  : Colors.grey.shade400,
          onPressed:
              currentPage < totalPages - 1
                  ? () => onPageChange(currentPage + 1)
                  : null,
        ),
      ),
    ],
  );

  Widget _buildPageNumber(BuildContext context, String number) => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: regiJayaSecondaryContainerBackground,
      borderRadius: BorderRadius.circular(6),
    ),
    alignment: Alignment.center,
    child: Text(
      number,
      style: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
  );
}

class TableColumn {
  const TableColumn({
    required this.id,
    required this.label,
    this.sortable = false,
    this.numeric = false,
    this.tooltip,
  });

  final String id;
  final String label;
  final bool sortable;
  final bool numeric;
  final String? tooltip;
}
