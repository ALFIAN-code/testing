import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/app/app_status.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/models/item_vendor_reception/item_vendor_reception_paginated_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/reception/vendor_goods_reception/vendor_goods_reception_bloc.dart';
import '../../widgets/filter/filter_widget.dart';
import '../../widgets/reception/vendor_goods_reception/vendor_goods_reception_card_widget.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/input/search_input.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/shared/paginated_list.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class VendorGoodsReceptionPage extends StatelessWidget {
  const VendorGoodsReceptionPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<VendorGoodsReceptionBloc>(
      create: (_) => VendorGoodsReceptionBloc(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ),
      child: const VendorGoodsReceptionView(),
    );
}

class VendorGoodsReceptionView extends StatelessWidget {
  const VendorGoodsReceptionView({super.key});

  String? _buildLatestUpdateText(BuildContext context) {
    final DateTime? dateTime = context.watch<VendorGoodsReceptionBloc>().state.latestUpdate;
    if (dateTime != null) {
      return 'Terakhir diperbarui ${formatReadableDate(dateTime)}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => BasicScaffold(
      appBar: BasicAppBar(
        showBackButton: true,
        icon: KeenIconConstants.officeBagOutline,
        title: 'Penerimaan Barang Vendor',
        subtitle: _buildLatestUpdateText(context),
      ),
      body: Column(
        children: [
          _buildTopSection(context),
          _buildFilterSection(),
          Expanded(child: _buildContentSection(context)),
        ],
      ),
    );

  Widget _buildTopSection(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, bottom:10,left: 16,right: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SearchInput(
              onChanged: (String? text) => context.read<VendorGoodsReceptionBloc>().setSearch(text),
              onSubmitted: (_) {

              },
            )
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BasicButton(
              text: 'Refresh',
              height: 48,
              icon: KeenIconConstants.arrowCircleOutline,
              variant: ButtonVariant.outlined,
              onClick: () => context.read<VendorGoodsReceptionBloc>().initial(),
            ),
          ),
        ],
      ),
    );

  Widget _buildFilterSection() => BlocBuilder<VendorGoodsReceptionBloc, VendorGoodsReceptionState>(
    builder: (BuildContext context, VendorGoodsReceptionState state) {
      if (state.status != AppStatus.success) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: BaseListFilterWidget(
          requestModel: state.listRequestModel!,
          fields: [
            FilterField(
              field: 'itemVendorStatusId',
              label: 'Status',
              options: [
                const DropdownOption(value: '', label: 'Semua'),
                ...state.listItemStatus.map((e) => DropdownOption(value: e.id, label: e.name)),
              ],
            ),
            FilterField(
              field: 'itemVendorConditionId',
              label: 'Kondisi',
              options: [
                const DropdownOption(value: '', label: 'Semua'),
                ...state.listItemCondition.map((e) => DropdownOption(value: e.id, label: e.name)),
              ],
            ),
          ],
          onRequestChanged: (newRequest) {
            context.read<VendorGoodsReceptionBloc>().load(newRequest);
          },
        ),
      );
    },
  );

  Widget _buildContentSection(BuildContext context) {
    final cubit = context.read<VendorGoodsReceptionBloc>();

    return PaginatedList<
        ItemVendorReceptionPaginatedModel,
    VendorGoodsReceptionBloc,
    VendorGoodsReceptionState
    >(
    cubit: cubit,
    getResponse: (s) => s.listItemReception,
      isInitialLoading: (s) => s.status == AppStatus.loading,
      isLoadingMore: (s) => s.statusLoadMore == AppStatus.loading,
    isError: (VendorGoodsReceptionState s) => s.status == AppStatus.failure,
    errorMessage: (VendorGoodsReceptionState s) => s.errorMessage ?? 'Terjadi kesalahan',
    onLoadInitial: () => cubit.initial(),
    onLoadMore: cubit.fetchMoreReceptions,
    itemBuilder: (BuildContext ctx, ItemVendorReceptionPaginatedModel item) => VendorGoodsReceptionCard(
      reception: item,
      onDetailTap: () => context.router.push(VendorGoodsReceptionDetailRoute(receptionId: item.id)),
      onCheckTap: () => context.router.push(GoodsChecklistFormRoute(receptionId: item.id))
          .then((_) => context.read<VendorGoodsReceptionBloc>().initial()),
    ),
    padding: const EdgeInsets.all(16),
    );
  }
}
