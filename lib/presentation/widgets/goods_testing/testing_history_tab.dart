import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/models/item/item_maintenance_inspection_model.dart';
import '../../../data/models/item/item_maintenance_model.dart';
import '../../../data/models/tools_status/tool_status_model.dart';
import '../../bloc/goods_testing/detail_item_testing/detail_item_testing_bloc.dart';
import '../shared/card/basic_card.dart';
import '../shared/icon/custom_icon.dart';
import 'dialog_detail_foto.dart';

class TestingHistoryTab extends StatelessWidget {
  const TestingHistoryTab({super.key});


  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
        builder: (BuildContext context, DetailItemTestingState state) {
          final List<ItemMaintenanceModel>? listMaintenance = state.itemMaintenance;
          if (listMaintenance == null) {
            return Container();
          } else {
            return _MaintenanceHistoryExpansion(listMaintenance);
          }
        },);
}

class _MaintenanceHistoryExpansion extends StatelessWidget {
  final List<ItemMaintenanceModel> list;
  const _MaintenanceHistoryExpansion(this.list);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: [
        ExpansionTile(
            title: const Text('History Pengujian'),
            backgroundColor: Colors.black87,
            collapsedBackgroundColor: Colors.black87 ,
            textColor: Colors.white ,
            collapsedTextColor: Colors.white,
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(list.length, (index) => _MaintenanceFlowItem(
                      isLast: list.length != (index+1),
                        itemMaintenance: list[index]))
                  ],
                ),
              )
            ],
          ),
      ],
    ),
  );
}


class _MaintenanceFlowItem extends StatelessWidget {
  final bool isLast;
  final ItemMaintenanceModel itemMaintenance;
  const _MaintenanceFlowItem({required this.itemMaintenance, required this.isLast});


  Color get statusColor {
    switch (itemMaintenance.toolStatus?.code) {
      case 'ready':
        return Colors.green;
      case 'need-maintenance':
        return Colors.red;
      case 'retest':
        return const Color(0xFFF6B100);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFf9f9f9),
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                ),
                child: CustomIcon(
                  KeenIconConstants.calendarTickDuoTone, width: 24, height: 24,
                  color: Colors.grey.shade500,),
              ),
              Expanded(
                child: isLast ? Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ): const SizedBox(),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemMaintenance.toolStatus?.name ?? '',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 2),
                          Text(formatReadableDate(itemMaintenance.testedDate),
                              style: const TextStyle(fontSize: 12, color: Colors.black87)),

                        ],
                      ),
                      if (itemMaintenance.itemMaintenanceInspectionImages.isNotEmpty)
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (ctx) => PhotoDialog(imageUrls: itemMaintenance.itemMaintenanceInspectionImages,)
                          ),
                          child: BasicCard(
                            margin: const EdgeInsets.only(top: 6, bottom: 6),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            borderRadius: BorderRadius.circular(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image_outlined, size: 14),
                                const SizedBox(width: 4),
                                Text('${itemMaintenance.itemMaintenanceInspectionImages.length} Foto', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  ...List.generate(itemMaintenance.itemMaintenanceInspections.length, (int index) => BasicCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.sticky_note_2_outlined, size: 18, color: Colors.black87,),
                            const SizedBox(width: 4,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Catatan - ${itemMaintenance.itemMaintenanceInspections[index].inspection?.name ?? ''}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), softWrap: true,),
                                  const SizedBox(height: 4,),
                                  Text(
                                    itemMaintenance.itemMaintenanceInspections[index].note,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    ))
                ],
              )
          )
        ],
      ),
    ),
  );
}

