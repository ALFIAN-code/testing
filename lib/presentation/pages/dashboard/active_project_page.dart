import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/pagination_response_model.dart';
import '../../../data/models/project/project_pagination_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/dashboard/active_project/active_project_bloc.dart';
import '../../widgets/item_inspection/status_badge.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/card/basic_card.dart';
import '../../widgets/shared/chart/single_stacked_bar_chart.dart';
import '../../widgets/shared/icon/custom_icon.dart';
import '../../widgets/shared/paginated_list.dart';
import '../../widgets/state/base_ui_state.dart';
import 'dashboard_page.dart';

@RoutePage()
class ActiveProjectPage extends StatelessWidget {
  final PaginationResponseModel<ProjectPaginatedModel> lastProjectList;
  const ActiveProjectPage({super.key, required this.lastProjectList});

  @override
  Widget build(BuildContext context) => BlocProvider<ActiveProjectBloc>(
      create: (_) => ActiveProjectBloc(lastProjectList, serviceLocator.get())..initial(),
    child: const _ActiveProjectView(),
    );
}

class _ActiveProjectView extends StatefulWidget {
  const _ActiveProjectView({super.key});

  @override
  State<_ActiveProjectView> createState() => _ActiveProjectViewState();
}

class _ActiveProjectViewState extends BaseUiState<_ActiveProjectView> {
  @override
  Widget build(BuildContext context) => BasicScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ActiveProjectBloc, ActiveProjectState>(
          builder: (BuildContext context, ActiveProjectState state) {
            final String subtitleText = state.latestUpdate != null
                ? 'Terakhir diperbarui ${formatReadableDate(state.latestUpdate!)}'
                : 'Belum ada pembaruan';
  
            return BasicAppBar(
              title: 'Monitoring Proyek',
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
  
          Expanded(child: _buildContentSection(context),),
        ],
      ),
    ),
    );

  Widget _buildContentSection(BuildContext context) {
    final ActiveProjectBloc cubit = context.read<ActiveProjectBloc>();

    return PaginatedList<
        ProjectPaginatedModel,
        ActiveProjectBloc,
        ActiveProjectState
    >(
      cubit: cubit,
      getResponse: (ActiveProjectState s) => s.projectList,
      isInitialLoading: (ActiveProjectState s) => s.status.isInProgress,
      isLoadingMore: (ActiveProjectState s) => s.statusLoadMore == FormzSubmissionStatus.inProgress,
      isError: (ActiveProjectState s) => s.status.isFailure,
      errorMessage: (ActiveProjectState s) => s.errorMessage ?? 'Terjadi kesalahan',
      onLoadInitial: () => cubit.refresh(),
      onLoadMore: cubit.fetchMoreItems,
      itemBuilder: (BuildContext ctx, ProjectPaginatedModel item) => _buildItem(item),
      padding: const EdgeInsets.all(8),
    );
  }

  Widget _buildItem(ProjectPaginatedModel model) {
    final DateTime? lastDate = model.endDate;

    List<SingleStackedBarChartModel> chartData = [];
    int fewDay = 1;

    final int totalDay = model.startDate.difference(lastDate??DateTime.now()).inDays.abs();
    fewDay = DateTime.now().difference(lastDate??DateTime.now()).inDays.abs();
    chartData = <SingleStackedBarChartModel>[
      SingleStackedBarChartModel(units: (totalDay-fewDay).toDouble(), color: const Color(0xFF16c654)),
      SingleStackedBarChartModel(units: fewDay.toDouble(), color: const Color(0xFFf9295b)),
    ];

    return BasicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.name),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 10,
                  child: SingleStackedBarChart(data: chartData),
                ),
              ),
              const SizedBox(width: 10),
              Builder(
                  builder: (_) {
                    String label = '';
                    StatusType type = StatusType.success;

                    if (fewDay > 30) {
                      label = '${fewDay ~/ 30} Bulan Lagi';
                      type = StatusType.success;
                    } else if (fewDay > 7) {
                      label = '${fewDay ~/ 7} Minggu Lagi';
                      type = StatusType.success;
                    } else if (fewDay > 0) {
                      label = '$fewDay Hari Lagi';
                      type = StatusType.warning;
                    } else if (fewDay == 0) {
                      label = 'Hari Ini';
                      type = StatusType.warning;
                    }
                    else {
                      label = 'Selesai';
                      type = StatusType.success;
                    }
                    return StatusBadge(
                      label: label,
                      type: type,
                    );
                  })
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const CustomIcon(KeenIconConstants.userSquareDuoTone),
              const SizedBox(width: 8),
              Text(model.picName),
              const Spacer(),
              const CustomIcon(KeenIconConstants.home2DuoTone),
              const SizedBox(width: 8),
              Text(model.address),
            ],
          ),
        ],
      ),
    );
  }
}

