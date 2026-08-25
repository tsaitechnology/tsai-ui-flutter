import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class AmountDisplayDemoScreen extends StatelessWidget {
  const AmountDisplayDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.amountDisplay,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _AmountDisplayDemo(),
  );
}

class _AmountDisplayDemo extends StatefulWidget {
  const _AmountDisplayDemo();

  @override
  State<_AmountDisplayDemo> createState() => _AmountDisplayDemoState();
}

class _AmountDisplayDemoState extends State<_AmountDisplayDemo> {
  var _alignment = TsaiAmountAlignment.start;
  var _caption = 'Total balance';
  var _value = r'$24,562.80';
  var _subtitle = '+2.2% this month';
  var _showCaption = true;
  var _showSubtitle = true;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('amountDisplay-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiAmountDisplay(
          alignment: _alignment,
          caption: _showCaption ? _caption : null,
          value: _value,
          subtitle: _showSubtitle ? _subtitle : null,
        ),
        controls: [
          PlaygroundRadioGroup<TsaiAmountAlignment>(
            label: 'alignment',
            value: _alignment,
            options: const [
              (TsaiAmountAlignment.start, 'Start'),
              (TsaiAmountAlignment.center, 'Center'),
            ],
            onChanged: (value) => setState(() => _alignment = value),
          ),
          PlaygroundToggleControl(
            label: 'caption',
            value: _showCaption,
            onChanged: (value) => setState(() => _showCaption = value),
          ),
          PlaygroundTextControl(
            label: 'caption text',
            value: _caption,
            onChanged: (value) => setState(() => _caption = value),
          ),
          PlaygroundTextControl(
            label: 'value',
            value: _value,
            onChanged: (value) => setState(() => _value = value),
          ),
          PlaygroundToggleControl(
            label: 'subtitle',
            value: _showSubtitle,
            onChanged: (value) => setState(() => _showSubtitle = value),
          ),
          PlaygroundTextControl(
            label: 'subtitle text',
            value: _subtitle,
            onChanged: (value) => setState(() => _subtitle = value),
          ),
        ],
      ),
    ],
  );
}
