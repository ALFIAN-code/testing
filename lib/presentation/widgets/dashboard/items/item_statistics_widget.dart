import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/item_statistic_condition_category_model.dart';
import '../../../../data/models/dashboard/item_statistic_model.dart';
import '../../../bloc/dashboard/dashboard_bloc.dart';
import '../../../widgets/shared/card/basic_card.dart';
import '../../../widgets/shared/chart/single_stacked_bar_chart.dart';
import '../../shared/badge/custom_badge.dart';

class ItemStatisticsWidget extends StatelessWidget {
  const ItemStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (DashboardState previous, DashboardState current) => previous.itemStatisticModel != current.itemStatisticModel,
        builder: (BuildContext context, DashboardState state) {
          final ItemStatisticModel? itemStatisticModel =
              state.itemStatisticModel;
          if (itemStatisticModel == null) return Container();

          final List<ItemStatisticConditionCategoryModel> filteredCategories =
              itemStatisticModel.itemStatisticConditionCategories
                  .where(
                    (ItemStatisticConditionCategoryModel category) =>
                        category.code == 'tidak-digunakan' ||
                        category.code == 'digunakan',
                  )
                  .toList();

          return RepaintBoundary(
            child: BasicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    filteredCategories.reversed
                        .toList()
                        .asMap()
                        .entries
                        .map((MapEntry<int, ItemStatisticConditionCategoryModel> entry) => _buildLineChart(entry.value, entry.key))
                        .toList(),
              ),
            ),
          );
        },
      );

  Widget _buildLineChart(ItemStatisticConditionCategoryModel model, int index) {
    final List<SingleStackedBarChartModel> charts =
        model.itemStatisticConditions
            .map(
              (e) => SingleStackedBarChartModel(
                units: e.total.toDouble(),
                color: generateColor(e.code),
                label: e.name,
                percentage: e.percentage,
              ),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        index != 0
            ? const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Divider(color: Color(0xFFDBDFE9)),
            )
            : Container(),
        Row(
          children: [
            Text(model.name),
            const SizedBox(width: 8),
            CustomBadge(
              label: '${model.total} Barang',
              color: const Color(0xff04B440),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(height: 10, child: SingleStackedBarChart(data: charts)),
        const SizedBox(height: 6),
        Wrap(children: _buildLegendList(charts)),
        const SizedBox(height: 4),
      ],
    );
  }

  Color generateColor(String code) {
    Color color = Colors.grey;

    switch (code) {
      case 'FR':
      case 'TR':
        color = Colors.blue;
        break;
      case 'FH':
      case 'TH':
        color = const Color(0xFFFF3B30);
        break;
      case 'DB':
        color = const Color(0xFF17C653);
        break;
      case 'DS':
        color = const Color(0xFFF6B100);
        break;
      case 'DJ':
        color = const Color(0xFFFF6F1E);
        break;
    }

    return color;
  }

  List<Widget> _buildLegendList(List<SingleStackedBarChartModel> data) {
    final total = data.fold<double>(0, (sum, item) => sum + item.units);
    return data
        .map(
          (SingleStackedBarChartModel item) => _buildLegendItem(
            label: item.label ?? "Label",
            percentage: '${item.percentage}%',
            color: item.color,
          ),
        )
        .toList();
  }

  Widget _buildLegendItem({
    required String label,
    required String percentage,
    required Color color,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        CustomBadge(label: percentage, color: color),
      ],
    ),
  );
}
