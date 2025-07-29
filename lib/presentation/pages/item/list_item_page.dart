import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/app/app_status.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/base_list_request_model.dart';
import '../../../data/models/condition/condition_model.dart';
import '../../../data/models/condition/condition_paginated_model.dart';
import '../../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../../data/models/item/item_paginated_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item/list_item/list_item_bloc.dart';
import '../../widgets/filter/filter_widget.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/badge/custom_badge.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/input/search_input.dart';
import '../../widgets/shared/paginated_list.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class ListItemPage extends StatelessWidget {
  const ListItemPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ListItemBloc>(
        create: (_) => ListItemBloc(
          serviceLocator.get(),
          serviceLocator.get(),
          serviceLocator.get(),
        )..initial(),
    child: const _ListItemView(),
  );
}

class _ListItemView extends StatelessWidget {
  const _ListItemView({super.key});

  @override
  Widget build(BuildContext context) => BasicScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ListItemBloc, ListItemState>(
          builder: (BuildContext context, ListItemState state) => BasicAppBar(
              title: 'List Barang',
              icon: KeenIconConstants.tabletBookOutline,
              showBackButton: true,
            subtitle:state.latestUpdate == null ? null : 'Terakhir diperbarui ${formatReadableDate(state.latestUpdate)}',
            ),
        ),
      ),
      body:  Column(
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
              onChanged: (String? text) => context.read<ListItemBloc>().setSearch(text),
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
            onClick: () => context.read<ListItemBloc>().load(),
          ),
        ),
      ],
    ),
  );

  Widget _buildFilterSection() => BlocBuilder<ListItemBloc, ListItemState>(
    builder: (BuildContext context, ListItemState state) {
      final BaseListRequestModel? listRequestModel = state.listRequestModel;
      if (listRequestModel == null) return Container();

      final List<DropdownOption> conditionOptions = [];

      String selectedCategoryId = '';
      String selectedConditionId = '';

      for (final FilterRequestModel filter in listRequestModel.filters) {
        if (filter.field == 'condition.conditionCategoryId' && filter.value.isNotEmpty) {
          selectedCategoryId = filter.value;
          conditionOptions.addAll(
            state.listCondition
                .where((c) => c.conditionCategoryId == filter.value)
                .map((c) => DropdownOption(value: c.id.toString(), label: c.name)),
          );
        } else if (filter.field == 'condition.id') {
          selectedConditionId = filter.value;
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: FilterDropdown(
                label: '',
                value: selectedCategoryId,
                options: [
                  const DropdownOption(value: '', label: 'Semua'),
                  ...state.listConditionCategory.map(
                        (e) => DropdownOption(value: e.id, label: e.name),
                  ),
                ],
                onChanged: (String? val) => context.read<ListItemBloc>().setFilter('condition.conditionCategoryId', val ?? ''),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilterDropdown(
                label: '',
                value: selectedConditionId,
                enabled: conditionOptions.isNotEmpty,
                options: [
                  const DropdownOption(value: '', label: 'Semua'),
                  ...conditionOptions,
                ],
                onChanged: (String? val) => context.read<ListItemBloc>().setFilter('condition.id', val ?? ''),
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget _buildContentSection(BuildContext context) {
    final ListItemBloc cubit = context.read<ListItemBloc>();

    return PaginatedList<
        ItemPaginatedModel,
        ListItemBloc,
        ListItemState
    >(
      cubit: cubit,
      getResponse: (ListItemState s) => s.listItem,
      isInitialLoading: (ListItemState s) => s.status.isInProgress,
      isLoadingMore: (ListItemState s) => s.statusLoadMore == AppStatus.loading,
      isError: (ListItemState s) => s.status.isFailure,
      errorMessage: (ListItemState s) => s.errorMessage ?? 'Terjadi kesalahan',
      onLoadInitial: () => cubit.initial(),
      onLoadMore: cubit.fetchMoreItems,
      itemBuilder: (BuildContext ctx, ItemPaginatedModel item) => _ItemCard(
        item,
      ),
      padding: const EdgeInsets.all(16),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ItemPaginatedModel item;
  const _ItemCard(this.item);

  @override
  Widget build(BuildContext context) => BasicCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.itemCode?.name ?? '-', style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFDBDFE9)),
                  ),
                  child: Text(
                    '${item.quantity.ceil()} ${item.itemCode?.unit?.name ?? '-'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF78829D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4,),
            Text("${item.barcode ?? '-'} | ${item.model ?? '-'}"),
            const SizedBox(height: 8,),
            Text('Rak: ${item.rackCode ?? '-'}'),
            const SizedBox(height: 8,),
            Row(
              children: [
                _buildConditionBadge(item.condition),
                const Spacer(),
                const Icon(Icons.location_on, size: 18, color: Colors.grey,),
                const SizedBox(width: 3),
                Text(item.lastLocationName, style: const TextStyle(color: Colors.grey),) ,
              ],
            )
          ],
        )
    );
  
  Widget _buildConditionBadge(ConditionModel? condition) {

    if (condition == null) {
      return Container();
    }

    Color color = Colors.grey;

    switch (condition.code.substring(0, 1).toUpperCase()) {
      case 'D':
        color = const Color(0xFF17C653);
        break;
      case 'U':
        color = const Color(0xFFFF3B30);
        break;
      case 'T':
        color =  const Color(0xFFF6B100);
        break;
      default:
        color = Colors.blue;
        break;
    }
    return CustomBadge(label: '${condition.name} (${condition.code})', color: color);
  }
}
