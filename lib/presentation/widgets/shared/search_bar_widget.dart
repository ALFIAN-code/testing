import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? margin;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Cari',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.prefixIcon,
    this.margin,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: regiJayaPrimaryBorder),
    ),
    margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      textAlignVertical: TextAlignVertical.center,
      controller: _searchController,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: regiJayaTertiaryText,
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 4),
          child:
              widget.prefixIcon ??
              const Icon(Icons.search, color: regiJayaSecondaryText, size: 16),
        ),
        filled: true,
        fillColor: regiJayaTertiaryContainerBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: regiJayaPrimaryBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        isDense: true,
      ),
    ),
  );
}
