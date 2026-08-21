import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class IconDemoScreen extends StatelessWidget {
  const IconDemoScreen({
    required this.section,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ComponentDemoSection section;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: section,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: _IconDemo(section: section),
  );
}

class _IconDemo extends StatelessWidget {
  const _IconDemo({required this.section});

  final ComponentDemoSection section;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: ValueKey<String>('${section.name}-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        switch (section) {
          ComponentDemoSection.tsaiIcon => const _TsaiIconPlayground(),
          ComponentDemoSection.hitIcon => const _HitIconPlayground(),
          ComponentDemoSection.circleIcon => const _CircleIconPlayground(),
          ComponentDemoSection.cryptoIcon => const _CryptoIconPlayground(),
          _ => throw ArgumentError.value(section, 'section'),
        },
      ],
    );
  }
}

class _TsaiIconPlayground extends StatefulWidget {
  const _TsaiIconPlayground();

  @override
  State<_TsaiIconPlayground> createState() => _TsaiIconPlaygroundState();
}

class _TsaiIconPlaygroundState extends State<_TsaiIconPlayground> {
  double _size = 24;
  bool _useAccent = false;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ComponentPlayground(
      controls: [
        PlaygroundField(
          label: 'size: ${_size.round()}',
          child: Slider(
            value: _size,
            min: 12,
            max: 64,
            divisions: 13,
            onChanged: (value) => setState(() => _size = value),
          ),
        ),
        PlaygroundRadioGroup<bool>(
          label: 'color',
          value: _useAccent,
          options: const [(false, 'Inherited'), (true, 'Accent')],
          onChanged: (value) => setState(() => _useAccent = value),
        ),
      ],
      preview: TsaiIcon(
        LucideIcons.settings,
        size: _size,
        color: _useAccent ? tokens.colors.actionPrimary : null,
        semanticLabel: 'Settings',
      ),
    );
  }
}

class _HitIconPlayground extends StatefulWidget {
  const _HitIconPlayground();

  @override
  State<_HitIconPlayground> createState() => _HitIconPlaygroundState();
}

class _HitIconPlaygroundState extends State<_HitIconPlayground> {
  String _icon = 'search';
  double _iconSize = 24;
  bool _enabled = true;
  int _presses = 0;

  IconData get _iconData => switch (_icon) {
    'bell' => LucideIcons.bell,
    'settings' => LucideIcons.settings,
    _ => LucideIcons.search,
  };

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    controls: [
      PlaygroundSelectControl<String>(
        label: 'icon',
        value: _icon,
        values: const ['search', 'bell', 'settings'],
        onChanged: (value) => setState(() => _icon = value),
      ),
      PlaygroundToggleControl(
        label: 'interactive',
        value: _enabled,
        onChanged: (value) => setState(() => _enabled = value),
      ),
      PlaygroundField(
        label: 'iconSize: ${_iconSize.round()}',
        child: Slider(
          value: _iconSize,
          min: 12,
          max: 32,
          divisions: 10,
          onChanged: (value) => setState(() => _iconSize = value),
        ),
      ),
      PlaygroundOutput(label: 'Press count', value: '$_presses'),
    ],
    preview: HitIcon(
      icon: TsaiIcon(_iconData),
      iconSize: _iconSize,
      semanticLabel: 'Demo action',
      onPressed: _enabled ? () => setState(() => _presses++) : null,
    ),
  );
}

class _CircleIconPlayground extends StatefulWidget {
  const _CircleIconPlayground();

  @override
  State<_CircleIconPlayground> createState() => _CircleIconPlaygroundState();
}

class _CircleIconPlaygroundState extends State<_CircleIconPlayground> {
  String _icon = 'coffee';

  IconData get _iconData => switch (_icon) {
    'shopping bag' => LucideIcons.shopping_bag,
    'credit card' => LucideIcons.credit_card,
    _ => LucideIcons.coffee,
  };

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    controls: [
      PlaygroundSelectControl<String>(
        label: 'icon',
        value: _icon,
        values: const ['coffee', 'shopping bag', 'credit card'],
        onChanged: (value) => setState(() => _icon = value),
      ),
    ],
    preview: _CircleIconPreview(
      icon: CircleIcon(
        icon: TsaiIcon(_iconData, size: 20),
        semanticLabel: _icon,
      ),
    ),
  );
}

class _CircleIconPreview extends StatelessWidget {
  const _CircleIconPreview({required this.icon});

  final CircleIcon icon;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ColoredBox(
        color: tokens.colors.canvas,
        child: SizedBox.square(dimension: 72, child: Center(child: icon)),
      ),
    );
  }
}

class _CryptoIconPlayground extends StatefulWidget {
  const _CryptoIconPlayground();

  @override
  State<_CryptoIconPlayground> createState() => _CryptoIconPlaygroundState();
}

class _CryptoIconPlaygroundState extends State<_CryptoIconPlayground> {
  TsaiCryptoAsset _asset = TsaiCryptoAsset.btc;
  double _size = 24;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    controls: [
      PlaygroundSelectControl<TsaiCryptoAsset>(
        label: 'asset',
        value: _asset,
        values: TsaiCryptoAsset.values,
        labels: [
          for (final asset in TsaiCryptoAsset.values) asset.name.toUpperCase(),
        ],
        onChanged: (value) => setState(() => _asset = value),
      ),
      PlaygroundField(
        label: 'size: ${_size.round()}',
        child: Slider(
          value: _size,
          min: 16,
          max: 64,
          divisions: 12,
          onChanged: (value) => setState(() => _size = value),
        ),
      ),
    ],
    preview: TsaiCryptoIcon(_asset, size: _size, semanticLabel: _asset.name),
  );
}
