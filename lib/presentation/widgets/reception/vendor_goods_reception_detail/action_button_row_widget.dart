import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../shared/search_bar_widget.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class ActionButtonRow extends StatefulWidget {
  const ActionButtonRow({
    required this.onRefresh,
    required this.onSearch,
    this.onViewPdf,
    this.debounceDuration = const Duration(milliseconds: 500),
    super.key,
  });

  final VoidCallback onRefresh;
  final void Function(String) onSearch;
  final VoidCallback? onViewPdf;
  final Duration? debounceDuration;

  @override
  State<ActionButtonRow> createState() => _ActionButtonRowState();
}

class _ActionButtonRowState extends State<ActionButtonRow> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Cancel previous timer if it's active
    _debounceTimer?.cancel();

    // Start new timer
    _debounceTimer = Timer(widget.debounceDuration!, () {
      widget.onSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      ActionButton(
          icon: Icons.refresh,
          label: 'Refresh',
          onPressed: widget.onRefresh
      ),
      Expanded(
        child: SizedBox(
          height: 40,
          child: CustomSearchBar(
            hintText: 'Search',
            onChanged: _onSearchChanged,
            prefixIcon: const Icon(
                Icons.search,
                color: regiJayaSecondaryText,
                size: 18
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
      if (widget.onViewPdf != null) ActionButton(
        icon: Icons.picture_as_pdf,
        iconColor: Colors.red,
        label: 'Lihat PDF',
        onPressed: widget.onViewPdf ?? () {},
      ),
    ],
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 18, color: iconColor ?? regiJayaSecondaryText),
    label: Text(label),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey.shade700,
      elevation: 0,
      side: const BorderSide(color: regiJayaPrimaryBorder),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
