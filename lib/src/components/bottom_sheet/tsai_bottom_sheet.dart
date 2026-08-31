import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import '../effects/tsai_glow.dart';

/// Bottom-sheet sizing policies.
enum TsaiBottomSheetSize {
  /// Sizes the sheet to its content, up to the available viewport height.
  content(null),

  /// A 424-pixel sheet intended for focused, short workflows.
  half(424),

  /// A 784-pixel sheet intended for longer workflows.
  full(784);

  const TsaiBottomSheetSize(this.designHeight);

  /// Height of the corresponding fixed Penpot component, if any.
  final double? designHeight;
}

/// A composable Tsai bottom-sheet surface.
class TsaiBottomSheet extends StatelessWidget {
  /// Creates a Tsai bottom sheet.
  const TsaiBottomSheet({
    required this.title,
    required this.child,
    super.key,
    this.size = TsaiBottomSheetSize.content,
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

  /// Content placed between the app bar and actions.
  final Widget child;

  /// Sizing policy used when [height] is omitted. Defaults to content height.
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
    final hasFixedHeight = sheetHeight != null;
    final paddedChild = Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space24),
      child: child,
    );
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
            const Positioned(
              top: -280,
              left: 0,
              right: 0,
              child: Center(child: TsaiGlow()),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: tokens.spacing.space8,
                bottom: tokens.spacing.space32 + tokens.spacing.space8 + 2,
              ),
              child: Column(
                mainAxisSize: hasFixedHeight
                    ? MainAxisSize.max
                    : MainAxisSize.min,
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
                  if (hasFixedHeight)
                    Flexible(fit: FlexFit.tight, child: paddedChild)
                  else
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(child: paddedChild),
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
                end: tokens.spacing.space8,
                child: IconButton(
                  key: const ValueKey<String>('tsai-bottom-sheet-close'),
                  tooltip: 'Close',
                  onPressed: onClose,
                  icon: const TsaiIcon(LucideIcons.x, size: 24),
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
  TsaiBottomSheetSize size = TsaiBottomSheetSize.content,
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
  final designHeight = size.designHeight;
  final resolvedHeight = designHeight == null
      ? null
      : math.min(designHeight, availableHeight);
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    barrierColor: tokens.colors.overlayScrim,
    barrierLabel: barrierLabel,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxHeight: availableHeight),
    builder: (sheetContext) {
      final sheet = TsaiBottomSheet(
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
      );
      if (resolvedHeight != null) {
        return sheet;
      }
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: availableHeight),
          child: sheet,
        ),
      );
    },
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
                SizedBox(width: 72, child: _SheetEdge(children: leading)),
                const Spacer(),
                SizedBox(
                  width: 72,
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
