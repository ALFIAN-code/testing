import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../../data/models/project/project_pagination_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../../widgets/item_inspection/status_badge.dart';
import '../../../widgets/shared/card/basic_card.dart';
import '../../../widgets/shared/chart/single_stacked_bar_chart.dart';
import '../../../widgets/shared/icon/custom_icon.dart';
import '../../shared/button/basic_button.dart';

class ProjectMonitoringWidget extends StatelessWidget {
  ProjectMonitoringWidget({super.key});

  final List<SingleStackedBarChartModel> chartData =
      <SingleStackedBarChartModel>[
        SingleStackedBarChartModel(units: 90, color: const Color(0xFF16c654)),
        SingleStackedBarChartModel(units: 10, color: const Color(0xFFf9295b)),
      ];

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (DashboardState previous, DashboardState current) => previous.projectPaginatedModel != current.projectPaginatedModel,
        builder: (BuildContext context, DashboardState state) {
          final List<ProjectPaginatedModel>? projectPaginatedModel =
              state.projectPaginatedModel?.items;

          if (projectPaginatedModel == null) return Container();

          return RepaintBoundary(
            child: BasicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...projectPaginatedModel
                      .take(2)
                      .toList()
                      .asMap()
                      .entries
                      .map(
                        (entry) => _buildLineChart(entry.value, entry.key),
                      ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BasicButton(
                      variant: ButtonVariant.outlined,
                      onClick:
                          () => context.router.push(
                            ActiveProjectRoute(
                              lastProjectList: state.projectPaginatedModel!,
                            ),
                          ),
                      text: 'Lihat Semua ->',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _buildLineChart(ProjectPaginatedModel model, int index) {
    final DateTime? lastDate = model.endDate;

    List<SingleStackedBarChartModel> chartData = [];
    int fewDay = 1;

    final int totalDay =
        model.startDate.difference(lastDate ?? DateTime.now()).inDays.abs();
    fewDay = DateTime.now().difference(lastDate ?? DateTime.now()).inDays.abs();
    chartData = <SingleStackedBarChartModel>[
      SingleStackedBarChartModel(
        units: (totalDay - fewDay).toDouble(),
        color: const Color(0xFF16c654),
      ),
      SingleStackedBarChartModel(
        units: fewDay.toDouble(),
        color: const Color(0xFFf9295b),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        index != 0
            ? const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Divider(color: Color(0xFFDBDFE9)),
            )
            : Container(),
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
                } else {
                  label = 'Selesai';
                  type = StatusType.success;
                }
                return StatusBadge(label: label, type: type);
              },
            ),
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
    );
  }
}
