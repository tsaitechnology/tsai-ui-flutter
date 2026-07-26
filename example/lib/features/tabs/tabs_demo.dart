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
      padding: EdgeInsets.only(bottom: tokens.spacing.space24),
      children: [
        const _ScenarioHeader(
          title: 'Variants',
          description:
              'Expanded and scrollable tab bars with intrinsic content.',
        ),
        TsaiTabs(
          sections: [
            TsaiTabSection.text(
              label: 'Overview',
              content: const _CompactContent('Expanded tabs'),
            ),
            TsaiTabSection.text(
              label: 'Activity',
              content: const _CompactContent('Activity content'),
            ),
            TsaiTabSection.text(
              label: 'Settings',
              content: const _CompactContent('Settings content'),
            ),
          ],
        ),
        SizedBox(height: tokens.spacing.space24),
        TsaiTabs(
          fit: TsaiTabBarFit.scrollable,
          sections: [
            for (final label in const [
              'Overview',
              'Activity',
              'Statements',
              'Settings',
              'Permissions',
            ])
              TsaiTabSection.text(
                label: label,
                content: _CompactContent('$label content'),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(tokens.spacing.space16),
          child: ComponentPlayground(
            controls: [
              PlaygroundSelectControl<TsaiTabBarFit>(
                label: 'fit',
                value: _fit,
                values: TsaiTabBarFit.values,
                onChanged: (value) => setState(() => _fit = value),
              ),
              PlaygroundSelectControl<_TabContentKind>(
                label: 'content',
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

class TabsDocumentDemo extends StatelessWidget {
  const TabsDocumentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SingleChildScrollView(
      key: const ValueKey<String>('tabs-document-demo'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ScenarioHeader(
            title: 'Account activity',
            description:
                'The page owns scrolling, so this header and the tabs leave '
                'the viewport with the selected section.',
          ),
          Padding(
            padding: EdgeInsets.all(tokens.spacing.space24),
            child: TsaiTabs(
              sections: [
                TsaiTabSection.text(
                  label: 'Activity',
                  content: const _IntrinsicSection(
                    title: 'Recent activity',
                    itemPrefix: 'Activity',
                    itemCount: 14,
                  ),
                ),
                TsaiTabSection.text(
                  label: 'Statements',
                  content: const _IntrinsicSection(
                    title: 'Monthly statements',
                    itemPrefix: 'Statement',
                    itemCount: 9,
                  ),
                ),
                TsaiTabSection.text(
                  label: 'Settings',
                  content: const _IntrinsicSection(
                    title: 'Account settings',
                    itemPrefix: 'Setting',
                    itemCount: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabsViewportDemo extends StatelessWidget {
  const TabsViewportDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      key: const ValueKey<String>('tabs-viewport-demo'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ScenarioHeader(
          compact: true,
          title: 'Operations queue',
          description:
              'The header and tabs stay visible while each section owns its '
              'scroll position.',
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              tokens.spacing.space24,
              tokens.spacing.space16,
              tokens.spacing.space24,
              0,
            ),
            child: TsaiTabs(
              contentLayout: TsaiTabContentLayout.viewport,
              sections: [
                TsaiTabSection.text(
                  label: 'Open',
                  content: const _ScrollableSection(
                    storageKey: 'open-queue',
                    itemPrefix: 'Open request',
                    itemCount: 30,
                  ),
                ),
                TsaiTabSection.text(
                  label: 'Review',
                  content: const _ScrollableSection(
                    storageKey: 'review-queue',
                    itemPrefix: 'Review case',
                    itemCount: 22,
                  ),
                ),
                TsaiTabSection.text(
                  label: 'Closed',
                  content: const _ScrollableSection(
                    storageKey: 'closed-queue',
                    itemPrefix: 'Closed request',
                    itemCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TabsStickyDemo extends StatefulWidget {
  const TabsStickyDemo({super.key});

  @override
  State<TabsStickyDemo> createState() => _TabsStickyDemoState();
}

class _TabsStickyDemoState extends State<TabsStickyDemo>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    const tabs = [Text('Overview'), Text('Usage'), Text('Invoices')];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space24),
      child: CustomScrollView(
        key: const ValueKey<String>('tabs-sticky-demo'),
        slivers: [
          const SliverToBoxAdapter(
            child: _ScenarioHeader(
              title: 'Workspace billing',
              description:
                  'The page header scrolls away. The tab selector then pins '
                  'to the top edge while the section continues.',
            ),
          ),
          TsaiSliverTabBar(controller: _controller, tabs: tabs),
          SliverToBoxAdapter(
            child: TsaiTabContent.intrinsic(
              controller: _controller,
              children: const [
                _IntrinsicSection(
                  title: 'Workspace overview',
                  itemPrefix: 'Workspace metric',
                  itemCount: 15,
                ),
                _IntrinsicSection(
                  title: 'Product usage',
                  itemPrefix: 'Usage metric',
                  itemCount: 18,
                ),
                _IntrinsicSection(
                  title: 'Invoice history',
                  itemPrefix: 'Invoice',
                  itemCount: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioHeader extends StatelessWidget {
  const _ScenarioHeader({
    required this.title,
    required this.description,
    this.compact = false,
  });

  final String title;
  final String description;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.space24,
        vertical: compact ? tokens.spacing.space16 : tokens.spacing.space32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TsaiTextHeading(title, size: TsaiHeadingSize.medium),
          SizedBox(height: tokens.spacing.space8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: TsaiTextBody(
              description,
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.regular,
              color: tokens.colors.contentSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntrinsicSection extends StatelessWidget {
  const _IntrinsicSection({
    required this.title,
    required this.itemPrefix,
    required this.itemCount,
  });

  final String title;
  final String itemPrefix;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.only(top: tokens.spacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TsaiTextHeading(title, size: TsaiHeadingSize.small),
          SizedBox(height: tokens.spacing.space16),
          for (var index = 0; index < itemCount; index++)
            _DemoRow(label: '$itemPrefix ${index + 1}', index: index),
        ],
      ),
    );
  }
}

class _ScrollableSection extends StatelessWidget {
  const _ScrollableSection({
    required this.storageKey,
    required this.itemPrefix,
    required this.itemCount,
  });

  final String storageKey;
  final String itemPrefix;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView.builder(
      key: PageStorageKey<String>(storageKey),
      padding: EdgeInsets.only(top: tokens.spacing.space16),
      itemCount: itemCount,
      itemBuilder: (context, index) =>
          _DemoRow(label: '$itemPrefix ${index + 1}', index: index),
    );
  }
}

class _DemoRow extends StatelessWidget {
  const _DemoRow({required this.label, required this.index});

  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: EdgeInsets.symmetric(vertical: tokens.spacing.space12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: tokens.colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TsaiTextBody(
              label,
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.medium,
            ),
          ),
          TsaiTextCaption(
            index.isEven ? 'Updated today' : 'Updated yesterday',
            size: TsaiCaptionSize.medium,
            weight: TsaiTextWeight.regular,
            color: tokens.colors.contentSecondary,
          ),
        ],
      ),
    );
  }
}
