import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';

/// A compact single-line search field matching the Penpot Input Search states.
class TsaiSearchInput extends StatefulWidget {
  /// Creates a Tsai search input.
  const TsaiSearchInput({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder = 'Search',
    this.enabled = true,
    this.autofocus = false,
    this.showClearButton = true,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChange,
    this.onCleared,
    this.semanticLabel,
  }) : assert(controller == null || initialValue == null);

  /// Optional caller-owned text controller.
  final TextEditingController? controller;

  /// Initial query used when [controller] is null.
  final String? initialValue;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Hint displayed while the query is empty.
  final String placeholder;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether the field requests focus initially.
  final bool autofocus;

  /// Whether a non-empty query shows the clear action.
  final bool showClearButton;

  /// Called whenever the query changes.
  final ValueChanged<String>? onChanged;

  /// Called when the search action submits the query.
  final ValueChanged<String>? onSubmitted;

  /// Called when keyboard focus enters or leaves the field.
  final ValueChanged<bool>? onFocusChange;

  /// Called after the clear action removes the query.
  final VoidCallback? onCleared;

  /// Optional accessibility label for the editable query.
  final String? semanticLabel;

  @override
  State<TsaiSearchInput> createState() => _TsaiSearchInputState();
}

class _TsaiSearchInputState extends State<TsaiSearchInput> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(
        text: widget.initialValue,
      ));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
    _focused = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant TsaiSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleControllerChanged,
      );
      _internalController?.dispose();
      _internalController = null;
      _controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChanged,
      );
      _internalFocusNode?.dispose();
      _internalFocusNode = null;
      _focusNode.addListener(_handleFocusChanged);
      _focused = _focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final hasQuery = _controller.text.isNotEmpty;
    final showClear = widget.enabled && widget.showClearButton && hasQuery;
    return Semantics(
      container: true,
      textField: true,
      label: widget.semanticLabel ?? widget.placeholder,
      enabled: widget.enabled,
      child: AnimatedContainer(
        key: const ValueKey<String>('tsai-search-input-frame'),
        height: 40,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : tokens.motion.interaction,
        curve: tokens.motion.interactionCurve,
        padding: EdgeInsetsDirectional.only(
          start: tokens.spacing.space12,
          end: tokens.spacing.space8,
        ),
        decoration: BoxDecoration(
          color: widget.enabled ? colors.surface : colors.surfaceRaised,
          border: Border.all(
            color: _focused ? colors.actionPrimarySoft : colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
          borderRadius: BorderRadius.circular(tokens.radii.medium),
        ),
        child: Row(
          children: [
            TsaiIcon(LucideIcons.search, size: 20, color: colors.iconSecondary),
            SizedBox(width: tokens.spacing.space8),
            Expanded(
              child: TextField(
                key: const ValueKey<String>('tsai-search-input-editable'),
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                maxLines: 1,
                cursorHeight: 20,
                cursorWidth: 2,
                cursorColor: colors.actionPrimarySoft,
                style: tokens.typography.bodyLarge.copyWith(
                  color: colors.contentPrimary,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: widget.placeholder,
                  hintStyle: tokens.typography.bodyLarge.copyWith(
                    color: colors.contentTertiary,
                  ),
                ),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
              ),
            ),
            if (showClear)
              Tooltip(
                message: 'Clear search',
                child: IconButton(
                  key: const ValueKey<String>('tsai-search-input-clear'),
                  onPressed: _clear,
                  icon: const TsaiIcon(LucideIcons.x, size: 16),
                  color: colors.iconSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChanged() {
    if (_focused == _focusNode.hasFocus || !mounted) {
      return;
    }
    setState(() => _focused = _focusNode.hasFocus);
    widget.onFocusChange?.call(_focused);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }
}
