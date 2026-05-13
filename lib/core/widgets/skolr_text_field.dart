import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// A styled text input with floating label, clear button, error state,
/// and optional prefix/suffix icon slots.
///
/// Usage:
/// ```dart
/// SkolrTextField(
///   label: 'Student Name',
///   controller: _nameCtrl,
///   prefixIcon: const Icon(Icons.person_outline_rounded),
///   onChanged: (v) => setState(() => _name = v),
/// )
///
/// SkolrTextField(
///   label: 'Phone Number',
///   keyboardType: TextInputType.phone,
///   error: 'Enter a valid 10-digit number',
/// )
/// ```
class SkolrTextField extends StatefulWidget {
  const SkolrTextField({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.helper,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.showClearButton = true,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.maxLines = 1,
    this.autofocus = false,
  });

  final String? label;
  final String? hint;
  final String? error;
  final String? helper;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool showClearButton;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final bool autofocus;

  @override
  State<SkolrTextField> createState() => _SkolrTextFieldState();
}

class _SkolrTextFieldState extends State<SkolrTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscured = true;
  bool _hasText = false;

  bool get _ownsController => widget.controller == null;
  bool get _ownsFocusNode => widget.focusNode == null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;
    _obscured = widget.obscureText;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  Widget? _buildSuffix(ColorScheme cs) {
    // Custom suffix takes precedence
    if (widget.suffixIcon != null && !widget.obscureText) {
      return widget.suffixIcon;
    }

    // Obscure text: toggle visibility button
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: cs.onSurfaceVariant,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
        tooltip: _obscured ? 'Show' : 'Hide',
      );
    }

    // Clear button when text exists
    if (widget.showClearButton && _hasText && widget.enabled) {
      return IconButton(
        icon: Icon(Icons.close_rounded, size: 18, color: cs.onSurfaceVariant),
        onPressed: _clear,
        tooltip: 'Clear',
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasError = widget.error != null && widget.error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          // 56dp minimum touch target
          constraints: const BoxConstraints(minHeight: 56),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText && _obscured,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            autofocus: widget.autofocus,
            style: SkolrTypography.bodyLarge(color: cs.onSurface),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ),
                      child: widget.prefixIcon!,
                    )
                  : null,
              suffixIcon: _buildSuffix(cs),
              // Override error colors directly when we have an error
              enabledBorder: hasError
                  ? OutlineInputBorder(
                      borderRadius: SkolrRadius.md,
                      borderSide: BorderSide(color: cs.error),
                    )
                  : null,
              focusedBorder: hasError
                  ? OutlineInputBorder(
                      borderRadius: SkolrRadius.md,
                      borderSide: BorderSide(color: cs.error, width: 1.5),
                    )
                  : null,
            ),
            onChanged: widget.onChanged,
            onTap: widget.onTap,
          ),
        ),
        // Error / helper text slot — animated in
        AnimatedSize(
          duration: SkolrMotion.base,
          curve: SkolrMotion.decelerate,
          child: AnimatedSwitcher(
            duration: SkolrMotion.base,
            child: hasError
                ? Padding(
                    key: const ValueKey('error'),
                    padding: const EdgeInsets.only(
                      top: SkolrSpacing.xs,
                      left: SkolrSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            size: 12, color: cs.error),
                        const SizedBox(width: SkolrSpacing.xs),
                        Expanded(
                          child: Text(
                            widget.error!,
                            style: SkolrTypography.labelMedium(
                              color: cs.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.helper != null
                    ? Padding(
                        key: const ValueKey('helper'),
                        padding: const EdgeInsets.only(
                          top: SkolrSpacing.xs,
                          left: SkolrSpacing.lg,
                        ),
                        child: Text(
                          widget.helper!,
                          style: SkolrTypography.labelMedium(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('none')),
          ),
        ),
      ],
    );
  }
}
