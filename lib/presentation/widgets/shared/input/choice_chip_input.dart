import 'package:flutter/material.dart';

typedef ItemLabelBuilder<T> = String Function(T item);
typedef ItemValueBuilder<T> = dynamic Function(T item);
typedef OnChipSelected<T> = void Function(T selectedItem, dynamic selectedValue);

class ChoiceChipInput<T> extends StatelessWidget {
  final String? label;
  final List<T> choices;
  final ItemLabelBuilder<T> labelBuilder;
  final ItemValueBuilder<T> valueBuilder;
  final dynamic selectedValue ;
  final OnChipSelected<T> onSelected;
  final int? chipsPerRow;
  final bool isMandatory;

  const ChoiceChipInput({
    Key? key,
    this.label,
    required this.choices,
    required this.labelBuilder,
    required this.valueBuilder,
    this.selectedValue,
    required this.onSelected,
    this.chipsPerRow,
    this.isMandatory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              children: isMandatory
                  ? const <InlineSpan>[
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                )
              ]
                  : [],
            ),
          ),
        ),

      Column(
        children: _buildRowsOfChips(context),
      ),
    ],
  );

  List<Widget> _buildRowsOfChips(BuildContext context) {
    if (chipsPerRow == null || chipsPerRow! <= 0) {
      return [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: choices.map((item) {
              final itemLabel = labelBuilder(item);
              final itemValue = valueBuilder(item);
              final isSelected = selectedValue == itemValue;

              return ChoiceChip(
                label: Text(itemLabel),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onSelected(item, itemValue);
                  }
                },
                selectedColor: Colors.black,
                backgroundColor: Colors.white,
                checkmarkColor: isSelected == true ? Colors.white : Colors.black,
                labelStyle: TextStyle(
                  color: isSelected == true ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ),
      ];
    }

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < choices.length; i += chipsPerRow!) {
      final endIndex = (i + chipsPerRow! > choices.length) ? choices.length : i + chipsPerRow!;
      final rowChoices = choices.sublist(i, endIndex);

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: rowChoices.map((item) {
              final itemLabel = labelBuilder(item);
              final itemValue = valueBuilder(item);
              final isSelected = selectedValue == itemValue;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Center(child: Text(itemLabel)),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        onSelected(item, itemValue);
                      }
                    },
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    checkmarkColor: isSelected == true ? Colors.white : Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected == true ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    return rows;
  }
}


class CustomChipInput<T> extends StatelessWidget {
  final String? label;
  final List<T> items;
  final ItemLabelBuilder<T> labelBuilder;
  final ItemValueBuilder<T> valueBuilder;
  final dynamic selectedValue;
  final OnChipSelected<T> onSelected;
  final int? chipsPerRow;
  final double? maxHeight;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? selectedColor;
  final Color? unselectedColor;
  final BorderRadius? borderRadius;
  final BoxBorder? selectedBorder;
  final BoxBorder? unselectedBorder;
  final Widget? selectedIcon;
  final Widget? unselectedIcon;
  final double iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final double chipHeight;
  final bool showCheckIcon;
  final bool isMandatory;

  const CustomChipInput({
    super.key,
    this.label,
    required this.items,
    required this.labelBuilder,
    required this.valueBuilder,
    this.selectedValue,
    required this.onSelected,
    this.chipsPerRow,
    this.maxHeight,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.padding,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius,
    this.selectedBorder,
    this.unselectedBorder,
    this.selectedIcon = const Icon(Icons.check, size: 16, color: Colors.white),
    this.unselectedIcon,
    this.iconSize = 16,
    this.iconPadding = const EdgeInsets.only(right: 4),
    this.chipHeight = 48.0,
    this.showCheckIcon = true,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultSelectedColor = selectedColor ?? theme.primaryColor;
    final defaultUnselectedColor = unselectedColor ?? Colors.white;
    final defaultSelectedTextStyle = selectedTextStyle ??
        const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );
    final defaultUnselectedTextStyle = unselectedTextStyle ??
        TextStyle(
          fontSize: 10,
          color: theme.textTheme.bodyMedium?.color,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                children: isMandatory
                    ? const <InlineSpan>[
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ]
                    : [],
              ),
            ),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? double.infinity,
          ),
          child: SingleChildScrollView(
            physics: maxHeight != null
                ? const ClampingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: chipsPerRow != null && chipsPerRow! > 0
                ? _buildGridLayout(
              context,
              defaultSelectedColor,
              defaultUnselectedColor,
              defaultSelectedTextStyle,
              defaultUnselectedTextStyle,
            )
                : _buildWrapLayout(
              defaultSelectedColor,
              defaultUnselectedColor,
              defaultSelectedTextStyle,
              defaultUnselectedTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipItem(
      T item,
      Color selectedColor,
      Color unselectedColor,
      TextStyle selectedTextStyle,
      TextStyle unselectedTextStyle,
      ) {
    final itemValue = valueBuilder(item);
    final isSelected = selectedValue == itemValue;
    final text = labelBuilder(item);

    return GestureDetector(
      onTap: () => onSelected(item, itemValue),
      child: Container(
        constraints: BoxConstraints(
          minHeight: chipHeight,
          minWidth: 80,
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: isSelected ? selectedBorder : Border.all(color: Colors.grey.shade500),
        ),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected && showCheckIcon && selectedIcon != null)
                Padding(
                  padding: iconPadding!,
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: selectedIcon,
                  ),
                ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: isSelected ? selectedTextStyle : unselectedTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWrapLayout(
      Color selectedColor,
      Color unselectedColor,
      TextStyle selectedTextStyle,
      TextStyle unselectedTextStyle,
      ) => Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((item) => _buildChipItem(
        item,
        selectedColor,
        unselectedColor,
        selectedTextStyle,
        unselectedTextStyle,
      )).toList(),
    );

  Widget _buildGridLayout(
      BuildContext context,
      Color selectedColor,
      Color unselectedColor,
      TextStyle selectedTextStyle,
      TextStyle unselectedTextStyle,
      ) => LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (spacing * (chipsPerRow! - 1))) / chipsPerRow!;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: items.map((item) => SizedBox(
            width: itemWidth,
            child: _buildChipItem(
              item,
              selectedColor,
              unselectedColor,
              selectedTextStyle,
              unselectedTextStyle,
            ),
          )).toList(),
        );
      },
    );
}