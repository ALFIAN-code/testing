import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pagination_response_model.dart';

class PaginatedList<T, C extends Cubit<S>, S> extends StatefulWidget {
  final C cubit;
  final PaginationResponseModel<T>? Function(S) getResponse;
  final bool Function(S) isInitialLoading;
  final bool Function(S) isLoadingMore;
  final bool Function(S) isError;
  final String Function(S) errorMessage;
  final VoidCallback onLoadInitial;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const PaginatedList({
    super.key,
    required this.cubit,
    required this.getResponse,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.isError,
    required this.errorMessage,
    required this.onLoadInitial,
    required this.onLoadMore,
    required this.itemBuilder,
    this.padding,
  });

  @override
  _PaginatedListState<T, C, S> createState() => _PaginatedListState<T, C, S>();
}

class _PaginatedListState<T, C extends Cubit<S>, S>
    extends State<PaginatedList<T, C, S>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.onLoadInitial();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final S state = widget.cubit.state;
      final PaginationResponseModel<T>? resp = widget.getResponse(state);
      if (resp != null && !widget.isLoadingMore(state) && !widget.isError(state)) {
        final int current = resp.pagination.currentPage;
        final int total = resp.pagination.totalPages;
        if (current < total) widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<C, S>(
      bloc: widget.cubit,
      builder: (BuildContext context, state) {
        if (widget.isError(state)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.errorMessage(state)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: widget.onLoadInitial,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final PaginationResponseModel<T>? resp = widget.getResponse(state);
        final List<T> items = resp?.items ?? <T>[];

        if (widget.isInitialLoading(state)) {
          return const Center(child: CircularProgressIndicator());
        } else if (items.isEmpty)  {
          return const Center(child: Text('Tidak ada data'));
        }

        final int currentPage = resp?.pagination.currentPage ?? 0;
        final int totalPages = resp?.pagination.totalPages ?? 0;
        final bool reachedMax = currentPage >= totalPages;

        return RefreshIndicator(
          onRefresh: () async {
            widget.onLoadInitial();
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: widget.padding,
            itemCount: reachedMax ? items.length : items.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index >= items.length) {
                // Load more spinner
                return widget.isLoadingMore(state)
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const SizedBox.shrink();
              }
              return widget.itemBuilder(context, items[index]);
            },
          ),
        );
      },
    );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
