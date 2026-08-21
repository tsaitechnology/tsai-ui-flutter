import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

enum _TabContentKind { text, button, icon }

class TabsCatalogDemo extends StatefulWidget {
  const TabsCatalogDemo({super.key});

  @override
  State<TabsCatalogDemo> createState() => _TabsCatalogDemoState();
}

class _TabsCatalogDemoState extends State<TabsCatalogDemo> {
  TsaiTabBarFit _fit = TsaiTabBarFit.expand;
  _TabContentKind _content = _TabContentKind.text;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: const ValueKey<String>('tabs-catalog-demo'),
      padding: EdgeInsets.all(tokens.spacing.space16),
      children: [
        ComponentPlayground(
          controls: [
            PlaygroundSelectControl<TsaiTabBarFit>(
              label: 'Tab bar fit',
              value: _fit,
              values: TsaiTabBarFit.values,
              labels: const ['Expanded', 'Scrollable'],
              onChanged: (value) => setState(() => _fit = value),
            ),
            PlaygroundSelectControl<_TabContentKind>(
              label: 'Selected tab content',
              value: _content,
              values: _TabContentKind.values,
              labels: const ['Text', 'Button', 'Icon'],
              onChanged: (value) => setState(() => _content = value),
            ),
          ],
          preview: TsaiTabs(
            fit: _fit,
            sections: [
              TsaiTabSection.text(
                label: 'First',
                content: _SelectedTabContent(kind: _content),
              ),
              TsaiTabSection.text(
                label: 'Second',
                content: const _CompactContent('Second tab'),
              ),
              TsaiTabSection.text(
                label: 'Third',
                content: const _CompactContent('Third tab'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.space16,
        vertical: tokens.spacing.space24,
      ),
      child: TsaiTextBody(
        label,
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
      ),
    );
  }
}

class _SelectedTabContent extends StatelessWidget {
  const _SelectedTabContent({required this.kind});

  final _TabContentKind kind;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: tokens.spacing.space24),
      child: switch (kind) {
        _TabContentKind.text => const TsaiTextBody(
          'Tab content',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.regular,
        ),
        _TabContentKind.button => TsaiButton(
          label: 'Tab action',
          onPressed: () {},
        ),
        _TabContentKind.icon => const TsaiIcon(LucideIcons.layers),
      },
    );
  }
}
