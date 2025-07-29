import 'package:flutter/material.dart';

import '../../../../core/utils/device_util.dart';
import '../../../../data/models/pagination_response_model.dart';
import '../after_build_widget.dart';
import '../input/text_input.dart';

class SearchableDropdownItem {
  final String value;
  final String label;
  final Widget widget;
  final bool isSelectable;

  SearchableDropdownItem({
    required this.value,
    required this.label,
    required this.widget,
    this.isSelectable = true,
  });
}

class SearchableDropdown<T> extends StatefulWidget {
  final Future<PaginationResponseModel<T>?> Function() dataLoader;
  final SearchableDropdownItem Function(T item) itemBuilder;
  final Future<String?> Function(String value)? getLabelFromValue;
  final int dataPerPage;
  final EdgeInsets? margin;
  final String? defaultValue;
  final void Function(String? value, String? label)? onChange;
  final TextEditingController? controller;
  final bool isMandatory;
  final bool isEnable;
  final bool canClear;

  const SearchableDropdown({
    super.key,
    required this.dataLoader,
    required this.itemBuilder,
    this.getLabelFromValue,
    this.dataPerPage = 30,
    this.margin,
    this.defaultValue,
    this.onChange,
    this.controller,
    this.isMandatory = false,
    this.isEnable = true,
    this.canClear = false,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late TextEditingController uiController;
  late TextEditingController valueController;

  bool isLoadingLabel = false;
  bool isLoadingData = false;

  String? selectedValue;
  String? selectedLabel;

  @override
  void initState() {
    super.initState();

    if (widget.defaultValue != null &&
        widget.defaultValue!.isNotEmpty &&
        widget.getLabelFromValue != null) {
      selectedValue = widget.defaultValue;
      isLoadingLabel = true;
    }

    uiController = TextEditingController();
    valueController =
        widget.controller ?? TextEditingController(text: selectedValue);

    valueController.addListener(() {
      final String newValue = valueController.text;
      final bool wasSame = newValue == (selectedValue ?? '');
      final bool changedFromOutside = !wasSame;

      if (mounted && changedFromOutside && widget.getLabelFromValue != null) {
        _fillLabelFromValue(newValue);
      }
    });
  }

  @override
  void dispose() {
    uiController.dispose();
    if (widget.controller == null) {
      valueController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AfterBuildWidget(
    onAfterBuild: (_) {
      if (isLoadingLabel && widget.getLabelFromValue != null) {
        _fillLabelFromValue(selectedValue ?? '');
      }
    },
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        TextField(
          controller: uiController,
          readOnly: true,
          onTap: () {
            DeviceUtils.hideKeyboard(context);
            if (!widget.isEnable) return;
            if (!isLoadingLabel && !isLoadingData) {
              _showDialog(context);
            }
          },
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            hintText: 'Pilih',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.canClear && selectedValue != null
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      if (!widget.isEnable) return;
                      _onValueChanged(null);
                    },
                  )
                : const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
          ),
        ),
        if (isLoadingLabel || isLoadingData) const CircularProgressIndicator(),
      ],
    ),
  );

  void _onValueChanged(SearchableDropdownItem? item) {
    if (item != null) {
      selectedValue = item.value;
      selectedLabel = item.label;
      valueController.text = item.value;
      uiController.text = item.label;
    } else {
      selectedValue = null;
      selectedLabel = null;
      valueController.clear();
      uiController.clear();
      setState(() {

      });
    }

    widget.onChange?.call(selectedValue, selectedLabel);
  }

  Future<void> _fillLabelFromValue(String value) async {
    setState(() {
      isLoadingLabel = true;
    });

    try {
      if (widget.getLabelFromValue != null && value.isNotEmpty) {
        final String? label = await widget.getLabelFromValue!(value);
        if (label != null && label.isNotEmpty) {
          uiController.text = label;
        } else {
          _onValueChanged(null);
        }
      } else {
        _onValueChanged(null);
      }
    } catch (_) {
      _onValueChanged(null);
    }

    if (mounted) {
      setState(() {
        isLoadingLabel = false;
      });
    }
  }

  void _showDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (BuildContext ctx) => _DropdownDialog<T>(
            dataLoader: widget.dataLoader,
            itemBuilder: widget.itemBuilder,
            onSelected: (SearchableDropdownItem item) {
              Navigator.pop(ctx);
              _onValueChanged(item);
            },
          ),
    );
  }
}

class _DropdownDialog<T> extends StatefulWidget {
  final Future<PaginationResponseModel<T>?> Function() dataLoader;
  final SearchableDropdownItem Function(T item) itemBuilder;
  final ValueChanged<SearchableDropdownItem> onSelected;

  const _DropdownDialog({
    super.key,
    required this.dataLoader,
    required this.itemBuilder,
    required this.onSelected,
  });

  @override
  State<_DropdownDialog<T>> createState() => _DropdownDialogState<T>();
}

class _DropdownDialogState<T> extends State<_DropdownDialog<T>> {
  late TextEditingController searchController;

  bool isLoadingData = false;
  bool hasError = false;
  String? errorMessage;

  List<T> allItems = <T>[];
  List<T> filteredItems = <T>[];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _fetchAllData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    setState(() {
      isLoadingData = true;
      hasError = false;
      errorMessage = null;
    });

    try {
      final PaginationResponseModel<T>? result = await widget.dataLoader();
      if (result != null) {
        allItems = result.items;
      } else {
        allItems = <T>[];
      }
      filteredItems = List<T>.from(allItems);
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (mounted) {
      setState(() {
        isLoadingData = false;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    final String query = value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredItems = List<T>.from(allItems);
    } else {
      filteredItems =
          allItems.where((item) {
            final String label = widget.itemBuilder(item).label.toLowerCase();
            return label.contains(query);
          }).toList();
    }
    setState(() {});
  }

  void _onSearchChanged(String? value) {
    if (value == null || value.isEmpty) {
      filteredItems = List<T>.from(allItems);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: <Widget>[
        _buildHeaderSection(context),
        Expanded(child: _buildBody(context)),
      ],
    ),
  );

  Widget _buildHeaderSection(BuildContext context) => Container(
    color: Colors.white,
    padding: const EdgeInsets.only(top: 8, bottom: 16),
    child: Column(
      children: <Widget>[
        const DraggableIndicator(color: Color(0xFFF3F5F7)),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Silakan Pilih',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextInput(
            labelText: 'Cari data',
            hintText: 'Cari data',
            textInputAction: TextInputAction.search,
            controller: searchController,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
          ),
        ),
      ],
    ),
  );

  Widget _buildBody(BuildContext context) {
    if (isLoadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            errorMessage ?? 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (filteredItems.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (BuildContext ctx, int index) {
        final T item = filteredItems[index];
        final SearchableDropdownItem dropdownItem = widget.itemBuilder(item);

        return GestureDetector(
          onTap: () {
            if (dropdownItem.isSelectable) {
              DeviceUtils.hideKeyboard(context);
              widget.onSelected(dropdownItem);
            }
          },
          child: dropdownItem.widget,
        );
      },
    );
  }
}

class DraggableIndicator extends StatelessWidget {
  final Color color;
  const DraggableIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}
