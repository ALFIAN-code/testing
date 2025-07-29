import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/project/project_item_request_summary_pagination_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item_return/list_item_return/list_item_return_bloc.dart';
import '../../bloc/preparation/list_preparation/list_preparation_bloc.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/shared/paginated_list.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class ListItemReturnPage extends StatelessWidget {
  const ListItemReturnPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ListItemReturnBloc>(
    create: (_) => ListItemReturnBloc(serviceLocator.get())..initial(),
    child: const _ListItemReturnView(),
  );
}

class _ListItemReturnView extends StatefulWidget {
  const _ListItemReturnView({super.key});

  @override
  State<_ListItemReturnView> createState() => _ListItemReturnViewState();
}

class _ListItemReturnViewState extends BaseUiState<_ListItemReturnView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<ListItemReturnBloc, ListItemReturnState>(
        builder: (BuildContext context, ListItemReturnState state) {
          final String subtitleText = state.latestUpdate != null
              ? 'Terakhir diperbarui ${formatReadableDate(state.latestUpdate!)}'
              : 'Belum ada pembaruan';

          return BasicAppBar(
            title: 'Pegembalian Barang Proyek',
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
                  onChanged: (String? value) => context.read<ListItemReturnBloc>().setSearch(value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BasicButton(
                  text: 'Refresh',
                  height: 48,
                  icon: KeenIconConstants.arrowCircleOutline,
                  variant: ButtonVariant.outlined,
                  onClick: () => context.read<ListItemReturnBloc>().refresh(),
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
    final ListItemReturnBloc cubit = context.read<ListItemReturnBloc>();

    return PaginatedList<
        ProjectItemRequestSummaryPaginatedModel,
        ListItemReturnBloc,
        ListItemReturnState
    >(
      cubit: cubit,
      getResponse: (ListItemReturnState s) => s.projectList,
      isInitialLoading: (ListItemReturnState s) => s.status.isInProgress,
      isLoadingMore: (ListItemReturnState s) => s.statusLoadMore == FormzSubmissionStatus.inProgress,
      isError: (ListItemReturnState s) => s.status.isFailure,
      errorMessage: (ListItemReturnState s) => s.errorMessage ?? 'Terjadi kesalahan',
      onLoadInitial: () => cubit.initial(),
      onLoadMore: cubit.fetchMoreItems,
      itemBuilder: (BuildContext ctx, ProjectItemRequestSummaryPaginatedModel item) => ProjectCardItem(
        project: item,
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
            width: 160,
            child: BasicButton(
              text: 'Terima Barang',
              onClick: onPrepare ?? () {},
              icon: KeenIconConstants.tabletDownOutline,
            ),
          ),
        ),
      ],
    ),
  );
}
