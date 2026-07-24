import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';

/// Presentation used when a [TsaiSelect] opens.
enum TsaiSelectPresentation {
  /// Uses a web/desktop menu, Android bottom sheet, or iOS picker.
  adaptive,

  /// Uses an anchored Flutter menu suited to web and desktop.
  menu,

  /// Uses a Material modal bottom sheet suited to Android.
  bottomSheet,

  /// Uses a modal [CupertinoPicker] suited to iOS.
  cupertinoPicker,
}

/// A selectable value shown by [TsaiSelect].
@immutable
final class TsaiSelectOption<T> {
  /// Creates a select option.
  const TsaiSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// Value delivered to [TsaiSelect.onChanged].
  final T value;

  /// Visible option label.
  final String label;

  /// Optional leading icon.
  final TsaiIcon? icon;

  /// Whether this option can be selected.
  final bool enabled;
}

/// A controlled generic select matching the Penpot Select component.
///
/// The menu is displayed in an overlay and does not change the field's
/// 56-pixel visual height. Set [onChanged] to null to disable the component.
class TsaiSelect<T> extends StatefulWidget {
  /// Creates a Tsai select.
  const TsaiSelect({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.placeholder,
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.showClearButton = true,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onOpen,
    this.onClose,
    this.semanticLabel,
    this.menuMaxHeight = 320,
    this.presentation = TsaiSelectPresentation.adaptive,
  }) : assert(menuMaxHeight > 0);

  /// Available menu options.
  final List<TsaiSelectOption<T>> options;

  /// Currently selected value.
  final T? value;

  /// Called with a selected value or null when cleared.
  final ValueChanged<T?>? onChanged;

  /// Text displayed as a placeholder and, when [labeledPlaceholder] is true,
  /// as a floating label while a value is selected.
  final String? placeholder;

  /// Whether [placeholder] floats above a selected value.
  ///
  /// When false, the placeholder and selected value remain vertically centered.
  final bool labeledPlaceholder;

  /// Supporting text displayed below the field.
  final String? description;

  /// Error text displayed below the field.
  ///
  /// When non-null, the field and label use the error color.
  final String? errorText;

  /// Whether to show a clear action for a selected value.
  final bool showClearButton;

  /// Whether the field requests focus initially.
  final bool autofocus;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Called when keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called after the menu opens.
  final VoidCallback? onOpen;

  /// Called after the menu closes.
  final VoidCallback? onClose;

  /// Optional accessibility label replacing [label].
  final String? semanticLabel;

  /// Maximum menu height before it scrolls.
  final double menuMaxHeight;

  /// How the option list is presented.
  final TsaiSelectPresentation presentation;

  @override
  State<TsaiSelect<T>> createState() => _TsaiSelectState<T>();
}

class _TsaiSelectState<T> extends State<TsaiSelect<T>> {
  final MenuController _menuController = MenuController();
  FocusNode? _internalFocusNode;
  bool _focused = false;
  bool _hovered = false;
  bool _open = false;
  bool _revealSelectedValue = true;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  TsaiSelectOption<T>? get _selectedOption {
    for (final option in widget.options) {
      if (option.value == widget.value) {
        return option;
      }
    }
    return null;
  }

  bool get _enabled => widget.onChanged != null;

  TsaiSelectPresentation get _resolvedPresentation {
    if (widget.presentation != TsaiSelectPresentation.adaptive) {
      return widget.presentation;
    }
    if (kIsWeb) {
      return TsaiSelectPresentation.menu;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => TsaiSelectPresentation.bottomSheet,
      TargetPlatform.iOS => TsaiSelectPresentation.cupertinoPicker,
      _ => TsaiSelectPresentation.menu,
    };
  }

  @override
  void didUpdateWidget(covariant TsaiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == null && widget.value != null) {
      _revealSelectedValue = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.value == null) {
          return;
        }
        setState(() => _revealSelectedValue = true);
      });
    } else {
      _revealSelectedValue = true;
    }
    if (oldWidget.focusNode != widget.focusNode && widget.focusNode != null) {
      _internalFocusNode?.dispose();
      _internalFocusNode = null;
    }
    if (_open &&
        !_enabled &&
        _resolvedPresentation == TsaiSelectPresentation.menu) {
      _menuController.close();
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      key: const ValueKey<String>('tsai-select-layout'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuAnchor(
          controller: _menuController,
          childFocusNode: _focusNode,
          crossAxisUnconstrained: false,
          consumeOutsideTap: false,
          onOpen: _handleOpen,
          onClose: _handleClose,
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(
              tokens.colors.surfaceRaised,
            ),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            shadowColor: WidgetStatePropertyAll(tokens.shadows.soft.color),
            elevation: const WidgetStatePropertyAll(8),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: tokens.spacing.space8),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.radii.medium),
                side: BorderSide(
                  color: tokens.colors.borderSubtle,
                  width: tokens.borders.hairline,
                ),
              ),
            ),
            maximumSize: WidgetStatePropertyAll(
              Size(double.infinity, widget.menuMaxHeight),
            ),
          ),
          menuChildren: [
            for (final option in widget.options) _buildOption(context, option),
          ],
          builder: (context, controller, child) => _buildAnchor(context),
        ),
        if (widget.description != null || widget.errorText != null) ...[
          SizedBox(height: tokens.spacing.space4),
          Padding(
            padding: EdgeInsetsDirectional.only(start: tokens.spacing.space4),
            child: Text(
              widget.errorText ?? widget.description!,
              key: const ValueKey<String>('tsai-select-description'),
              style: tokens.typography.captionMediumRegular.copyWith(
                color: widget.errorText == null
                    ? tokens.colors.contentSecondary
                    : tokens.colors.negative,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnchor(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final selected = _selectedOption;
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? colors.negative
        : _focused || _open
        ? colors.actionPrimarySoft
        : _hovered && _enabled
        ? colors.borderStrong
        : colors.borderSubtle;
    final field = AnimatedContainer(
      key: const ValueKey<String>('tsai-select-field'),
      duration: _duration(context, tokens),
      height: 56,
      padding: EdgeInsetsDirectional.only(
        start: tokens.spacing.space16,
        end: tokens.spacing.space8,
      ),
      decoration: BoxDecoration(
        color: _enabled ? colors.surface : colors.surfaceRaised,
        borderRadius: BorderRadius.circular(tokens.radii.medium),
        border: Border.all(color: borderColor, width: tokens.borders.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SelectContent(
              placeholder: widget.placeholder,
              selected: selected,
              floating:
                  widget.labeledPlaceholder &&
                  widget.placeholder != null &&
                  selected != null,
              revealSelectedValue: _revealSelectedValue,
              enabled: _enabled,
              hasError: hasError,
            ),
          ),
          if (selected != null && widget.showClearButton && _enabled)
            _SelectIconButton(
              key: const ValueKey<String>('tsai-select-clear'),
              tooltip: 'Clear selection',
              icon: const TsaiIcon(LucideIcons.x, size: 16),
              color: colors.iconSecondary,
              onPressed: _clear,
            ),
          SizedBox.square(
            dimension: 32,
            child: Center(
              child: AnimatedRotation(
                duration: _duration(context, tokens),
                turns: _open ? 0.5 : 0,
                child: TsaiIcon(
                  LucideIcons.chevron_down,
                  key: const ValueKey<String>('tsai-select-chevron'),
                  size: 20,
                  color: _enabled ? colors.iconSecondary : colors.iconTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Semantics(
      button: true,
      enabled: _enabled,
      expanded: _open,
      label: widget.semanticLabel ?? widget.placeholder,
      value: selected?.label ?? widget.placeholder,
      onTap: _enabled ? _activate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _enabled,
        autofocus: widget.autofocus,
        focusNode: _focusNode,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onFocusChange: (value) {
          if (_focused == value) {
            return;
          }
          setState(() => _focused = value);
          widget.onFocusChange?.call(value);
        },
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.arrowDown): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? _activate : null,
          child: field,
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, TsaiSelectOption<T> option) {
    final tokens = TsaiThemeTokens.of(context);
    final selected = option.value == widget.value;
    return MenuItemButton(
      key: ValueKey<Object?>((TsaiSelect<T>, option.value)),
      onPressed: option.enabled ? () => _select(option.value) : null,
      leadingIcon: option.icon,
      trailingIcon: selected
          ? Icon(
              LucideIcons.check,
              size: 16,
              color: tokens.colors.actionPrimary,
            )
          : null,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? tokens.colors.contentTertiary
              : tokens.colors.contentPrimary,
        ),
        textStyle: WidgetStatePropertyAll(tokens.typography.bodyMedium),
        minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
        ),
      ),
      child: Text(option.label),
    );
  }

  void _activate() {
    if (!_enabled) {
      return;
    }
    _focusNode.requestFocus();
    if (_open && _resolvedPresentation != TsaiSelectPresentation.menu) {
      return;
    }
    switch (_resolvedPresentation) {
      case TsaiSelectPresentation.adaptive:
        throw StateError('Adaptive presentation must resolve before opening.');
      case TsaiSelectPresentation.menu:
        _toggleMenu();
      case TsaiSelectPresentation.bottomSheet:
        unawaited(_showBottomSheet());
      case TsaiSelectPresentation.cupertinoPicker:
        unawaited(_showCupertinoPicker());
    }
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  void _handleOpen() {
    if (!mounted) {
      return;
    }
    setState(() => _open = true);
    widget.onOpen?.call();
  }

  Future<void> _showBottomSheet() async {
    _handleOpen();
    try {
      final selected = await showModalBottomSheet<TsaiSelectOption<T>>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: widget.menuMaxHeight),
        builder: (context) {
          final tokens = TsaiThemeTokens.of(context);
          return SafeArea(
            child: ListView(
              key: const ValueKey<String>('tsai-select-bottom-sheet'),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: tokens.spacing.space8),
              children: [
                for (final option in widget.options)
                  ListTile(
                    enabled: option.enabled,
                    leading: option.icon,
                    title: Text(
                      option.label,
                      style: tokens.typography.bodyLarge.copyWith(
                        color: option.enabled
                            ? tokens.colors.contentPrimary
                            : tokens.colors.contentTertiary,
                      ),
                    ),
                    trailing: option.value == widget.value
                        ? Icon(
                            LucideIcons.check,
                            size: 20,
                            color: tokens.colors.actionPrimary,
                          )
                        : null,
                    onTap: option.enabled
                        ? () => Navigator.of(context).pop(option)
                        : null,
                  ),
              ],
            ),
          );
        },
      );
      if (selected != null) {
        widget.onChanged?.call(selected.value);
      }
    } finally {
      _handleClose();
      _focusNode.requestFocus();
    }
  }

  Future<void> _showCupertinoPicker() async {
    var selectedIndex = _initialPickerIndex();
    _handleOpen();
    try {
      final selected = await showCupertinoModalPopup<TsaiSelectOption<T>>(
        context: context,
        builder: (context) {
          final tokens = TsaiThemeTokens.of(context);
          final background = CupertinoDynamicColor.resolve(
            CupertinoColors.systemBackground,
            context,
          );
          return StatefulBuilder(
            builder: (context, setModalState) => ColoredBox(
              color: background,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  key: const ValueKey<String>('tsai-select-cupertino-picker'),
                  height: 300,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            CupertinoButton(
                              onPressed:
                                  widget.options.isNotEmpty &&
                                      widget.options[selectedIndex].enabled
                                  ? () => Navigator.of(
                                      context,
                                    ).pop(widget.options[selectedIndex])
                                  : null,
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: widget.options.isEmpty
                            ? Center(
                                child: Text(
                                  'No options',
                                  style: tokens.typography.bodyLarge.copyWith(
                                    color: tokens.colors.contentTertiary,
                                  ),
                                ),
                              )
                            : CupertinoPicker(
                                itemExtent: 44,
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedIndex,
                                ),
                                onSelectedItemChanged: (index) =>
                                    setModalState(() => selectedIndex = index),
                                children: [
                                  for (final option in widget.options)
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (option.icon != null) ...[
                                            option.icon!,
                                            SizedBox(
                                              width: tokens.spacing.space8,
                                            ),
                                          ],
                                          Text(
                                            option.label,
                                            style: tokens.typography.bodyLarge
                                                .copyWith(
                                                  color: option.enabled
                                                      ? tokens
                                                            .colors
                                                            .contentPrimary
                                                      : tokens
                                                            .colors
                                                            .contentTertiary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
      if (selected != null) {
        widget.onChanged?.call(selected.value);
      }
    } finally {
      _handleClose();
      _focusNode.requestFocus();
    }
  }

  int _initialPickerIndex() {
    final selected = widget.options.indexWhere(
      (option) => option.value == widget.value && option.enabled,
    );
    if (selected >= 0) {
      return selected;
    }
    final firstEnabled = widget.options.indexWhere((option) => option.enabled);
    return firstEnabled < 0 ? 0 : firstEnabled;
  }

  void _handleClose() {
    if (!mounted) {
      return;
    }
    setState(() => _open = false);
    widget.onClose?.call();
  }

  void _select(T value) {
    widget.onChanged?.call(value);
    _menuController.close();
    _focusNode.requestFocus();
  }

  void _clear() {
    widget.onChanged?.call(null);
    _focusNode.requestFocus();
  }
}

class _SelectContent<T> extends StatelessWidget {
  const _SelectContent({
    required this.placeholder,
    required this.selected,
    required this.floating,
    required this.revealSelectedValue,
    required this.enabled,
    required this.hasError,
  });

  final String? placeholder;
  final TsaiSelectOption<T>? selected;
  final bool floating;
  final bool revealSelectedValue;
  final bool enabled;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final duration = _placeholderDuration(context, tokens);
    return Stack(
      key: const ValueKey<String>('tsai-select-content'),
      fit: StackFit.expand,
      children: [
        if (placeholder != null)
          IgnorePointer(
            child: AnimatedOpacity(
              duration: duration,
              opacity: selected == null || floating ? 1 : 0,
              child: AnimatedAlign(
                key: const ValueKey<String>('tsai-select-placeholder-position'),
                duration: duration,
                curve: Curves.easeInOutCubic,
                alignment: floating
                    ? const AlignmentDirectional(-1, -0.45)
                    : AlignmentDirectional.centerStart,
                child: AnimatedDefaultTextStyle(
                  key: const ValueKey<String>('tsai-select-placeholder'),
                  duration: duration,
                  curve: Curves.easeInOutCubic,
                  style:
                      (floating
                              ? tokens.typography.captionMediumRegular
                              : tokens.typography.bodyLarge)
                          .copyWith(
                            color: !enabled
                                ? colors.contentTertiary
                                : hasError && floating
                                ? colors.negative
                                : floating
                                ? colors.contentSecondary
                                : colors.contentTertiary,
                          ),
                  child: Text(
                    placeholder!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        if (selected != null)
          AnimatedOpacity(
            key: const ValueKey<String>('tsai-select-value-opacity'),
            duration: duration,
            curve: Curves.easeOutCubic,
            opacity: revealSelectedValue ? 1 : 0,
            child: AnimatedAlign(
              key: const ValueKey<String>('tsai-select-value-position'),
              duration: duration,
              curve: Curves.easeInOutCubic,
              alignment: floating
                  ? const AlignmentDirectional(-1, 0.45)
                  : AlignmentDirectional.centerStart,
              child: Row(
                key: const ValueKey<String>('tsai-select-value-row'),
                children: [
                  if (selected?.icon != null) ...[
                    selected!.icon!,
                    SizedBox(width: tokens.spacing.space8),
                  ],
                  Expanded(
                    child: Text(
                      selected!.label,
                      key: const ValueKey<String>('tsai-select-value'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.bodyLarge.copyWith(
                        color: enabled
                            ? colors.contentPrimary
                            : colors.contentTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SelectIconButton extends StatelessWidget {
  const _SelectIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final TsaiIcon icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: IconTheme.merge(
      data: IconThemeData(color: color),
      child: icon,
    ),
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
    splashRadius: 16,
  );
}

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;

Duration _placeholderDuration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction * 1.5;
