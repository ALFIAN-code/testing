import 'package:flutter/material.dart';

class SingleStackedBarChart extends StatelessWidget {
  final List<SingleStackedBarChartModel> data;
  final double gap;

  const SingleStackedBarChart({
    super.key,
    required this.data,
    this.gap = .02,
  });

  List<double> get processedStops {
    final double totalGapsWith = gap * (data.length - 1);
    final double totalData = data.fold(0, (double a, SingleStackedBarChartModel b) => a + b.units);
    return data.fold(<double>[0.0], (List<double> l, SingleStackedBarChartModel d) {
      l.add(l.last + d.units * (1 - totalGapsWith) / totalData);
      l.add(l.last);
      l.add(l.last + gap);
      l.add(l.last);
      return l;
    })
      ..removeLast()
      ..removeLast()
      ..removeLast();
  }

  List<Color> get processedColors => data.fold(
        <Color>[],
            (List<Color> l, d) => [
          ...l,
          d.color,
          d.color,
          Colors.transparent,
          Colors.transparent,
        ])
      ..removeLast()
      ..removeLast();

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        gradient: LinearGradient(
          stops: processedStops,
          colors: processedColors,
        ),
      ),
    );
}

class SingleStackedBarChartModel {
  final String? label;
  final double? percentage;
  final double units;
  final Color color;

  SingleStackedBarChartModel({required this.units, required this.color, this.label, this.percentage});
}