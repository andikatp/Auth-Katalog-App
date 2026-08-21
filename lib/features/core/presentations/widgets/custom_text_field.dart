import 'package:auth_katalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    super.key,
    this.title,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.border,
  });

  final String? title;
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor,
        contentPadding: contentPadding,
        border: border,
      ),
    );

    if (title == null) return textField;

    return Column(
      crossAxisAlignment: .start,
      spacing: 6,
      children: [
        Text(
          title!,
          style: context.bodyMedium.copyWith(
            fontWeight: .w600,
          ),
        ),
        textField,
      ],
    );
  }
}
