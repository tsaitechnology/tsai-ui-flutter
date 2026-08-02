import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class UIBlocksDemo extends StatelessWidget {
  const UIBlocksDemo({required this.section, super.key});

  final ComponentDemoSection section;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: ValueKey<String>('${section.name}-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        switch (section) {
          ComponentDemoSection.sectionHeader => const _SectionHeaderExample(),
          ComponentDemoSection.emptyState => const _EmptyStateExample(),
          ComponentDemoSection.listItem => const _ListItemExample(),
          ComponentDemoSection.list => const _ListExample(),
          _ => throw ArgumentError.value(section, 'section'),
        },
        SizedBox(height: tokens.spacing.space32),
        switch (section) {
          ComponentDemoSection.sectionHeader =>
            const _SectionHeaderPlayground(),
          ComponentDemoSection.emptyState => const _EmptyStatePlayground(),
          ComponentDemoSection.listItem => const _ListItemPlayground(),
          ComponentDemoSection.list => const _ListPlayground(),
          _ => throw ArgumentError.value(section, 'section'),
        },
      ],
    );
  }
}

class _SectionHeaderExample extends StatelessWidget {
  const _SectionHeaderExample();

  @override
  Widget build(BuildContext context) => const PenpotExample(
    title: 'Section Header',
    child: PenpotBoard(
      width: 402,
      padding: EdgeInsets.all(30),
      child: TsaiSectionHeader(
        title: 'Transactions',
        trailingIcon: TsaiIcon(LucideIcons.search),
        trailingIconSemanticLabel: 'Search transactions',
        onTrailingIconPressed: _noop,
      ),
    ),
  );
}

class _EmptyStateExample extends StatelessWidget {
  const _EmptyStateExample();

  @override
  Widget build(BuildContext context) => PenpotExample(
    title: 'Empty State',
    child: PenpotBoard(
      width: 422,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: TsaiEmptyState(
        icon: const TsaiIcon(LucideIcons.coffee, size: 28),
        title: 'No transactions yet',
        description: 'When you spend or receive money,\nit will show up here.',
        button: TsaiButton(
          label: 'Add money',
          size: TsaiButtonSize.medium,
          variant: TsaiButtonVariant.secondary,
          leadingIcon: const TsaiIcon(LucideIcons.plus, size: 16),
          onPressed: () {},
        ),
      ),
    ),
  );
}

class _ListItemExample extends StatelessWidget {
  const _ListItemExample();

  @override
  Widget build(BuildContext context) => PenpotExample(
    title: 'List Item',
    child: Wrap(
      spacing: 56,
      runSpacing: 40,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        PenpotBoard(
          width: 402,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              _transactionItem(
                icon: LucideIcons.coffee,
                title: 'Blue Bottle',
                subtitle: 'Coffee · Yesterday',
                value: r'-$4.50',
                subValue: '09:41',
              ),
              const SizedBox(height: 32),
              _transactionItem(
                icon: LucideIcons.coffee,
                title: 'Blue Bottle',
                subtitle: 'Coffee · Yesterday',
                value: r'-$4.50',
                subValue: '09:41',
                active: true,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 342,
          child: TsaiListItem(
            icon: const TsaiIcon(LucideIcons.bell, size: 20),
            content: _content('Notifications', 'Push · Email · SMS'),
            showChevron: true,
            onTap: () {},
          ),
        ),
      ],
    ),
  );
}

class _ListExample extends StatelessWidget {
  const _ListExample();

  @override
  Widget build(BuildContext context) => PenpotExample(
    title: 'List',
    child: PenpotBoard(
      padding: const EdgeInsets.all(30),
      child: Wrap(
        spacing: 56,
        runSpacing: 32,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          SizedBox(width: 342, child: _transactionList()),
          SizedBox(
            width: 342,
            child: TsaiEmptyState(
              icon: const TsaiIcon(LucideIcons.coffee, size: 28),
              title: 'No transactions yet',
              description:
                  'When you spend or receive money,\nit will show up here.',
              button: TsaiButton(
                label: 'Add money',
                size: TsaiButtonSize.medium,
                variant: TsaiButtonVariant.secondary,
                leadingIcon: const TsaiIcon(LucideIcons.plus, size: 16),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SectionHeaderPlayground extends StatefulWidget {
  const _SectionHeaderPlayground();

  @override
  State<_SectionHeaderPlayground> createState() =>
      _SectionHeaderPlaygroundState();
}

class _SectionHeaderPlaygroundState extends State<_SectionHeaderPlayground> {
  String _title = 'Transactions';
  bool _showTrailingIcon = true;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiSectionHeader(
      title: _title,
      trailingIcon: _showTrailingIcon
          ? const TsaiIcon(LucideIcons.search)
          : null,
      trailingIconSemanticLabel: 'Search transactions',
      onTrailingIconPressed: _showTrailingIcon ? _noop : null,
    ),
    controls: [
      PlaygroundTextControl(
        label: 'title',
        value: _title,
        onChanged: (value) => setState(() => _title = value),
      ),
      PlaygroundToggleControl(
        label: 'trailingIcon',
        value: _showTrailingIcon,
        onChanged: (value) => setState(() => _showTrailingIcon = value),
      ),
    ],
  );
}

void _noop() {}

class _EmptyStatePlayground extends StatefulWidget {
  const _EmptyStatePlayground();

  @override
  State<_EmptyStatePlayground> createState() => _EmptyStatePlaygroundState();
}

class _EmptyStatePlaygroundState extends State<_EmptyStatePlayground> {
  String _icon = 'coffee';
  String _title = 'No transactions yet';
  String _description =
      'When you spend or receive money, it will show up here.';
  bool _showButton = true;

  IconData get _iconData => switch (_icon) {
    'inbox' => LucideIcons.inbox,
    'search' => LucideIcons.search,
    _ => LucideIcons.coffee,
  };

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiEmptyState(
      icon: TsaiIcon(_iconData, size: 28),
      title: _title,
      description: _description,
      button: _showButton
          ? TsaiButton(
              label: 'Add money',
              size: TsaiButtonSize.medium,
              variant: TsaiButtonVariant.secondary,
              leadingIcon: const TsaiIcon(LucideIcons.plus, size: 16),
              onPressed: () {},
            )
          : null,
    ),
    controls: [
      PlaygroundSelectControl<String>(
        label: 'icon',
        value: _icon,
        values: const ['coffee', 'inbox', 'search'],
        onChanged: (value) => setState(() => _icon = value),
      ),
      PlaygroundTextControl(
        label: 'title',
        value: _title,
        onChanged: (value) => setState(() => _title = value),
      ),
      PlaygroundTextControl(
        label: 'description',
        value: _description,
        onChanged: (value) => setState(() => _description = value),
      ),
      PlaygroundToggleControl(
        label: 'button',
        value: _showButton,
        onChanged: (value) => setState(() => _showButton = value),
      ),
    ],
  );
}

class _ListItemPlayground extends StatefulWidget {
  const _ListItemPlayground();

  @override
  State<_ListItemPlayground> createState() => _ListItemPlaygroundState();
}

class _ListItemPlaygroundState extends State<_ListItemPlayground> {
  String _title = 'Blue Bottle';
  String _subtitle = 'Coffee · Today';
  bool _showIcon = true;
  bool _showSubtitle = true;
  bool _showTrailing = true;
  bool _showChevron = false;
  bool _active = false;
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiListItem(
      active: _active,
      icon: _showIcon ? const TsaiIcon(LucideIcons.coffee, size: 20) : null,
      content: _showSubtitle
          ? _content(_title, _subtitle)
          : TsaiTextBody(
              _title,
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.medium,
            ),
      trailing: _showTrailing ? _trailing(r'-$4.50', '09:41') : null,
      showChevron: _showChevron,
      onTap: () => setState(() => _tapCount += 1),
    ),
    controls: [
      PlaygroundTextControl(
        label: 'content title',
        value: _title,
        onChanged: (value) => setState(() => _title = value),
      ),
      PlaygroundTextControl(
        label: 'content subtitle',
        value: _subtitle,
        onChanged: (value) => setState(() => _subtitle = value),
      ),
      PlaygroundToggleControl(
        label: 'active',
        value: _active,
        onChanged: (value) => setState(() => _active = value),
      ),
      PlaygroundToggleControl(
        label: 'icon',
        value: _showIcon,
        onChanged: (value) => setState(() => _showIcon = value),
      ),
      PlaygroundToggleControl(
        label: 'subtitle',
        value: _showSubtitle,
        onChanged: (value) => setState(() => _showSubtitle = value),
      ),
      PlaygroundToggleControl(
        label: 'trailing',
        value: _showTrailing,
        onChanged: (value) => setState(() => _showTrailing = value),
      ),
      PlaygroundToggleControl(
        label: 'showChevron',
        value: _showChevron,
        onChanged: (value) => setState(() => _showChevron = value),
      ),
      PlaygroundOutput(label: 'onTap', value: '$_tapCount'),
    ],
  );
}

class _ListPlayground extends StatefulWidget {
  const _ListPlayground();

  @override
  State<_ListPlayground> createState() => _ListPlaygroundState();
}

class _ListPlaygroundState extends State<_ListPlayground> {
  String _title = 'Transactions';
  int _itemCount = 3;
  bool _showHeaderIcon = true;
  bool _showButton = true;

  @override
  Widget build(BuildContext context) {
    final items = _transactionItems().take(_itemCount).toList();
    return ComponentPlayground(
      preview: TsaiList(
        title: _title,
        headerTrailingIcon: _showHeaderIcon
            ? const TsaiIcon(LucideIcons.search)
            : null,
        items: items,
        button: _showButton
            ? TsaiButton(
                label: 'Show all',
                size: TsaiButtonSize.medium,
                variant: TsaiButtonVariant.outline,
                isExpanded: true,
                onPressed: () {},
              )
            : null,
      ),
      controls: [
        PlaygroundTextControl(
          label: 'title',
          value: _title,
          onChanged: (value) => setState(() => _title = value),
        ),
        PlaygroundSelectControl<int>(
          label: 'items',
          value: _itemCount,
          values: const [1, 3, 5],
          onChanged: (value) => setState(() => _itemCount = value),
        ),
        PlaygroundToggleControl(
          label: 'headerTrailingIcon',
          value: _showHeaderIcon,
          onChanged: (value) => setState(() => _showHeaderIcon = value),
        ),
        PlaygroundToggleControl(
          label: 'button',
          value: _showButton,
          onChanged: (value) => setState(() => _showButton = value),
        ),
      ],
    );
  }
}

Widget _transactionList() => TsaiList(
  title: 'Transactions',
  headerTrailingIcon: const TsaiIcon(LucideIcons.search),
  items: _transactionItems(),
  button: TsaiButton(
    label: 'Show all',
    size: TsaiButtonSize.medium,
    variant: TsaiButtonVariant.outline,
    isExpanded: true,
    onPressed: () {},
  ),
);

List<TsaiListItem> _transactionItems() => [
  _transactionItem(
    icon: LucideIcons.coffee,
    title: 'Blue Bottle',
    subtitle: 'Coffee · Today',
    value: r'-$4.50',
    subValue: '09:41',
  ),
  _transactionItem(
    icon: LucideIcons.shopping_bag,
    title: 'Apple Store',
    subtitle: 'Shopping · Today',
    value: r'-$129.00',
    subValue: '12:18',
  ),
  _transactionItem(
    icon: LucideIcons.arrow_up_right,
    title: 'Maria Gonzalez',
    subtitle: 'Transfer · Yesterday',
    value: r'-$250.00',
    subValue: '18:04',
  ),
  _transactionItem(
    icon: LucideIcons.arrow_down_left,
    title: 'Salary',
    subtitle: 'Incoming · Jul 28',
    value: r'+$4,800.00',
    subValue: '10:00',
    positive: true,
  ),
  _transactionItem(
    icon: LucideIcons.credit_card,
    title: 'Card payment',
    subtitle: 'Credit card · Jul 27',
    value: r'-$62.30',
    subValue: '21:47',
  ),
];

TsaiListItem _transactionItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required String value,
  required String subValue,
  bool active = false,
  bool positive = false,
}) => TsaiListItem(
  active: active,
  icon: TsaiIcon(icon, size: 20),
  content: _content(title, subtitle),
  trailing: _trailing(value, subValue, positive: positive),
);

Widget _content(String title, String subtitle) => Builder(
  builder: (context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TsaiTextBody(
          title,
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.medium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: tokens.spacing.space2),
        TsaiTextCaption(
          subtitle,
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.regular,
          color: tokens.colors.contentTertiary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  },
);

Widget _trailing(String value, String subValue, {bool positive = false}) =>
    Builder(
      builder: (context) {
        final tokens = TsaiThemeTokens.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TsaiTextMonoBody(
              value,
              size: TsaiBodySize.medium,
              color: positive
                  ? tokens.colors.positive
                  : tokens.colors.contentPrimary,
            ),
            SizedBox(height: tokens.spacing.space2),
            TsaiTextCaption(
              subValue,
              size: TsaiCaptionSize.medium,
              weight: TsaiTextWeight.regular,
              color: tokens.colors.contentTertiary,
            ),
          ],
        );
      },
    );
