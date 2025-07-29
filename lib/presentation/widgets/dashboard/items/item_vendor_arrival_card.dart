import 'package:flutter/material.dart';

import '../../../../data/models/dashboard/item_vendor_arrival_model.dart';

class ItemVendorArrivalCard extends StatelessWidget {
  
  final ItemVendorArrivalModel model;

  const ItemVendorArrivalCard({
    super.key,
    required this.model
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            model.code,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(8),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supplier',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4,),
              Text(
                model.supplier?.name ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8,),
              Text(
                'No. PO',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4,),
              Text(
                model.poNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8,),
              Text(
                'Barang',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4,),
              Text(
                '${model.totalItem} Barang (${model.totalItemCode} Jenis)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8,),
            ],
          ),
        ),
        Builder(builder: (BuildContext context) {
          final int daysAgo = model.estimatedDate.difference(DateTime.now()).inDays;
          return Container(
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
            );
        }),
        const SizedBox(height: 10),
      ],
    ),
  );
}
