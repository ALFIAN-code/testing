import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/keen_icon_constants.dart';
import '../../shared/card/basic_card.dart';
import '../../shared/icon/custom_icon.dart';

class ReceptionInfoCard extends StatelessWidget {
  const ReceptionInfoCard({
    required this.purchaseOrderNumber,
    required this.supplier,
    required this.estimatedArrival,
    required this.submitDate,
    super.key,
  });

  final String purchaseOrderNumber;
  final String supplier;
  final DateTime estimatedArrival;
  final DateTime submitDate;

  String _formatEstimatedArrival(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    final DateFormat timeFormat = DateFormat('HH.mm', 'id_ID');

    final String formattedDate = dateFormat.format(dateTime);
    final String formattedTime = timeFormat.format(dateTime);

    return '± $formattedDate - $formattedTime WIB';
  }

  String _formatSubmitDate(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) => BasicCard(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    backgroundColor: Colors.grey.shade50,
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: InfoItem(
                icon: KeenIconConstants.calendar2DuoTone
                ,
                label: 'No. Purchase Order',
                value: purchaseOrderNumber,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InfoItem(
                icon: KeenIconConstants.calendarCodeDuoTone,
                label: 'Supplier',
                value: supplier,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: InfoItem(
                icon: KeenIconConstants.calendarCodeDuoTone,
                label: 'Estimasi Kedatangan',
                value: _formatEstimatedArrival(estimatedArrival),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InfoItem(
                icon: KeenIconConstants.calendar2DuoTone,
                label: 'Tanggal Submit',
                value: _formatSubmitDate(submitDate),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIcon(icon, width: 18, height: 18, color: Colors.grey.shade800,),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: regiJayaTertiaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
