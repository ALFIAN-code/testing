import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/item_preparation/item_preparation_detail_model.dart';
import '../../../data/models/item_preparation/item_preparation_summary_model.dart';
import '../../bloc/item_entrance/detail_item_entrance/detail_item_entrance_bloc.dart';
import '../shared/button/metronic_button.dart';
import '../shared/card/basic_card.dart';
import '../shared/view/error_retry_view.dart';
import '../state/base_ui_state.dart';

class TestResultDialog extends StatefulWidget {
  final ItemPreparationSummaryModel model;
  const TestResultDialog({super.key, required this.model});

  @override
  State<TestResultDialog> createState() => _TestResultDialogState();
}

class _TestResultDialogState extends BaseUiState<TestResultDialog> {
  @override
  Widget build(BuildContext context) => BlocListener<DetailItemEntranceBloc, DetailItemEntranceState>(
    listenWhen: (DetailItemEntranceState previous, DetailItemEntranceState current) => previous.deleteStatus != current.deleteStatus,
    listener: (BuildContext context, DetailItemEntranceState state) {
      if (state.deleteStatus.isInProgress) {
        showLoading();
      } else if (state.deleteStatus.isFailure) {
        hideLoading();
        showErrorMessage(state.errorMessage ?? 'Terjadi Kesalahan');
      } else if (state.deleteStatus.isSuccess) {
        hideLoading();
      }
    },
    child: AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
            buildWhen: (p,c) => p.project != c.project,
            builder: (BuildContext context, DetailItemEntranceState state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model.itemCodeCode, style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
                  Text(widget.model.itemCodeName, style: const TextStyle(
                    fontSize: 15,
                  ),),
                ],
              ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<DetailItemEntranceBloc>().load();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: BlocBuilder<DetailItemEntranceBloc, DetailItemEntranceState>(
        builder: (BuildContext context, DetailItemEntranceState state) {
          if (state.detailStatus.isInProgress) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            );
          } else if (state.detailStatus.isFailure) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ErrorRetryView(errorMessage: state.errorMessage,
                    onRetry: () => context.read<DetailItemEntranceBloc>().loadDetail(widget.model.itemCodeId)),
              ],
            );
          }

          if (state.detailItems.isEmpty) {
            return const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Padding(
              padding: EdgeInsets.symmetric(vertical: 64.0),
              child: Text('Data Kosong'),
            ),],);
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
                children: state.detailItems.map((ItemPreparationDetailModel element) => _TestResultItem(
                  testResultItemModel: element,
                  index: 0,
                  itemName:  '-',),).toList(),
              ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<DetailItemEntranceBloc>().load();
            Navigator.pop(context);
          },
          child: const Text("Batal"),
        ),
      ],
    ),
  );
}

class _TestResultItem extends StatelessWidget {
  final int index;
  final String itemName;
  final ItemPreparationDetailModel testResultItemModel;
  const _TestResultItem({required this.testResultItemModel, required this.index, required this.itemName});

  @override
  Widget build(BuildContext context) => BasicCard(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(testResultItemModel.itemBarcode ?? '-'),
                    Text(testResultItemModel.itemCodeName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),)
                  ],
                )),
            const SizedBox(width: 8),
            Expanded(
              child:  MetronicButton(
                    color: Colors.red,
                    icon: KeenIconConstants.trashOutline,
                    onPressed: () => context.read<DetailItemEntranceBloc>().delete(testResultItemModel.itemCodeId, testResultItemModel.itemRequestItemScanId),
                )
            ),
          ],
        )
    );
}

