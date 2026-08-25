import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class BankCardDemoScreen extends StatelessWidget {
  const BankCardDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.bankCard,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _BankCardDemo(),
  );
}

class _BankCardDemo extends StatefulWidget {
  const _BankCardDemo();

  @override
  State<_BankCardDemo> createState() => _BankCardDemoState();
}

class _BankCardDemoState extends State<_BankCardDemo> {
  var _wordmark = 'tsaitech';
  var _number = '•••• 4821';
  var _network = 'VISA';
  var _showWordmark = true;
  var _showContactless = true;
  var _showNumber = true;
  var _showNetwork = true;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('bankCard-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiBankCard(
          wordmark: _showWordmark ? _wordmark : null,
          showContactless: _showContactless,
          number: _showNumber ? _number : null,
          network: _showNetwork ? _network : null,
        ),
        controls: [
          PlaygroundToggleControl(
            label: 'wordmark',
            value: _showWordmark,
            onChanged: (value) => setState(() => _showWordmark = value),
          ),
          PlaygroundTextControl(
            label: 'wordmark text',
            value: _wordmark,
            onChanged: (value) => setState(() => _wordmark = value),
          ),
          PlaygroundToggleControl(
            label: 'contactless',
            value: _showContactless,
            onChanged: (value) => setState(() => _showContactless = value),
          ),
          PlaygroundToggleControl(
            label: 'number',
            value: _showNumber,
            onChanged: (value) => setState(() => _showNumber = value),
          ),
          PlaygroundTextControl(
            label: 'number text',
            value: _number,
            onChanged: (value) => setState(() => _number = value),
          ),
          PlaygroundToggleControl(
            label: 'network',
            value: _showNetwork,
            onChanged: (value) => setState(() => _showNetwork = value),
          ),
          PlaygroundTextControl(
            label: 'network text',
            value: _network,
            onChanged: (value) => setState(() => _network = value),
          ),
        ],
      ),
    ],
  );
}
