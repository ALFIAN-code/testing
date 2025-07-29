import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/keen_icon_constants.dart';
import 'text_input.dart';

class SearchInput extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? prefixIcon;
  final String hintText;
  final EdgeInsetsGeometry? margin;
  final Duration debounceDuration;

  const SearchInput({
    Key? key,
    this.initialValue = '',
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon = KeenIconConstants.magnifierDuoTone,
    this.hintText = 'Cari',
    this.margin,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant SearchInput old) {
    super.didUpdateWidget(old);
    if (old.initialValue != widget.initialValue && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.collapsed(offset: widget.initialValue.length);
    }
  }

  void _onTextChanged(String? text) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      margin: widget.margin,
      child: TextInput(
        controller: _controller,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        onChanged: _onTextChanged,
        onSubmitted: (String text) {
          _debounce?.cancel();
          widget.onChanged?.call(text);
          widget.onSubmitted?.call(text);
        },
      ),
    );
}
