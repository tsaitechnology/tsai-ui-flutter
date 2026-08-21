import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({super.key, this.controller, this.physics});

  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  State<ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<ButtonDemo> {
  TsaiButtonSize _size = TsaiButtonSize.large;
  TsaiButtonVariant _variant = TsaiButtonVariant.primary;
  TsaiButtonTone _tone = TsaiButtonTone.standard;
  String _label = 'Button';
  bool _enabled = true;
  bool _showIcon = true;
  bool _isLoading = false;
  bool _isExpanded = false;
  int _pressCount = 0;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('button-demo'),
    controller: widget.controller,
    physics: widget.physics,
    padding: EdgeInsets.all(TsaiThemeTokens.of(context).spacing.space24),
    children: [
      ComponentPlayground(
        controls: [
          PlaygroundTextControl(
            label: 'label',
            value: _label,
            onChanged: (value) => setState(() => _label = value),
          ),
          PlaygroundSelectControl<TsaiButtonVariant>(
            label: 'variant',
            value: _variant,
            values: TsaiButtonVariant.values,
            onChanged: (value) => setState(() => _variant = value),
          ),
          PlaygroundSelectControl<TsaiButtonSize>(
            label: 'size',
            value: _size,
            values: TsaiButtonSize.values,
            onChanged: (value) => setState(() => _size = value),
          ),
          PlaygroundSelectControl<TsaiButtonTone>(
            label: 'tone',
            value: _tone,
            values: TsaiButtonTone.values,
            onChanged: (value) => setState(() => _tone = value),
          ),
          PlaygroundToggleControl(
            label: 'enabled',
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          PlaygroundToggleControl(
            label: 'Leading icon',
            value: _showIcon,
            onChanged: (value) => setState(() => _showIcon = value),
          ),
          PlaygroundToggleControl(
            label: 'Loading',
            value: _isLoading,
            onChanged: (value) => setState(() => _isLoading = value),
          ),
          PlaygroundToggleControl(
            label: 'Full width',
            value: _isExpanded,
            onChanged: (value) => setState(() => _isExpanded = value),
          ),
          PlaygroundOutput(
            label: 'Press count',
            value: 'Called $_pressCount times',
          ),
        ],
        preview: TsaiButton(
          label: _label,
          variant: _variant,
          tone: _tone,
          size: _size,
          leadingIcon: _showIcon
              ? const TsaiIcon(LucideIcons.plus, size: 16)
              : null,
          isLoading: _isLoading,
          isExpanded: _isExpanded,
          onPressed: _enabled ? () => setState(() => _pressCount++) : null,
        ),
      ),
    ],
  );
}
