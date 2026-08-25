import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class ActionTileDemoScreen extends StatelessWidget {
  const ActionTileDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.actionTile,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _ActionTileDemo(),
  );
}

class _ActionTileDemo extends StatefulWidget {
  const _ActionTileDemo();

  @override
  State<_ActionTileDemo> createState() => _ActionTileDemoState();
}

class _ActionTileDemoState extends State<_ActionTileDemo> {
  var _variant = TsaiActionTileVariant.circle;
  var _label = 'Send';
  var _showLabel = true;
  var _presses = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final gap = _variant == TsaiActionTileVariant.circle
        ? tokens.spacing.space24
        : tokens.spacing.space4;
    return ListView(
      key: const ValueKey<String>('actionTile-demo'),
      padding: const EdgeInsets.all(24),
      children: [
        ComponentPlayground(
          preview: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TsaiActionTile(
                variant: _variant,
                label: _showLabel ? _label : null,
                icon: const TsaiIcon(LucideIcons.send),
                onPressed: () => setState(() => _presses++),
              ),
              SizedBox(width: gap),
              TsaiActionTile(
                variant: _variant,
                label: _showLabel ? 'Request' : null,
                icon: const TsaiIcon(LucideIcons.arrow_down_left),
                onPressed: () => setState(() => _presses++),
              ),
              SizedBox(width: gap),
              TsaiActionTile(
                variant: _variant,
                label: _showLabel ? 'Top up' : null,
                icon: const TsaiIcon(LucideIcons.plus),
                onPressed: () => setState(() => _presses++),
              ),
            ],
          ),
          controls: [
            PlaygroundRadioGroup<TsaiActionTileVariant>(
              label: 'variant',
              value: _variant,
              options: const [
                (TsaiActionTileVariant.circle, 'Circle'),
                (TsaiActionTileVariant.card, 'Card'),
                (TsaiActionTileVariant.ghost, 'Ghost'),
              ],
              onChanged: (value) => setState(() => _variant = value),
            ),
            PlaygroundTextControl(
              label: 'label',
              value: _label,
              onChanged: (value) => setState(() => _label = value),
            ),
            PlaygroundToggleControl(
              label: 'showLabel',
              value: _showLabel,
              onChanged: (value) => setState(() => _showLabel = value),
            ),
            PlaygroundOutput(label: 'presses', value: '$_presses'),
          ],
        ),
      ],
    );
  }
}
