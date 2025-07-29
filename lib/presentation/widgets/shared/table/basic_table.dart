import 'package:flutter/material.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../../../../data/models/base_list_request_model.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../button/basic_button.dart';
import '../input/search_input.dart';
import 'generic_data_table_widget.dart';

typedef FetchPage<T> = Future<PaginationResponseModel<T>> Function(
    BaseListRequestModel request, {
    Map<String, dynamic>? extraParams,
    });

class PaginatedDataTableWrapper<T> extends StatefulWidget {
  final List<TableColumn> columns;
  final List<DataCell> Function(T, int) getRow;
  final FetchPage<T> fetchData;
  final List<int> availableRowsPerPage;
  final Widget? headerWidget;
  final Map<String, dynamic>? extraParams;

  const PaginatedDataTableWrapper({
    required this.columns,
    required this.getRow,
    required this.fetchData,
    this.availableRowsPerPage = const <int>[10, 25, 50],
    this.headerWidget,
    this.extraParams,
    super.key,
  });

  @override
  _PaginatedDataTableWrapperState<T> createState() =>
      _PaginatedDataTableWrapperState<T>();
}

class _PaginatedDataTableWrapperState<T>
    extends State<PaginatedDataTableWrapper<T>> {
  int _currentPage = 1;
  int _rowsPerPage;
  String _search = '';
  String? _sortColumnId;
  bool _sortAsc = true;
  List<SortRequestModel> _sort = <SortRequestModel>[];
  List<FilterRequestModel> _filters = <FilterRequestModel>[];

  List<T> _data = <T>[];
  int _totalItems = 0;
  bool _isLoading = false;

  _PaginatedDataTableWrapperState() : _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = widget.availableRowsPerPage.first;
    _loadPage();
  }

  Future<void> _loadPage() async {
    setState(() => _isLoading = true);
    final BaseListRequestModel request = BaseListRequestModel(
      pagination: PaginationRequestModel(
        page: _currentPage,
        pageSize: _rowsPerPage,
      ),
      search: _search,
      sort: _sort,
      filters: _filters,
    );
    try {
      final PaginationResponseModel<T> resp = await widget.fetchData(
        request,
        extraParams: widget.extraParams,
      );
      setState(() {
        _data = resp.items;
        _totalItems = resp.pagination.totalItems;
      });
    }
    catch(e) {
      rethrow;
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  void _onPageChange(int newPage) {
    _currentPage = newPage;
    _loadPage();
  }

  void _onRowsPerPageChanged(int newSize) {
    setState(() {
      _rowsPerPage = newSize;
      _currentPage = 1; // Reset to first page
    });
    _loadPage();
  }

  void _onSort(String columnId, bool ascending) {
    setState(() {
      _sortColumnId = columnId;
      _sortAsc = ascending;
      _sort = <SortRequestModel>[
        SortRequestModel(field: columnId, direction: ascending ? 'asc' : 'desc'),
      ];
      _currentPage = 1; // Reset to first page
    });
    _loadPage();
  }

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: SearchInput(
            onChanged: (String? v) {
              setState(() {
                _search = v ?? '';
                _currentPage = 1; // Reset to first page
              });
              _loadPage();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: BasicButton(
            text: 'Refresh',
            height: 48,
            icon: KeenIconConstants.arrowCircleOutline,
            variant: ButtonVariant.outlined,
            onClick: () => _loadPage(),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (widget.headerWidget != null) widget.headerWidget!,
      _buildSearch(),
      if (_isLoading)
        const Center(child: CircularProgressIndicator())
      else
        GenericDataTable<T>(
          data: _data,
          columns: widget.columns,
          getRow: widget.getRow,
          rowsPerPage: _rowsPerPage,
          totalItems: _totalItems,
          currentPage: _currentPage-1,
          sortColumnId: _sortColumnId,
          sortAscending: _sortAsc,
          onPageChange: _onPageChange,
          onRowsPerPageChanged: _onRowsPerPageChanged,
          onSort: _onSort,
          availableRowsPerPage: widget.availableRowsPerPage,
        ),
    ],
  );
}