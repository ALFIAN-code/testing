import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../../../../data/models/item_vendor_item_vendor_checklist/item_vendor_item_vendor_checklist_param.dart';
import '../../../bloc/reception/goods_checklist_form/goods_receipt_checklist_bloc.dart';
import '../../shared/input/text_input.dart';

class ChecklistFormSection extends StatelessWidget {
  const ChecklistFormSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
      builder: (BuildContext context, GoodsChecklistFormState state) {
        final List<ItemVendorChecklistPaginatedModel> checklistItems = state.itemVendorChecklistPaginated ?? [];

        if (checklistItems.isEmpty) {
          return const Text('Checklist kosong');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checklist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...List.generate(checklistItems.length, (int index) {
              final ItemVendorChecklistPaginatedModel item = checklistItems[index];
              final ItemVendorItemVendorChecklistParam? checklistParam = state.selectedChecklist
                  ?.where((ItemVendorItemVendorChecklistParam e) => e.itemVendorChecklistId == item.id).first;
              return ChecklistItem(
                index: index,
                item: item,
                isSuitable: checklistParam?.isSuitable,
                defaultNote: checklistParam?.note,
                isSelected: state.selectedChecklist
                    ?.any((ItemVendorItemVendorChecklistParam e) => e.itemVendorChecklistId == item.id) ??
                    false,
              );
            }),
          ],
        );
      },
    );
}

class ChecklistItem extends StatefulWidget {
  final int index;
  final ItemVendorChecklistPaginatedModel item;
  final bool? isSuitable;
  final String? defaultNote;
  final bool isSelected;

  const ChecklistItem({
    super.key,
    required this.index,
    required this.item,
    required this.isSelected,
    this.isSuitable,
    this.defaultNote,
  });

  @override
  State<ChecklistItem> createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<ChecklistItem> {
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(
      text: widget.defaultNote ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.only(left: 10),
    decoration: const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Color(0xFF99A1B7),
          width: 3.0,
        ),
      ),
    ),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${widget.index + 1}. ${widget.item.name}'),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: ChoiceChip(
                  selectedColor: Colors.black,
                  backgroundColor: Colors.white,
                  checkmarkColor: widget.isSuitable == true ? Colors.white : Colors.black,
                  label: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Sesuai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.isSuitable == true ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  selected: widget.isSuitable == true,
                  onSelected: (_) => _updateState(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ChoiceChip(
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    checkmarkColor: widget.isSuitable == false ? Colors.white : Colors.black,
                    label: Center(
                      child: Text(
                        'Tidak Sesuai',
                        style: TextStyle(
                          color: widget.isSuitable == false ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    selected: widget.isSuitable == false,
                    onSelected: (_) => _updateState(false),
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 8),
          TextInput(
            controller: noteController,
            hintText: 'Catatan (Opsional)',
            minLines: 2,
            maxLines: 3,
            onChanged: (_) => _updateState(widget.isSuitable),
          ),
        ],
      ),
  );

  void _updateState(bool? suitable) {
    final GoodsChecklistFormBloc cubit = context.read<GoodsChecklistFormBloc>();

    final ItemVendorItemVendorChecklistParam newChecklist = ItemVendorItemVendorChecklistParam(
      id: null,
      isSuitable: suitable,
      note: noteController.text,
      itemVendorChecklistId: widget.item.id,
    );

    cubit.updateChecklistItem(newChecklist);
  }
}
