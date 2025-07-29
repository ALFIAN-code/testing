import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/dashboard/item_test_pagination_model.dart';

class ItemTestCard extends StatelessWidget {
  final String productCode;
  final String itemCode;
  final String lastTestDate;
  final int daysAgo;
  final List<ItemInspection> inspections;

  const ItemTestCard({
    super.key,
    required this.productCode,
    required this.itemCode,
    required this.lastTestDate,
    required this.daysAgo,
    required this.inspections,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          child: Text(
            productCode,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kode Barang',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              itemCode,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Uji Terakhir',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'd MMMM yyyy',
                            'id_ID',
                          ).format(DateTime.parse(lastTestDate)),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Uji',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 4,
                        children:
                            inspections
                                .map(
                                  (ItemInspection inspection) =>
                                      _BuildMiniChip(text: inspection.name),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          height: 24,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: (daysAgo < 0)
                  ? Colors.pink.shade50
                  : (daysAgo <= 10)?Colors.yellow.shade50 :Colors.green.shade50,
              foregroundColor: (daysAgo < 0)
                  ? Colors.pink.shade600
                  : (daysAgo <= 10)?Colors.yellow.shade800 :Colors.green.shade600,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: (daysAgo < 0)
                  ? Colors.pink.shade400
                  : (daysAgo <= 10)?Colors.yellow.shade400 :Colors.green.shade400,),
              ),
            ),
            child: Text(
              daysAgo > 0
                  ? '$daysAgo Hari lagi'
                  : (daysAgo == 0) ? 'Hari Ini' : '${daysAgo.abs()} Hari yang lalu',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

class _BuildMiniChip extends StatelessWidget {
  const _BuildMiniChip({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300, width: 0.5),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.black87),
    ),
  );
}

