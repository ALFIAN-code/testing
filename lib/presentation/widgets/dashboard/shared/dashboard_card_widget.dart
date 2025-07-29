import 'package:flutter/material.dart';

import '../../shared/card/basic_card.dart';

class DashboardCardWidget extends StatelessWidget {
  final String title;
  final int value;

  const DashboardCardWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => BasicCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5675),
          ),
        ),
      ],
    ),
  );
}
