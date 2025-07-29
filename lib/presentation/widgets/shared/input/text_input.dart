import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../../../../core/utils/device_util.dart';
import '../icon/custom_icon.dart';

class TextInput extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType? textInputType;
  final bool readOnly;
  final String? defaultValue;
  final FormFieldValidator<String>? validator;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool isObscure;
  final bool isEnabled;
  final String? prefixIcon;
  final String? suffixIcon;
  final Widget? suffixIconRaw;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String?>? onChanged;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? margin;
  final TextAlign textAlign;
  final AutovalidateMode? autoValidateMode;
  final String? errorText;

  const TextInput({
    this.labelText,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.textInputType = TextInputType.text,
    this.readOnly = false,
    this.defaultValue,
    this.validator,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.isObscure = false,
    this.isEnabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconRaw,
    this.focusNode,
    this.onSubmitted,
    this.onTap,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.textInputAction,
    this.inputFormatters,
    this.margin,
    this.autoValidateMode,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    child: TextFormField(
      key: key,
      textAlign: textAlign,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly,
      enabled: isEnabled,
      onTap: onTap,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      controller: controller,
      initialValue: controller == null ? defaultValue : null,
      keyboardType: textInputType,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      obscureText: isObscure,
      onSaved: onSaved,
      onChanged: onChanged,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        color: Color(0xFF2a2b2c),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: Color(0xFFB5B5B5),
        ),
        prefixIcon: prefixIcon != null ? _buildIcon(prefixIcon!) : null,
        suffixIcon: suffixIcon != null
            ? _buildIcon(suffixIcon!)
            : suffixIconRaw ?? _buildClearIcon(context),
        fillColor: const Color(0xFFEDEDED),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xFFB5B5B5),
        ),
        errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFF44336),
        ),
        contentPadding: const EdgeInsets.only(
          bottom: 4,
          top: 4,
          left: 16,
          right: 16,
        ),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFEDEDED),
            width: 4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFEDEDED),
            width: 1.5,
          ),
        ),
      ),
    ),
  );

  Widget _buildIcon(String icon, {Color? color, VoidCallback? onTap}) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: CustomIcon(
        icon,
        width: 14,
        height: 14,
        color: color ?? const Color(0xFFB5B5B5),
      ),
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: child) : child;
  }

  Widget? _buildClearIcon(BuildContext context) {
    if (controller == null || controller!.text.isEmpty) return null;

    return GestureDetector(
      onTap: () {
        controller!.clear();
        onChanged?.call('');
        DeviceUtils.hideKeyboard(context);
        onSubmitted?.call('');
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: const Icon(
          Icons.clear,
          size: 18,
          color: Color(0xFFB5B5B5),
        ),
      ),
    );
  }
}
