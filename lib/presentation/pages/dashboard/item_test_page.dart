import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/dashboard/item_test_pagination_model.dart';
import '../../../data/models/pagination_response_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/dashboard/item_test/item_test_bloc.dart';
import '../../widgets/dashboard/items/item_test_card_widget.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/paginated_list.dart';
import '../../widgets/state/base_ui_state.dart';
import 'dashboard_page.dart';

@RoutePage()
class ItemTestPage extends StatelessWidget {
  final PaginationResponseModel<ItemTestPaginationModel> lastProjectList;
  const ItemTestPage({super.key, required this.lastProjectList});

  @override
  Widget build(BuildContext context) => BlocProvider<ItemTestBloc>(
    create:
        (_) => ItemTestBloc(lastProjectList, serviceLocator.get())..initial(),
    child: const _ItemTestView(),
  );
}

class _ItemTestView extends StatefulWidget {
  const _ItemTestView({super.key});

  @override
  State<_ItemTestView> createState() => _ItemTestViewState();
}

class _ItemTestViewState extends BaseUiState<_ItemTestView> {
  @override
  Widget build(BuildContext context) => BasicScaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<ItemTestBloc, ItemTestState>(
        builder: (BuildContext context, ItemTestState state) {
          final String subtitleText =
              state.latestUpdate != null
                  ? 'Terakhir diperbarui ${formatReadableDate(state.latestUpdate!)}'
                  : 'Belum ada pembaruan';
  
          return BasicAppBar(
            title: 'Barang Perlu Uji Segera',
            icon: KeenIconConstants.tabletBookOutline,
            subtitle: subtitleText,
            showBackButton: true,
          );
        },
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
  
          Expanded(child: _buildContentSection(context)),
        ],
      ),
    ),
  );

  Widget _buildContentSection(BuildContext context) {
    final ItemTestBloc cubit = context.read<ItemTestBloc>();

    return PaginatedList<ItemTestPaginationModel, ItemTestBloc, ItemTestState>(
      cubit: cubit,
      getResponse: (ItemTestState s) => s.itemTestList,
      isInitialLoading: (ItemTestState s) => s.status.isInProgress,
      isLoadingMore:
          (ItemTestState s) =>
              s.statusLoadMore == FormzSubmissionStatus.inProgress,
      isError: (ItemTestState s) => s.status.isFailure,
      errorMessage: (ItemTestState s) => s.errorMessage ?? 'Terjadi kesalahan',
      onLoadInitial: () => cubit.refresh(),
      onLoadMore: cubit.fetchMoreItems,
      itemBuilder:
          (BuildContext ctx, ItemTestPaginationModel item) => _buildItem(item),
      padding: const EdgeInsets.all(8),
    );
  }

  Widget _buildItem(ItemTestPaginationModel item) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ItemTestCard(
        productCode: item.barcode,
        itemCode: item.itemCode.code,
        lastTestDate: item.lastTestedDate,
        inspections: item.itemInspections,
        daysAgo: item.nextTestDay,
      ),
    );

}

