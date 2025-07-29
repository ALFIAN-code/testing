import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/condition/condition_paginated_model.dart';
import '../../../data/models/condition_category/condition_category_paginated_model.dart';
import '../../../data/models/item/item_test_inspection_param.dart';
import '../../../data/models/item/item_test_inspection_parameter_param.dart';
import '../../../data/models/tools_status/tool_status_paginated_model.dart';
import '../../bloc/goods_testing/detail_item_testing/detail_item_testing_bloc.dart';
import '../item_inspection/status_selector.dart';
import '../shared/button/basic_button.dart';
import '../shared/input/choice_chip_input.dart';
import '../shared/input/image_picker_input.dart';
import '../shared/input/labeled_text_input.dart';
import 'confirm_update_dialog.dart';

class TestingFormTab extends StatelessWidget {
  const TestingFormTab({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _TestingForm(),
          const SizedBox(height: 16),
          const _StatusForm(),
          const SizedBox(height: 20),
          _buildSubmitButton(
              onCancel: () => context.router.back(),
              onSubmit: () => showDialog<Widget>(
                  context: context,
                  builder: (BuildContext ctx) => BlocProvider.value(
                    value: context.read<DetailItemTestingBloc>(),
                      child: const ConfirmUpdateDialog()))
          ),
          const SizedBox(height: 64),
        ],
      ),
    );

  Widget _buildSubmitButton({
    required VoidCallback onCancel,
    required VoidCallback onSubmit,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      BasicButton(
        text: 'Batal',
        variant: ButtonVariant.outlined,
        onClick: onCancel,
      ),
      const SizedBox(width: 16),
      BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
        buildWhen: (p,c)=>p.isValid != c.isValid,
        builder: (BuildContext context, DetailItemTestingState state) => BasicButton(
          isEnable: state.isValid,
              text: 'Selesaikan Pengujian',
              onClick: onSubmit
          ),
      ),
    ],
  );
}

class _TestingForm extends StatelessWidget {
  const _TestingForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
      builder: (BuildContext context, DetailItemTestingState state) => Column(
          children: state.listItemTestInspectionParam.map((e) => _buildFormItemList(context, e)).toList(),
        ),
    );

  Widget _buildFormItemList(BuildContext context, ItemTestInspectionParam testParam) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: testParam.inspectionName,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          children: const <InlineSpan>[
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
      const SizedBox(height: 8),
      ...testParam.itemTestInspectionParameters
          .asMap()
          .entries
          .map((MapEntry<int, ItemTestInspectionParameterParam> entry) => _buildItemTestForm(context, testParam.inspectionId, entry.value, entry.key)),
      const SizedBox(height: 4),
      LabeledTextInput(
        label: 'Catatan / Rekomendasi Perbaikan',
        minLines: 2,
        maxLines: 4,
        isMandatory: true,
        onChanged: (String value) => context.read<DetailItemTestingBloc>().updateNote(testParam.inspectionId, value),
      ),
      const SizedBox(height: 4),
      ImagePickerInput(
        label: 'Upload Foto',
        imagePaths: testParam.imageList,
        maxImages: 4,
        onChanged: (List<String> newList) {
          context.read<DetailItemTestingBloc>().updateImageList(testParam.inspectionId, newList);
        },
      )
    ],
  );

  Widget _buildItemTestForm(BuildContext context, String inspectionId, ItemTestInspectionParameterParam parameter, int index) => Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              RichText(
                text: TextSpan(
                  text: '${index+1}.  ${parameter.inspectionParameterName}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                  children: const <InlineSpan>[
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Radio<bool>(
                    activeColor: Colors.black87,
                    value: true,
                    groupValue: parameter.isQualified,
                    onChanged: (bool? value) {
                      context.read<DetailItemTestingBloc>().updateItem(inspectionId, parameter.inspectionParameterId, value);
                    },
                  ),
                  const Text('Layak'),
                  const SizedBox(width: 16),
                  Radio<bool>(
                    activeColor: Colors.black87,
                    value: false,
                    groupValue: parameter.isQualified,
                    onChanged: (bool? value) {
                      context.read<DetailItemTestingBloc>().updateItem(inspectionId, parameter.inspectionParameterId, value);
                    },
                  ),
                  const Text('Tidak layak'),
                ],
              ),
            ],
          ),
      ],
    ),
  );
}

class _StatusForm extends StatelessWidget {
  const _StatusForm({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DetailItemTestingBloc, DetailItemTestingState>(
        builder: (BuildContext context, DetailItemTestingState state) {
          if (state.status.isInProgress) {
            return Container();
          }

          return Column(
            children: [
              CustomChipInput<ToolStatusPaginatedModel>(
                  label: 'Status Alat',
                  isMandatory: true,
                  chipsPerRow: 3,
                  maxHeight: 200,
                  items: state.listToolStatus ?? [],
                  labelBuilder: (item) => item.name,
                  valueBuilder: (ToolStatusPaginatedModel item) => item.id,
                  selectedValue: state.selectedToolStatusId,
                  onSelected: (ToolStatusPaginatedModel selectedItem, dynamic selectedValue) {
                    context.read<DetailItemTestingBloc>().updateSelectedToolStatus(selectedItem.id);
                  }
              ),
              const SizedBox(height: 16,),
              CustomChipInput<ConditionCategoryPaginatedModel>(
                  isMandatory: true,
                chipsPerRow: 3,

                  maxHeight: 200,
                label: 'Kateogori Kondisi',
                  items: state.listConditionCategory ?? [],
                  labelBuilder: (item) => item.name.replaceAll(' ', '\n'),
                  valueBuilder: (ConditionCategoryPaginatedModel item) => item.id,
                  selectedValue: state.selectedConditionCategoryId,
                  onSelected: (ConditionCategoryPaginatedModel selectedItem, dynamic selectedValue) {
                    context.read<DetailItemTestingBloc>().updateSelectedConditionCategory(selectedItem.id);
                  }
              ),
              const SizedBox(height: 16,),
              Builder(
                builder: (BuildContext context) {
                  final List<ConditionCategoryPaginatedModel> conditionCategory = state.listConditionCategory ?? <ConditionCategoryPaginatedModel>[];
                  if (state.selectedConditionCategoryId == null || state.selectedConditionCategoryId == '') {
                    return Container();
                  } else {
                    List<ConditionPaginatedModel> conditions = state.listCondition ?? [];
                    conditions = conditions.where((ConditionPaginatedModel e) => e.conditionCategoryId == state.selectedConditionCategoryId).toList();
                    return ChoiceChipInput<ConditionPaginatedModel>(
                      label: 'Kondisi Alat',
                        isMandatory: true,
                        choices: conditions,
                        chipsPerRow: 3,
                        labelBuilder: (ConditionPaginatedModel item) => item.name,
                        valueBuilder: (ConditionPaginatedModel item) => item.id,
                        selectedValue: state.selectedConditionId,
                        onSelected: (ConditionPaginatedModel selectedItem, dynamic selectedValue) {
                          context.read<DetailItemTestingBloc>().updateSelectedCondition(selectedItem.id);
                        }
                    );
                  }

                },
              ),
            ],
          );
        }
    );
}
