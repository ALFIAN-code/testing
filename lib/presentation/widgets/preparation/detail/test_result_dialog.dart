import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../../../../data/models/test_result_item_model.dart';
import '../../../bloc/preparation/detail_preparation/detail_preparation_bloc.dart';
import '../../shared/button/metronic_button.dart';
import '../../shared/card/basic_card.dart';

class TestResultDialog extends StatelessWidget {
  final String id;
  const TestResultDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailPreparationBloc, DetailPreparationState>(
      builder: (BuildContext context, DetailPreparationState state) => AlertDialog(
        backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('-', style: const TextStyle(
                    fontSize: 14,
                      fontWeight: FontWeight.bold)),
                  Text('-', style: const TextStyle(
                    fontSize: 15,
                  ),),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Builder(
              builder: (BuildContext context) {
                final List<TestResultItemModel> list = [];

                return Column(
                  children: list.map((TestResultItemModel element) => _TestResultItem(
                        testResultItemModel: element,
                        index: 0,
                        itemName:  '-',),).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
          ],
        ),
    );
}

class _TestResultItem extends StatelessWidget {
  final int index;
  final String itemName;
  final TestResultItemModel testResultItemModel;
  const _TestResultItem({super.key, required this.testResultItemModel, required this.index, required this.itemName});

  @override
  Widget build(BuildContext context) => BasicCard(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(testResultItemModel.code),
                    Text(itemName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),)
                  ],
                )),
            Expanded(
              flex: 1,
                child:  MetronicButton(
                    color: Colors.red,
                    icon: KeenIconConstants.trashOutline,
                    onPressed: () => {})
            ),
          ],
        )
    );
}

