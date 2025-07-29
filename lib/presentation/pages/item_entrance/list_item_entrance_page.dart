import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/project/project_item_request_summary_pagination_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item_entrance/list_item_entrance/list_item_entrance_bloc.dart';
import '../../bloc/item_return/list_item_return/list_item_return_bloc.dart';
import '../../bloc/preparation/list_preparation/list_preparation_bloc.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/shared/paginated_list.dart';
import '../../widgets/state/base_ui_state.dart';
import '../dashboard/dashboard_page.dart';

@RoutePage()
class ListItemEntrancePage extends StatelessWidget {
  const ListItemEntrancePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ListItemEntranceBloc>(
    create: (_) => ListItemEntranceBloc(serviceLocator.get())..initial(),
    child: const _ListItemEntranceView(),
  );
}

class _ListItemEntranceView extends StatefulWidget {
  const _ListItemEntranceView({super.key});

  @override
  State<_ListItemEntranceView> createState() => _ListItemEntranceViewState();
}

class _ListItemEntranceViewState extends BaseUiState<_ListItemEntranceView> {
  @override
  Widget build(BuildContext context) => BasicScaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<ListItemEntranceBloc, ListItemEntranceState>(
        builder: (BuildContext context, ListItemEntranceState state) {
          final String subtitleText = state.latestUpdate != null
              ? 'Terakhir diperbarui ${formatReadableDate(state.latestUpdate!)}'
              : 'Belum ada pembaruan';
  
          return BasicAppBar(
            title: 'Persiapan Barang Proyek',
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
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextInput(
                  prefixIcon: KeenIconConstants.magnifierDuoTone,
                  hintText: 'Cari',
                  onChanged: (String? value) => context.read<ListItemEntranceBloc>().setSearch(value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicButton(
                  text: 'Refresh',
                  height: 48,
                  icon: KeenIconConstants.arrowCircleOutline,
                  variant: ButtonVariant.outlined,
                  onClick: () => context.read<ListItemEntranceBloc>().refresh(),
                ),
              ),
            ],
          ),
          Expanded(child: _buildContentSection(context),),
        ],
      ),
    ),
  );

  Widget _buildContentSection(BuildContext context) {
    final ListItemEntranceBloc cubit = context.read<ListItemEntranceBloc>();

    return PaginatedList<
        ProjectItemRequestSummaryPaginatedModel,
        ListItemEntranceBloc,
        ListItemEntranceState
    >(
      cubit: cubit,
      getResponse: (ListItemEntranceState s) => s.projectList,
      isInitialLoading: (ListItemEntranceState s) => s.status.isInProgress,
      isLoadingMore: (ListItemEntranceState s) => s.statusLoadMore == FormzSubmissionStatus.inProgress,
      isError: (ListItemEntranceState s) => s.status.isFailure,
      errorMessage: (ListItemEntranceState s) => s.errorMessage ?? 'Terjadi kesalahan',
      onLoadInitial: () => cubit.initial(),
      onLoadMore: cubit.fetchMoreItems,
      itemBuilder: (BuildContext ctx, ProjectItemRequestSummaryPaginatedModel item) => ProjectCardItem(
        project: item,
        onPrepare: () => context.router.push(DetailItemEntranceRoute(project: item)),
      ),
      padding: const EdgeInsets.all(8),
    );
  }
}


class ProjectCardItem extends StatelessWidget {
  final ProjectItemRequestSummaryPaginatedModel project;
  final VoidCallback? onPrepare;

  const ProjectCardItem({super.key, required this.project, this.onPrepare});

  @override
  Widget build(BuildContext context) => BasicCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          project.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Text(project.code, style: TextStyle(color: Colors.grey.shade600)),
            const Text('  |  '),
            Text(
              '${project.itemRequestCount} Permintaan',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            '${project.itemRequestItemApprovedCount.toInt()} Barang',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            width: 130,
            child: BasicButton(
              text: 'Siapkan',
              onClick: onPrepare ?? () {},
              icon: KeenIconConstants.tabletDownOutline,
            ),
          ),
        ),
      ],
    ),
  );
}
