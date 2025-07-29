import 'package:flutter/material.dart';

class LabeledTextInput extends StatefulWidget {
  final String label;
  final bool isMandatory;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const LabeledTextInput({
    required this.label,
    this.isMandatory = false,
    this.hintText,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.validator,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  @override
  State<LabeledTextInput> createState() => _LabeledTextInputState();
}

class _LabeledTextInputState extends State<LabeledTextInput> {
  late final TextEditingController _internalController;
  bool get _usingInternalController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    if (_usingInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController = widget.controller ?? _internalController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            children: widget.isMandatory
                ? const <InlineSpan>[
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              )
            ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: effectiveController,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator ?? _defaultValidator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            counterText: '',
            errorText: widget.errorText,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (widget.isMandatory && (value == null || value.trim().isEmpty)) {
      return widget.errorText ?? '${widget.label} tidak boleh kosong';
    }
    return null;
  }
}
