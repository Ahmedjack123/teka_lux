import 'package:flutter/material.dart';

import '../../../core/theming/theming.dart';

/// Optimized text field for auth screens.
/// Uses [TextField] (not TextFormField) for better performance.
/// Error display is handled externally via [errorText].
class ArchiveTextField extends StatefulWidget {
  const ArchiveTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.obscureText = false,
    this.boxed = false,
    this.trailingLabel,
    this.onTrailingPressed,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool obscureText;
  final bool boxed;
  final String? trailingLabel;
  final VoidCallback? onTrailingPressed;

  @override
  State<ArchiveTextField> createState() => _ArchiveTextFieldState();
}

class _ArchiveTextFieldState extends State<ArchiveTextField> {
  bool _obscured = false;

  void _toggleObscured() {
    setState(() => _obscured = !_obscured);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppAuthPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label row
        _LabelRow(
          label: widget.label,
          trailingLabel: widget.trailingLabel,
          onTrailingPressed: widget.onTrailingPressed,
          mutedColor: palette.muted,
        ),
        const SizedBox(height: AppSizes.xs),
        // Text field
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText && _obscured,
          enabled: widget.enabled,
          cursorColor: palette.accent,
          style: AppTextStyles.bodyLg.copyWith(
            color: palette.text,
            fontSize: 16,
            height: 1.3,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            filled: true,
            fillColor: widget.boxed ? palette.surface : Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.boxed ? AppSizes.md : 0,
              vertical: widget.boxed ? AppSizes.sm : AppSizes.xs,
            ),
            hintStyle: AppTextStyles.bodyLg.copyWith(
              color: palette.faint,
              fontSize: 16,
              letterSpacing: widget.boxed ? 0 : 0.8,
            ),
            errorStyle: AppTextStyles.caption.copyWith(
              color: palette.error,
              height: 1.3,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: _toggleObscured,
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: palette.faint,
                      size: 20,
                    ),
                  )
                : null,
            border: _border(palette),
            enabledBorder: _border(palette),
            focusedBorder: _border(
              palette,
              color: widget.boxed ? palette.text : palette.accent,
              width: widget.boxed ? 1.4 : 2,
            ),
            errorBorder: _border(palette, color: palette.error, width: 1.2),
            focusedErrorBorder:
                _border(palette, color: palette.error, width: 1.4),
          ),
        ),
      ],
    );
  }

  InputBorder _border(
    AppAuthPalette palette, {
    Color? color,
    double width = 1,
  }) {
    final side = BorderSide(color: color ?? palette.line, width: width);

    if (widget.boxed) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: side,
      );
    }

    return UnderlineInputBorder(borderSide: side);
  }
}

/// Extracted label row to minimize rebuild scope.
class _LabelRow extends StatelessWidget {
  const _LabelRow({
    required this.label,
    this.trailingLabel,
    this.onTrailingPressed,
    required this.mutedColor,
  });

  final String label;
  final String? trailingLabel;
  final VoidCallback? onTrailingPressed;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: mutedColor,
              fontSize: 12,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailingLabel != null)
          TextButton(
            onPressed: onTrailingPressed,
            style: TextButton.styleFrom(
              foregroundColor: mutedColor,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              trailingLabel!.toUpperCase(),
              style: AppTextStyles.label.copyWith(
                color: mutedColor,
                fontSize: 11,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
