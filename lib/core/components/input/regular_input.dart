import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasirsuper/core/core.dart';

class RegularTextInput extends StatelessWidget {
  const RegularTextInput(
      {super.key,
      required this.hintText,
      this.controller,
      this.enabled = true,
      this.inputFormatters,
      this.maxLength,
      this.maxLines,
      this.minLines,
      this.prefixIcon,
      this.label,
      this.required = false,
      this.onChanged,
      this.suffix,
      this.keyboardType,
      this.hintStyle,
      this.border,
      this.obscureText = false,
      this.validator});

  final String hintText;
  final TextEditingController? controller;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final IconData? prefixIcon;
  final String? label;
  final bool required;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          LabelInput(label: label, required: required),
          Dimens.dp8.height,
        ],
        TextFormField(
          controller: controller,
          enabled: enabled,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            hintText: hintText,
            hintStyle: hintStyle,
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.green), // Default border
                ),
            enabledBorder: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.green), // Border saat tidak fokus
                ),
            focusedBorder: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: AppColors.green[800]!,
                      width: 2.0), // Border saat fokus
                ),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
