import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class LinkDemo extends StatefulWidget {
  const LinkDemo({super.key});

  @override
  State<LinkDemo> createState() => _LinkDemoState();
}

class _LinkDemoState extends State<LinkDemo> {
  String _label = 'Link';
  bool _enabled = true;
  bool _leadingIcon = true;
  bool _trailingIcon = false;
  int _pressCount = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: const ValueKey<String>('link-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        ComponentPlayground(
          controls: [
            PlaygroundTextControl(
              label: 'label',
              value: _label,
              onChanged: (value) => setState(() => _label = value),
            ),
            PlaygroundToggleControl(
              label: 'enabled',
              value: _enabled,
              onChanged: (value) => setState(() => _enabled = value),
            ),
            PlaygroundToggleControl(
              label: 'Leading icon',
              value: _leadingIcon,
              onChanged: (value) => setState(() => _leadingIcon = value),
            ),
            PlaygroundToggleControl(
              label: 'Trailing icon',
              value: _trailingIcon,
              onChanged: (value) => setState(() => _trailingIcon = value),
            ),
            PlaygroundOutput(
              label: 'Press count',
              value: 'Called $_pressCount times',
            ),
          ],
          preview: TsaiLink(
            label: _label,
            leadingIcon: _leadingIcon
                ? const TsaiIcon(LucideIcons.plus, size: 16)
                : null,
            trailingIcon: _trailingIcon
                ? const TsaiIcon(LucideIcons.chevron_right, size: 16)
                : null,
            onPressed: _enabled ? () => setState(() => _pressCount++) : null,
          ),
        ),
      ],
    );
  }
}
