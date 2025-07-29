import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class RejectionReasonCard extends StatelessWidget {
  const RejectionReasonCard({required this.reason, super.key});

  final String reason;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Alasan Penolakan',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: regiJayaPrimaryContainerBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: regiJayaPrimaryBorder),
        ),
        child: Text(
          reason,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    ],
  );
}
