import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import '../effects/tsai_glow.dart';

/// Penpot-supported bottom-sheet heights.
enum TsaiBottomSheetSize {
  /// A 424-pixel sheet intended for focused, short workflows.
  half(424),

  /// A 784-pixel sheet intended for longer workflows.
  full(784);

  const TsaiBottomSheetSize(this.designHeight);

  /// Height of the corresponding Penpot component.
  final double designHeight;
}

/// A composable Tsai bottom-sheet surface.
class TsaiBottomSheet extends StatelessWidget {
  /// Creates a Tsai bottom sheet.
  const TsaiBottomSheet({
    required this.title,
    required this.child,
    super.key,
    this.size = TsaiBottomSheetSize.half,
    this.height,
    this.leading = const [],
    this.trailing = const [],
    this.secondaryAction,
    this.primaryAction,
    this.showCloseButton = false,
    this.onClose,
  }) : assert(height == null || height > 0);

  /// Centered sheet title.
  final String title;

  /// Content that expands between the app bar and actions.
  final Widget child;

  /// Penpot height variant used when [height] is omitted.
  final TsaiBottomSheetSize size;

  /// Optional explicit height for constrained or adaptive hosts.
  final double? height;

  /// Widgets placed at the app bar's directional start.
  final List<Widget> leading;

  /// Widgets placed at the app bar's directional end.
  final List<Widget> trailing;

  /// Optional lower-emphasis action.
  final Widget? secondaryAction;

  /// Optional primary action.
  final Widget? primaryAction;

  /// Whether to show a close action over the top-right edge.
  final bool showCloseButton;

  /// Called by the close action.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final sheetHeight = height ?? size.designHeight;
    return SizedBox(
      height: sheetHeight,
      width: double.infinity,
      child: Material(
        key: const ValueKey<String>('tsai-bottom-sheet-surface'),
        color: tokens.colors.canvas,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.radii.extraExtraLarge),
        ),
        child: Stack(
          children: [
            const PositionedDirectional(
              top: -280,
              start: -45,
              child: TsaiGlow(),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: tokens.spacing.space8,
                bottom: tokens.spacing.space32,
              ),
              child: Column(
                children: [
                  Container(
                    key: const ValueKey<String>('tsai-bottom-sheet-grabber'),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: tokens.colors.borderStrong,
                      borderRadius: BorderRadius.circular(tokens.radii.pill),
                    ),
                  ),
                  _SheetAppBar(
                    title: title,
                    leading: leading,
                    trailing: trailing,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spacing.space24,
                      ),
                      child: child,
                    ),
                  ),
                  if (secondaryAction != null || primaryAction != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: tokens.spacing.space32,
                        left: tokens.spacing.space24,
                        right: tokens.spacing.space24,
                      ),
                      child: Row(
                        key: const ValueKey<String>(
                          'tsai-bottom-sheet-actions',
                        ),
                        children: [
                          if (secondaryAction case final action?)
                            Expanded(child: action),
                          if (secondaryAction != null && primaryAction != null)
                            SizedBox(width: tokens.spacing.space12),
                          if (primaryAction case final action?)
                            Expanded(child: action),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (showCloseButton)
              PositionedDirectional(
                top: tokens.spacing.space16,
                end: tokens.spacing.space16,
                child: IconButton(
                  key: const ValueKey<String>('tsai-bottom-sheet-close'),
                  tooltip: 'Close',
                  onPressed: onClose,
                  icon: const TsaiIcon(LucideIcons.x, size: 20),
                  color: tokens.colors.iconSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows a modal [TsaiBottomSheet] and returns the value passed to Navigator.
Future<T?> showTsaiBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  TsaiBottomSheetSize size = TsaiBottomSheetSize.half,
  List<Widget> leading = const [],
  List<Widget> trailing = const [],
  Widget? secondaryAction,
  Widget? primaryAction,
  bool? showCloseButton,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  String? barrierLabel,
}) {
  final tokens = TsaiThemeTokens.of(context);
  final mediaQuery = MediaQuery.of(context);
  final availableHeight =
      mediaQuery.size.height -
      mediaQuery.padding.top -
      mediaQuery.viewInsets.bottom;
  final resolvedHeight = math.min(size.designHeight, availableHeight);
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    barrierColor: tokens.colors.overlayScrim,
    barrierLabel: barrierLabel,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxHeight: resolvedHeight),
    builder: (sheetContext) => TsaiBottomSheet(
      title: title,
      size: size,
      height: resolvedHeight,
      leading: leading,
      trailing: trailing,
      secondaryAction: secondaryAction,
      primaryAction: primaryAction,
      showCloseButton: showCloseButton ?? size == TsaiBottomSheetSize.full,
      onClose: () => Navigator.of(sheetContext).pop(),
      child: child,
    ),
  );
}

class _SheetAppBar extends StatelessWidget {
  const _SheetAppBar({
    required this.title,
    required this.leading,
    required this.trailing,
  });

  final String title;
  final List<Widget> leading;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
            child: Row(
              children: [
                Expanded(child: _SheetEdge(children: leading)),
                const SizedBox(width: 120),
                Expanded(
                  child: _SheetEdge(
                    alignment: MainAxisAlignment.end,
                    children: trailing,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            header: true,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.bodyLargeMedium.copyWith(
                color: tokens.colors.contentPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetEdge extends StatelessWidget {
  const _SheetEdge({
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final gap = TsaiThemeTokens.of(context).spacing.space8;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) SizedBox(width: gap),
          children[index],
        ],
      ],
    );
  }
}
