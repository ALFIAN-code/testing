import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../data/models/base_list_request_model.dart';

class FilterDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<DropdownOption> options;
  final void Function(String?)? onChanged;
  final EdgeInsetsGeometry? margin;
  final bool enabled;

  const FilterDropdown({
    super.key,
    required this.label,
    this.value,
    required this.options,
    this.onChanged,
    this.margin,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    decoration: BoxDecoration(
      color: enabled ? Colors.grey.shade100 : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: regiJayaPrimaryBorder),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
          size: 20,
        ),
        isExpanded: true,
        onChanged: enabled ? onChanged : null,
        isDense: true,
        items: options
            .map(
              (DropdownOption option) => DropdownMenuItem<String>(
            value: option.value,
            child: Text(
              option.label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        )
            .toList(),
      ),
    ),
  );
}

class DropdownOption {
  final String value;
  final String label;

  const DropdownOption({required this.value, required this.label});
}

class FilterField {
  final String field;
  final String label;
  final List<DropdownOption> options;
  final bool enabled;

  const FilterField({
    required this.field,
    required this.label,
    required this.options,
    this.enabled = true,
  });
}

class BaseListFilterWidget extends StatelessWidget {
  final BaseListRequestModel requestModel;
  final List<FilterField> fields;
  final ValueChanged<BaseListRequestModel> onRequestChanged;
  final EdgeInsetsGeometry? padding;

  const BaseListFilterWidget({
    super.key,
    required this.requestModel,
    required this.fields,
    required this.onRequestChanged,
    this.padding,
  });

  String _currentValue(String field) {
    final String? f = requestModel.filters.firstWhere((FilterRequestModel e) => e.field == field,
        orElse: () => FilterRequestModel(field: field, operator: 'eq', value: ''))
        .value;
    return (f ?? '').trim();
  }

  BaseListRequestModel _updateFilter(String field, String? value) {
    final List<FilterRequestModel> newFilters = List.from(requestModel.filters ?? []);
    newFilters.removeWhere((e) => e.field == field);

    final String v = value?.trim() ?? '';
    if (v.isNotEmpty) {
      newFilters.add(FilterRequestModel(field: field, operator: 'eq', value: v));
    }

    return requestModel.copyWith(filters: newFilters);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Row(
      children: <Widget>[
        ...fields.map((FilterField f) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: FilterDropdown(
              label: f.label,
              value: _currentValue(f.field).isEmpty ? null : _currentValue(f.field),
              options: f.enabled ? f.options : [],
              enabled: f.enabled,
              onChanged: (String? val) {
                final BaseListRequestModel updated = _updateFilter(f.field, val);
                onRequestChanged(updated);
              },
            ),
          ),
        )),
      ],
    ),
  );
}
