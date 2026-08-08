import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// Penpot-supported arrangements for modal dialog actions.
enum TsaiModalDialogActionsLayout {
  /// Places secondary and primary actions in one row.
  row,

  /// Places the primary action above the secondary action.
  stacked,
}

/// A focused Tsai modal dialog surface.
class TsaiModalDialog extends StatelessWidget {
  /// Creates a Tsai modal dialog.
  const TsaiModalDialog({
    required this.title,
    required this.message,
    required this.icon,
    super.key,
    this.primaryAction,
    this.secondaryAction,
    this.actionsLayout = TsaiModalDialogActionsLayout.row,
  });

  /// Dialog heading.
  final String title;

  /// Supporting explanation below [title].
  final String message;

  /// Icon centered inside the 48-pixel circular surface.
  final Widget icon;

  /// Optional primary action.
  final Widget? primaryAction;

  /// Optional lower-emphasis action.
  final Widget? secondaryAction;

  /// Arrangement of the supplied actions.
  final TsaiModalDialogActionsLayout actionsLayout;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: Material(
        key: const ValueKey<String>('tsai-modal-dialog-surface'),
        color: tokens.colors.surfaceGlass,
        elevation: 0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radii.extraLarge),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 320,
          padding: EdgeInsets.all(tokens.spacing.space24),
          decoration: BoxDecoration(
            border: Border.all(
              color: tokens.colors.borderSubtle,
              width: tokens.borders.hairline,
            ),
            borderRadius: BorderRadius.circular(tokens.radii.extraLarge),
            boxShadow: [tokens.shadows.soft],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                key: const ValueKey<String>('tsai-modal-dialog-icon'),
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tokens.colors.surfaceRaised,
                  shape: BoxShape.circle,
                ),
                child: icon,
              ),
              SizedBox(height: tokens.spacing.space8),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: tokens.typography.headingSmall.copyWith(
                    color: tokens.colors.contentPrimary,
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.space8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: tokens.typography.bodyMedium.copyWith(
                  color: tokens.colors.contentSecondary,
                ),
              ),
              if (primaryAction != null || secondaryAction != null) ...[
                SizedBox(height: tokens.spacing.space24),
                _DialogActions(
                  layout: actionsLayout,
                  primaryAction: primaryAction,
                  secondaryAction: secondaryAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a modal [TsaiModalDialog] and returns its Navigator result.
Future<T?> showTsaiModalDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  required Widget icon,
  Widget? primaryAction,
  Widget? secondaryAction,
  TsaiModalDialogActionsLayout actionsLayout = TsaiModalDialogActionsLayout.row,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
}) {
  final tokens = TsaiThemeTokens.of(context);
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: tokens.colors.overlayScrim,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    builder: (_) => Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
        child: TsaiModalDialog(
          title: title,
          message: message,
          icon: icon,
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
          actionsLayout: actionsLayout,
        ),
      ),
    ),
  );
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.layout,
    required this.primaryAction,
    required this.secondaryAction,
  });

  final TsaiModalDialogActionsLayout layout;
  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return switch (layout) {
      TsaiModalDialogActionsLayout.row => Row(
        key: const ValueKey<String>('tsai-modal-dialog-actions-row'),
        children: [
          if (secondaryAction case final action?) Expanded(child: action),
          if (secondaryAction != null && primaryAction != null)
            SizedBox(width: tokens.spacing.space12),
          if (primaryAction case final action?) Expanded(child: action),
        ],
      ),
      TsaiModalDialogActionsLayout.stacked => Column(
        key: const ValueKey<String>('tsai-modal-dialog-actions-stacked'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?primaryAction,
          if (secondaryAction != null && primaryAction != null)
            SizedBox(height: tokens.spacing.space8),
          ?secondaryAction,
        ],
      ),
    };
  }
}
