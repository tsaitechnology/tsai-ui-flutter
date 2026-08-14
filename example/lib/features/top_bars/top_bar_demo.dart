import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

enum _HomeLeadingContent { text, user, none }

enum _PageLeadingContent { text, backAction, none }

enum _TrailingContent { none, twoActions, oneAction, text }

enum _BodyContent { list, text, button, icon }

class HomeTopBarDemo extends StatefulWidget {
  const HomeTopBarDemo({super.key});

  @override
  State<HomeTopBarDemo> createState() => _HomeTopBarDemoState();
}

class _HomeTopBarDemoState extends State<HomeTopBarDemo> {
  _HomeLeadingContent _leading = _HomeLeadingContent.user;
  _TrailingContent _trailing = _TrailingContent.twoActions;
  bool _indicator = false;

  @override
  Widget build(BuildContext context) => _LayoutDocument(
    key: const ValueKey<String>('home-top-bar-demo'),
    variants: [
      const _SectionLabel('Title and menu'),
      _HomeTopBarBackdrop(
        child: HomeTopBar(
          leading: const [
            TsaiTextHeading('Dashboard', size: TsaiHeadingSize.small),
          ],
          trailing: [
            HomeTopBarAction(
              icon: const TsaiIcon(LucideIcons.menu),
              semanticLabel: 'Menu',
              onPressed: () {},
            ),
          ],
        ),
      ),
      const _SectionLabel('User and actions'),
      _HomeTopBarBackdrop(
        child: HomeTopBar(
          leading: [
            UserPill(
              name: 'Ilona T.',
              initials: 'IT',
              semanticLabel: 'Open profile',
              onPressed: () {},
            ),
          ],
          trailing: [
            HomeTopBarAction(
              icon: const TsaiIcon(LucideIcons.scan_line),
              semanticLabel: 'Scan',
              onPressed: () {},
            ),
            HomeTopBarAction(
              icon: const TsaiIcon(LucideIcons.bell),
              semanticLabel: 'Notifications',
              showIndicator: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
    playground: ComponentPlayground(
      controls: [
        PlaygroundSelectControl<_HomeLeadingContent>(
          label: 'leading content',
          value: _leading,
          values: _HomeLeadingContent.values,
          labels: const ['Text', 'User', 'None'],
          onChanged: (value) => setState(() => _leading = value),
        ),
        PlaygroundSelectControl<_TrailingContent>(
          label: 'trailing content',
          value: _trailing,
          values: _TrailingContent.values,
          labels: const ['None', 'Two actions', 'One action', 'Text'],
          onChanged: (value) => setState(() => _trailing = value),
        ),
        PlaygroundToggleControl(
          label: 'indicator',
          value: _indicator,
          onChanged: (value) => setState(() => _indicator = value),
        ),
      ],
      preview: _HomeTopBarBackdrop(
        child: HomeTopBar(
          leading: _homeLeading(_leading),
          trailing: _homeTrailing(_trailing, showIndicator: _indicator),
        ),
      ),
    ),
  );
}

class PageTopBarDemo extends StatefulWidget {
  const PageTopBarDemo({super.key});

  @override
  State<PageTopBarDemo> createState() => _PageTopBarDemoState();
}

class _PageTopBarDemoState extends State<PageTopBarDemo> {
  String _title = 'Card details';
  _PageLeadingContent _leading = _PageLeadingContent.backAction;
  _TrailingContent _trailing = _TrailingContent.twoActions;

  @override
  Widget build(BuildContext context) => _LayoutDocument(
    key: const ValueKey<String>('page-top-bar-demo'),
    variants: [
      const _SectionLabel('Title with two edge actions'),
      PlaygroundContrastBackdrop(
        height: 96,
        alignment: Alignment.topCenter,
        child: PageTopBar(
          leading: [
            PageTopBarAction(
              icon: const TsaiIcon(LucideIcons.arrow_left),
              semanticLabel: 'Back',
              onPressed: () {},
            ),
          ],
          title: 'Card details',
          trailing: [
            PageTopBarAction(
              icon: const TsaiIcon(LucideIcons.plus),
              semanticLabel: 'Add',
              onPressed: () {},
            ),
            PageTopBarAction(
              icon: const TsaiIcon(LucideIcons.ellipsis),
              semanticLabel: 'More',
              onPressed: () {},
            ),
          ],
        ),
      ),
      const _SectionLabel('Title only'),
      const PlaygroundContrastBackdrop(
        height: 96,
        alignment: Alignment.topCenter,
        child: PageTopBar(title: 'Activity'),
      ),
    ],
    playground: ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'title',
          value: _title,
          onChanged: (value) => setState(() => _title = value),
        ),
        PlaygroundSelectControl<_PageLeadingContent>(
          label: 'leading content',
          value: _leading,
          values: _PageLeadingContent.values,
          labels: const ['Text', 'Back action', 'None'],
          onChanged: (value) => setState(() => _leading = value),
        ),
        PlaygroundSelectControl<_TrailingContent>(
          label: 'trailing content',
          value: _trailing,
          values: _TrailingContent.values,
          labels: const ['None', 'Two actions', 'One action', 'Text'],
          onChanged: (value) => setState(() => _trailing = value),
        ),
      ],
      preview: PlaygroundContrastBackdrop(
        height: 96,
        alignment: Alignment.topCenter,
        child: PageTopBar(
          leading: _pageLeading(_leading),
          title: _title,
          trailing: _pageTrailing(_trailing),
        ),
      ),
    ),
  );
}

class PageWithTopBarDemo extends StatefulWidget {
  const PageWithTopBarDemo({super.key});

  @override
  State<PageWithTopBarDemo> createState() => _PageWithTopBarDemoState();
}

class _PageWithTopBarDemoState extends State<PageWithTopBarDemo> {
  String _title = 'Portfolio';
  String _subtitle = 'Main account';
  _BodyContent _bodyContent = _BodyContent.list;
  _PageLeadingContent _leading = _PageLeadingContent.backAction;
  _TrailingContent _trailing = _TrailingContent.twoActions;

  String get _previewTitle => _title.trim().isEmpty ? 'Untitled' : _title;

  String? get _previewSubtitle => _subtitle.trim().isEmpty ? null : _subtitle;

  @override
  Widget build(BuildContext context) => _LayoutDocument(
    key: const ValueKey<String>('page-with-top-bar-demo'),
    variants: [
      const _SectionLabel('Scrolling composition'),
      const SizedBox(height: 420, child: _PortfolioPage()),
    ],
    playground: ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'title',
          value: _title,
          onChanged: (value) => setState(() => _title = value),
        ),
        PlaygroundTextControl(
          label: 'subtitle',
          value: _subtitle,
          onChanged: (value) => setState(() => _subtitle = value),
        ),
        PlaygroundSelectControl<_BodyContent>(
          label: 'body content',
          value: _bodyContent,
          values: _BodyContent.values,
          labels: const ['Long list', 'Text', 'Button', 'Icon'],
          onChanged: (value) => setState(() => _bodyContent = value),
        ),
        PlaygroundSelectControl<_PageLeadingContent>(
          label: 'leading content',
          value: _leading,
          values: _PageLeadingContent.values,
          labels: const ['Text', 'Back action', 'None'],
          onChanged: (value) => setState(() => _leading = value),
        ),
        PlaygroundSelectControl<_TrailingContent>(
          label: 'trailing content',
          value: _trailing,
          values: _TrailingContent.values,
          labels: const ['None', 'Two actions', 'One action', 'Text'],
          onChanged: (value) => setState(() => _trailing = value),
        ),
      ],
      preview: SizedBox(
        height: 320,
        child: PageWithTopBar(
          heading: _previewTitle,
          subtitle: _previewSubtitle,
          leading: _pageLeading(_leading),
          trailing: _pageTrailing(_trailing),
          body: _body(_bodyContent),
        ),
      ),
    ),
  );
}

class TopBarDemo extends StatelessWidget {
  const TopBarDemo({super.key});

  @override
  Widget build(BuildContext context) => const HomeTopBarDemo();
}

class PageWithSearchTopBarDemo extends StatefulWidget {
  const PageWithSearchTopBarDemo({super.key});

  @override
  State<PageWithSearchTopBarDemo> createState() =>
      _PageWithSearchTopBarDemoState();
}

class _PageWithSearchTopBarDemoState extends State<PageWithSearchTopBarDemo> {
  final _searchController = TextEditingController();
  String _title = 'Card details';
  _BodyContent _bodyContent = _BodyContent.list;
  _PageLeadingContent _leading = _PageLeadingContent.backAction;
  _TrailingContent _trailing = _TrailingContent.twoActions;
  String _event = 'No search events';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _LayoutDocument(
    key: const ValueKey<String>('page-with-search-top-bar-demo'),
    variants: [
      const _SectionLabel('Pinned glass app bar and search'),
      SizedBox(
        height: 420,
        child: PageWithSearchTopBar(
          title: 'Card details',
          search: const TsaiSearchInput(),
          leading: [
            PageTopBarAction(
              icon: const TsaiIcon(LucideIcons.arrow_left),
              semanticLabel: 'Back',
              onPressed: () {},
            ),
          ],
          trailing: [
            PageTopBarAction(
              icon: const TsaiIcon(LucideIcons.plus),
              semanticLabel: 'Add',
              onPressed: () {},
            ),
            PageTopBarAction(
              icon: const TsaiIcon(LucideIcons.ellipsis),
              semanticLabel: 'More',
              onPressed: () {},
            ),
          ],
          body: _body(_BodyContent.list),
        ),
      ),
    ],
    playground: ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'title',
          value: _title,
          onChanged: (value) => setState(() => _title = value),
        ),
        PlaygroundTextControl(
          label: 'query',
          controller: _searchController,
          onChanged: (_) => setState(() {}),
        ),
        PlaygroundSelectControl<_BodyContent>(
          label: 'body content',
          value: _bodyContent,
          values: _BodyContent.values,
          labels: const ['Long list', 'Text', 'Button', 'Icon'],
          onChanged: (value) => setState(() => _bodyContent = value),
        ),
        PlaygroundSelectControl<_PageLeadingContent>(
          label: 'leading content',
          value: _leading,
          values: _PageLeadingContent.values,
          labels: const ['Text', 'Back action', 'None'],
          onChanged: (value) => setState(() => _leading = value),
        ),
        PlaygroundSelectControl<_TrailingContent>(
          label: 'trailing content',
          value: _trailing,
          values: _TrailingContent.values,
          labels: const ['None', 'Two actions', 'One action', 'Text'],
          onChanged: (value) => setState(() => _trailing = value),
        ),
        PlaygroundOutput(label: 'event', value: _event),
      ],
      preview: SizedBox(
        height: 320,
        child: PageWithSearchTopBar(
          title: _title,
          search: TsaiSearchInput(
            controller: _searchController,
            onChanged: (value) => setState(() => _event = 'onChanged($value)'),
            onSubmitted: (value) =>
                setState(() => _event = 'onSubmitted($value)'),
          ),
          leading: _pageLeading(_leading),
          trailing: _pageTrailing(_trailing),
          body: _body(_bodyContent),
        ),
      ),
    ),
  );
}

class _LayoutDocument extends StatelessWidget {
  const _LayoutDocument({
    required this.variants,
    required this.playground,
    super.key,
  });

  final List<Widget> variants;
  final Widget playground;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      padding: EdgeInsets.only(bottom: tokens.spacing.space24),
      children: [
        const _SectionLabel('Variants'),
        ...variants,
        Padding(
          padding: EdgeInsets.all(tokens.spacing.space16),
          child: playground,
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.space16,
        tokens.spacing.space24,
        tokens.spacing.space16,
        tokens.spacing.space8,
      ),
      child: TsaiTextHeading(label, size: TsaiHeadingSize.small),
    );
  }
}

class _HomeTopBarBackdrop extends StatelessWidget {
  const _HomeTopBarBackdrop({required this.child});

  final HomeTopBar child;

  @override
  Widget build(BuildContext context) {
    final colors = TsaiThemeTokens.of(context).colors;
    return SizedBox(
      key: const ValueKey<String>('home-top-bar-backdrop'),
      height: 112,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: ColoredBox(color: colors.actionPrimary),
                ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: ColoredBox(color: colors.accentSuccess),
                ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: ColoredBox(color: colors.accentError),
                ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: ColoredBox(color: colors.surfaceAccentPressed),
                ),
              ),
            ],
          ),
          Align(alignment: Alignment.topCenter, child: child),
        ],
      ),
    );
  }
}

class _PortfolioPage extends StatelessWidget {
  const _PortfolioPage();

  @override
  Widget build(BuildContext context) => PageWithTopBar(
    heading: 'Portfolio',
    subtitle: 'Main account',
    leading: [
      PageTopBarAction(
        icon: const TsaiIcon(LucideIcons.arrow_left),
        semanticLabel: 'Back',
        onPressed: () {},
      ),
    ],
    trailing: [
      PageTopBarAction(
        icon: const TsaiIcon(LucideIcons.plus),
        semanticLabel: 'Add',
        onPressed: () {},
      ),
    ],
    body: const _PortfolioBody(),
  );
}

class _PortfolioBody extends StatelessWidget {
  const _PortfolioBody();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
      child: Column(
        children: [
          for (final item in _portfolioItems)
            Container(
              height: tokens.spacing.space64,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: tokens.colors.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: tokens.spacing.space64,
                    child: TsaiTextMonoBody(item.$1, size: TsaiBodySize.medium),
                  ),
                  Expanded(
                    child: TsaiTextBody(
                      item.$2,
                      size: TsaiBodySize.medium,
                      weight: TsaiTextWeight.regular,
                    ),
                  ),
                  TsaiTextBody(
                    item.$3,
                    size: TsaiBodySize.medium,
                    weight: TsaiTextWeight.medium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

List<Widget> _homeLeading(_HomeLeadingContent content) => switch (content) {
  _HomeLeadingContent.text => const [
    TsaiTextHeading('Dashboard', size: TsaiHeadingSize.small),
  ],
  _HomeLeadingContent.user => [
    UserPill(
      name: 'Ilona T.',
      initials: 'IT',
      semanticLabel: 'Open profile',
      onPressed: () {},
    ),
  ],
  _HomeLeadingContent.none => const [],
};

List<Widget> _homeTrailing(
  _TrailingContent content, {
  required bool showIndicator,
}) => switch (content) {
  _TrailingContent.none => const [],
  _TrailingContent.twoActions => [
    HomeTopBarAction(
      icon: const TsaiIcon(LucideIcons.scan_line),
      semanticLabel: 'Scan',
      onPressed: () {},
    ),
    HomeTopBarAction(
      icon: const TsaiIcon(LucideIcons.bell),
      semanticLabel: 'Notifications',
      showIndicator: showIndicator,
      onPressed: () {},
    ),
  ],
  _TrailingContent.oneAction => [
    HomeTopBarAction(
      icon: const TsaiIcon(LucideIcons.menu),
      semanticLabel: 'Menu',
      showIndicator: showIndicator,
      onPressed: () {},
    ),
  ],
  _TrailingContent.text => const [
    TsaiTextBody(
      'Online',
      size: TsaiBodySize.medium,
      weight: TsaiTextWeight.medium,
    ),
  ],
};

List<Widget> _pageLeading(_PageLeadingContent content) => switch (content) {
  _PageLeadingContent.text => const [
    TsaiTextBody(
      'Cancel',
      size: TsaiBodySize.medium,
      weight: TsaiTextWeight.medium,
    ),
  ],
  _PageLeadingContent.backAction => [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.arrow_left),
      semanticLabel: 'Back',
      onPressed: () {},
    ),
  ],
  _PageLeadingContent.none => const [],
};

List<Widget> _pageTrailing(_TrailingContent content) => switch (content) {
  _TrailingContent.none => const [],
  _TrailingContent.twoActions => [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.plus),
      semanticLabel: 'Add',
      onPressed: () {},
    ),
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.ellipsis),
      semanticLabel: 'More',
      onPressed: () {},
    ),
  ],
  _TrailingContent.oneAction => [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.ellipsis),
      semanticLabel: 'More',
      onPressed: () {},
    ),
  ],
  _TrailingContent.text => const [
    TsaiTextBody(
      'Save',
      size: TsaiBodySize.medium,
      weight: TsaiTextWeight.medium,
    ),
  ],
};

Widget _body(_BodyContent content) => switch (content) {
  _BodyContent.list => const _PortfolioBody(),
  _BodyContent.text => const Padding(
    padding: EdgeInsets.all(24),
    child: TsaiTextBody(
      'Content',
      size: TsaiBodySize.medium,
      weight: TsaiTextWeight.medium,
    ),
  ),
  _BodyContent.button => Padding(
    padding: const EdgeInsets.all(24),
    child: Align(
      alignment: AlignmentDirectional.topStart,
      child: TsaiButton(
        label: 'Action',
        size: TsaiButtonSize.medium,
        onPressed: () {},
      ),
    ),
  ),
  _BodyContent.icon => const Padding(
    padding: EdgeInsets.all(24),
    child: Align(
      alignment: AlignmentDirectional.topStart,
      child: TsaiIcon(LucideIcons.star),
    ),
  ),
};

const _portfolioItems = [
  ('AAPL', 'Apple', r'$214.40'),
  ('MSFT', 'Microsoft', r'$441.92'),
  ('NVDA', 'NVIDIA', r'$173.74'),
  ('TSLA', 'Tesla', r'$316.06'),
  ('AMZN', 'Amazon', r'$232.22'),
  ('META', 'Meta', r'$712.50'),
  ('GOOG', 'Alphabet', r'$192.96'),
  ('AMD', 'AMD', r'$165.61'),
  ('NFLX', 'Netflix', r'$1,180.49'),
  ('ORCL', 'Oracle', r'$246.01'),
  ('CRM', 'Salesforce', r'$262.21'),
  ('INTC', 'Intel', r'$34.52'),
];
