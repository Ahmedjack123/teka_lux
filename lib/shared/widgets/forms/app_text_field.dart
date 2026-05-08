import 'package:flutter/material.dart';

import '../../../core/theming/theming.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.borderRadius,
    this.fillColor,
    this.contentPadding,
    super.key,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double? borderRadius;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final radiusValue = borderRadius ?? AppSizes.radiusMd;
    final border = AppInputStyles.border(radius: radiusValue);

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        fillColor: fillColor,
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border,
        enabledBorder: border,
        labelStyle: AppTextStyles.label.copyWith(
          color: AppColors.textSecondary,
        ),
        helperStyle: AppTextStyles.caption,
        counterStyle: AppTextStyles.caption,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          borderSide: BorderSide.none,
        ),
        focusedBorder: AppInputStyles.border(
          radius: radiusValue,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
        errorBorder: AppInputStyles.border(
          radius: radiusValue,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: AppInputStyles.border(
          radius: radiusValue,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
    );
  }
}
