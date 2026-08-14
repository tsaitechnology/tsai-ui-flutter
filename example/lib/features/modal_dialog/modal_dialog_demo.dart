import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class ModalDialogDemo extends StatefulWidget {
  const ModalDialogDemo({super.key});

  @override
  State<ModalDialogDemo> createState() => _ModalDialogDemoState();
}

class _ModalDialogDemoState extends State<ModalDialogDemo> {
  TsaiModalDialogActionsLayout _layout = TsaiModalDialogActionsLayout.row;
  String _title = 'Title';
  String _message =
      'Message that explains what happens and what it means for the user.';
  String _result = 'No result';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const ValueKey<String>('modal-dialog-demo'),
    padding: const EdgeInsets.all(24),
    child: ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'title',
          value: _title,
          onChanged: (value) => setState(() => _title = value),
        ),
        PlaygroundTextControl(
          label: 'message',
          value: _message,
          onChanged: (value) => setState(() => _message = value),
        ),
        PlaygroundSelectControl<TsaiModalDialogActionsLayout>(
          label: 'actionsLayout',
          value: _layout,
          values: TsaiModalDialogActionsLayout.values,
          onChanged: (value) => setState(() => _layout = value),
        ),
        TsaiButton(label: 'Open modal dialog', onPressed: () => _open(context)),
        PlaygroundOutput(label: 'result', value: _result),
      ],
      preview: PlaygroundColorBackdrop(
        height: _layout == TsaiModalDialogActionsLayout.row ? 360 : 410,
        child: TsaiModalDialog(
          title: _title,
          message: _message,
          icon: const TsaiIcon(LucideIcons.bell),
          actionsLayout: _layout,
          secondaryAction: TsaiButton(
            label: 'Cancel',
            size: TsaiButtonSize.medium,
            variant: TsaiButtonVariant.secondary,
            onPressed: () {},
          ),
          primaryAction: TsaiButton(
            label: 'Confirm',
            size: TsaiButtonSize.medium,
            onPressed: () {},
          ),
        ),
      ),
    ),
  );

  Future<void> _open(BuildContext context) async {
    final result = await showTsaiModalDialog<String>(
      context: context,
      title: _title,
      message: _message,
      icon: const TsaiIcon(LucideIcons.bell),
      actionsLayout: _layout,
      secondaryAction: Builder(
        builder: (dialogContext) => TsaiButton(
          label: 'Cancel',
          size: TsaiButtonSize.medium,
          variant: TsaiButtonVariant.secondary,
          onPressed: () => Navigator.of(dialogContext).pop('cancelled'),
        ),
      ),
      primaryAction: Builder(
        builder: (dialogContext) => TsaiButton(
          label: 'Confirm',
          size: TsaiButtonSize.medium,
          onPressed: () => Navigator.of(dialogContext).pop('confirmed'),
        ),
      ),
    );
    if (mounted) {
      setState(() => _result = result ?? 'dismissed');
    }
  }
}
