import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/dashboard/item_vendor_arrival_model.dart';
import '../../../data/models/pagination_response_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/dashboard/item_vendor_arrival/item_vendor_arrival_bloc.dart';
import '../../widgets/dashboard/items/item_vendor_arrival_card.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/paginated_list.dart';
import '../../widgets/state/base_ui_state.dart';
import 'dashboard_page.dart';

@RoutePage()
class ItemVendorArrivalPage extends StatelessWidget {
  final PaginationResponseModel<ItemVendorArrivalModel> list;
  const ItemVendorArrivalPage({super.key, required this.list});

  @override
  Widget build(BuildContext context) => BlocProvider<ItemVendorArrivalBloc>(
        create: (_) => ItemVendorArrivalBloc(list, serviceLocator.get()),
    child: const _ItemVendorArrivalView(),
  );
}

class _ItemVendorArrivalView extends StatefulWidget {
  const _ItemVendorArrivalView({super.key});

  @override
  State<_ItemVendorArrivalView> createState() => _ItemVendorArrivalViewState();
}

class _ItemVendorArrivalViewState extends BaseUiState<_ItemVendorArrivalView> {
  @override
  Widget build(BuildContext context) => BasicScaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<ItemVendorArrivalBloc, ItemVendorArrivalState>(
        builder: (BuildContext context, ItemVendorArrivalState state) {
          final String subtitleText =
          state.latestUpdate != null
              ? 'Terakhir diperbarui ${formatReadableDate(state.latestUpdate!)}'
              : 'Belum ada pembaruan';

          return BasicAppBar(
            title: 'Monitoring Barang Vendor',
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
    final ItemVendorArrivalBloc cubit = context.read<ItemVendorArrivalBloc>();

    return PaginatedList<ItemVendorArrivalModel, ItemVendorArrivalBloc, ItemVendorArrivalState>(
      cubit: cubit,
      getResponse: (ItemVendorArrivalState s) => s.itemTestList,
      isInitialLoading: (ItemVendorArrivalState s) => s.status.isInProgress,
      isLoadingMore:
          (ItemVendorArrivalState s) =>
      s.statusLoadMore == FormzSubmissionStatus.inProgress,
      isError: (ItemVendorArrivalState s) => s.status.isFailure,
      errorMessage: (ItemVendorArrivalState s) => s.errorMessage ?? 'Terjadi kesalahan',
      onLoadInitial: () => cubit.refresh(),
      onLoadMore: cubit.fetchMoreItems,
      itemBuilder:
          (BuildContext ctx, ItemVendorArrivalModel item) => ItemVendorArrivalCard(model: item),
      padding: const EdgeInsets.all(8),
    );
  }

}