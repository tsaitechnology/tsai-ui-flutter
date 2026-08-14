import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class BottomSheetDemo extends StatefulWidget {
  const BottomSheetDemo({super.key});

  @override
  State<BottomSheetDemo> createState() => _BottomSheetDemoState();
}

class _BottomSheetDemoState extends State<BottomSheetDemo> {
  TsaiBottomSheetSize _size = TsaiBottomSheetSize.content;
  bool _showCloseButton = false;
  String _result = 'No result';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const ValueKey<String>('bottom-sheet-demo'),
    padding: const EdgeInsets.all(24),
    child: ComponentPlayground(
      controls: [
        PlaygroundSelectControl<TsaiBottomSheetSize>(
          label: 'size',
          value: _size,
          values: TsaiBottomSheetSize.values,
          onChanged: (value) => setState(() => _size = value),
        ),
        PlaygroundToggleControl(
          label: 'showCloseButton',
          value: _showCloseButton,
          onChanged: (value) => setState(() => _showCloseButton = value),
        ),
        TsaiButton(
          label: 'Open modal sheet',
          onPressed: () => _openSheet(context),
        ),
        PlaygroundOutput(label: 'result', value: _result),
      ],
      preview: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 424),
        child: TsaiBottomSheet(
          title: 'Title',
          size: _size,
          showCloseButton: _showCloseButton,
          secondaryAction: TsaiButton(
            label: 'Cancel',
            variant: TsaiButtonVariant.secondary,
            onPressed: () {},
          ),
          primaryAction: TsaiButton(label: 'Confirm', onPressed: () {}),
          child: const SizedBox(
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x14111111),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _openSheet(BuildContext context) async {
    final result = await showTsaiBottomSheet<String>(
      context: context,
      title: 'Title',
      size: _size,
      showCloseButton: _showCloseButton,
      child: const SizedBox(
        height: 80,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0x14111111),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      secondaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Cancel',
          variant: TsaiButtonVariant.secondary,
          onPressed: () => Navigator.of(sheetContext).pop('cancelled'),
        ),
      ),
      primaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Confirm',
          onPressed: () => Navigator.of(sheetContext).pop('confirmed'),
        ),
      ),
    );
    if (mounted) {
      setState(() => _result = result ?? 'dismissed');
    }
  }
}
