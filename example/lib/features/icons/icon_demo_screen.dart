import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class IconDemoScreen extends StatelessWidget {
  const IconDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.icons,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _IconDemo(),
  );
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();

  static const _icons = <(String, IconData)>[
    ('plus', LucideIcons.plus),
    ('search', LucideIcons.search),
    ('settings', LucideIcons.settings),
    ('bell', LucideIcons.bell),
    ('check', LucideIcons.check),
    ('x', LucideIcons.x),
    ('chevron_down', LucideIcons.chevron_down),
    ('circle_alert', LucideIcons.circle_alert),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: const ValueKey<String>('icon-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        const TsaiHeading('TsaiIcon', size: TsaiHeadingSize.large),
        SizedBox(height: tokens.spacing.space8),
        TsaiBody(
          'A stable square adapter for Lucide or any Flutter IconData.',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.regular,
          color: tokens.colors.contentSecondary,
        ),
        SizedBox(height: tokens.spacing.space32),
        PenpotExample(
          title: 'Common icons',
          child: PenpotBoard(
            child: Wrap(
              spacing: tokens.spacing.space24,
              runSpacing: tokens.spacing.space24,
              children: [
                for (final item in _icons)
                  SizedBox(
                    width: 96,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TsaiIcon(item.$2, semanticLabel: item.$1),
                        SizedBox(height: tokens.spacing.space8),
                        TsaiCaption(
                          item.$1,
                          size: TsaiCaptionSize.small,
                          weight: TsaiTextWeight.regular,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const _IconPlayground(),
      ],
    );
  }
}

class _IconPlayground extends StatefulWidget {
  const _IconPlayground();

  @override
  State<_IconPlayground> createState() => _IconPlaygroundState();
}

class _IconPlaygroundState extends State<_IconPlayground> {
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
        PlaygroundField(
          label: 'color',
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Inherited')),
              ButtonSegment(value: true, label: Text('Accent')),
            ],
            selected: {_useAccent},
            onSelectionChanged: (value) =>
                setState(() => _useAccent = value.single),
          ),
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
