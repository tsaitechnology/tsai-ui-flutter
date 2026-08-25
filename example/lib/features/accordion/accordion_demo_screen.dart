import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class AccordionDemoScreen extends StatelessWidget {
  const AccordionDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.accordion,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _AccordionDemo(),
  );
}

class _AccordionDemo extends StatefulWidget {
  const _AccordionDemo();

  @override
  State<_AccordionDemo> createState() => _AccordionDemoState();
}

class _AccordionDemoState extends State<_AccordionDemo> {
  var _expanded = true;
  var _title = 'How do transfers work?';
  var _body =
      'Transfers between TsaiTech accounts are instant and free. External transfers arrive within 1–2 business days.';
  var _showDivider = true;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('accordion-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: SizedBox(
          width: 342,
          child: TsaiAccordion(
            title: _title,
            body: _body,
            expanded: _expanded,
            showDivider: _showDivider,
            onChanged: (value) => setState(() => _expanded = value),
          ),
        ),
        controls: [
          PlaygroundToggleControl(
            label: 'expanded',
            value: _expanded,
            onChanged: (value) => setState(() => _expanded = value),
          ),
          PlaygroundToggleControl(
            label: 'showDivider',
            value: _showDivider,
            onChanged: (value) => setState(() => _showDivider = value),
          ),
          PlaygroundTextControl(
            label: 'title',
            value: _title,
            onChanged: (value) => setState(() => _title = value),
          ),
          PlaygroundTextControl(
            label: 'body',
            value: _body,
            onChanged: (value) => setState(() => _body = value),
          ),
        ],
      ),
    ],
  );
}
