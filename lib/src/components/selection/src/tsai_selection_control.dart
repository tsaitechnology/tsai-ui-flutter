part of '../tsai_selection_controls.dart';

typedef _ControlBuilder =
    Widget Function(BuildContext context, bool focused, bool hovered);

class _TsaiSelectionControl extends StatefulWidget {
  const _TsaiSelectionControl({
    required this.value,
    required this.enabled,
    required this.label,
    required this.description,
    required this.labelPosition,
    required this.autofocus,
    required this.focusNode,
    required this.onFocusChange,
    required this.semanticLabel,
    required this.onActivate,
    required this.controlBuilder,
    this.mutuallyExclusive = false,
    this.isSwitch = false,
    this.toggledSemanticValue,
  });

  final bool value;
  final bool enabled;
  final String? label;
  final String? description;
  final TsaiControlLabelPosition labelPosition;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final String? semanticLabel;
  final VoidCallback? onActivate;
  final _ControlBuilder controlBuilder;
  final bool mutuallyExclusive;
  final bool isSwitch;
  final String? toggledSemanticValue;

  @override
  State<_TsaiSelectionControl> createState() => _TsaiSelectionControlState();
}

class _TsaiSelectionControlState extends State<_TsaiSelectionControl> {
  bool _focused = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final control = widget.controlBuilder(context, _focused, _hovered);
    final content = widget.label == null && widget.description == null
        ? null
        : _SelectionContent(
            label: widget.label,
            description: widget.description,
            enabled: widget.enabled,
          );
    final row = LayoutBuilder(
      builder: (context, constraints) => Row(
        key: const ValueKey<String>('tsai-selection-row'),
        mainAxisSize: constraints.hasBoundedWidth
            ? MainAxisSize.max
            : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.labelPosition == TsaiControlLabelPosition.right
            ? [
                control,
                if (content != null) ...[
                  SizedBox(width: tokens.spacing.space8),
                  Flexible(child: content),
                ],
              ]
            : [
                if (content != null) ...[
                  Flexible(child: content),
                  SizedBox(width: tokens.spacing.space8),
                ],
                control,
              ],
      ),
    );
    return Semantics(
      container: true,
      enabled: widget.enabled,
      checked: widget.isSwitch ? null : widget.value,
      toggled: widget.isSwitch ? widget.value : null,
      inMutuallyExclusiveGroup: widget.mutuallyExclusive,
      label: widget.semanticLabel ?? widget.label,
      value: widget.toggledSemanticValue,
      onTap: widget.enabled ? widget.onActivate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        mouseCursor: widget.enabled
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
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onActivate?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? widget.onActivate : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionContent extends StatelessWidget {
  const _SelectionContent({
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String? label;
  final String? description;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final color = enabled
        ? tokens.colors.contentPrimary
        : tokens.colors.contentTertiary;
    return Padding(
      padding: EdgeInsets.only(top: tokens.spacing.space2),
      child: Column(
        key: const ValueKey<String>('tsai-selection-content'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: tokens.typography.bodyMedium.copyWith(color: color),
            ),
          if (description != null) ...[
            SizedBox(height: tokens.spacing.space2),
            Text(
              description!,
              style: tokens.typography.captionMediumRegular.copyWith(
                color: enabled
                    ? tokens.colors.contentSecondary
                    : tokens.colors.contentTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;
