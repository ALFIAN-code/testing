import 'package:flutter/material.dart';

import '../alert/basic_alert.dart';
import '../alert/custom_alert.dart';

final class LineChartModel {
  final double value;
  final Color color;
  final String title;

  LineChartModel(this.value, this.color, this.title);
}

class LineChart extends StatelessWidget {
  final double width;
  final bool? enableLegend;
  final List<LineChartModel> data;
  const LineChart({
    super.key,
    required this.width,
    required this.data,
    this.enableLegend
  });

  @override
  Widget build(BuildContext context) => Column(
      children: [
        Row(
          children: data.map((e) => _buildLine(e)).toList(),
        ),
        const SizedBox(height: 8),
        if (enableLegend == true)
          Row(
            children: data.map((e) => _buildLegend(e)).toList(),
          ),
      ],
    );

  Widget _buildLine(LineChartModel model) {

    final double total = data.fold<double>(0, (double sum, LineChartModel item) => sum + (item.value));

    return Container(
      width: width * (model.value / total),
      height: 8,
      decoration: BoxDecoration(
        color: model.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildLegend(LineChartModel model) {
    final double total = data.fold<double>(0, (double sum, LineChartModel item) => sum + (item.value));
    final String mod = (model.value / total * 100).toStringAsFixed(2);
    return SizedBox(
      width: 300,
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: model.color,
            ),
          ),
          const SizedBox(width: 4),
          Text(model.title),
          const SizedBox(width: 4),
          CustomAlert(
            color: const Color(0xFF9E63FF),
            message: mod,
            icon: '',
          )
        ]
      ),
    );
  }
}
