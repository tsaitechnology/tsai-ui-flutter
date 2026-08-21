import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import 'component_playground.dart';

enum ComponentDemoCategory {
  common('Common'),
  icons('Icons'),
  avatars('Avatars'),
  typography('Typography'),
  forms('Forms'),
  uiBlocks('UI Blocks'),
  layout('Layout'),
  appExamples('App examples');

  const ComponentDemoCategory(this.label);

  final String label;
}

enum ComponentDemoSection {
  badge(
    label: 'TsaiBadge',
    route: '/badges/badge',
    category: ComponentDemoCategory.common,
  ),
  badgeCounter(
    label: 'TsaiBadgeCounter',
    route: '/badges/counter',
    category: ComponentDemoCategory.common,
  ),
  badgeDot(
    label: 'TsaiBadgeDot',
    route: '/badges/dot',
    category: ComponentDemoCategory.common,
  ),
  chip(
    label: 'TsaiChip',
    route: '/chips/chip',
    category: ComponentDemoCategory.common,
  ),
  iconButton(
    label: 'TsaiIconButton',
    route: '/buttons/icon-button',
    category: ComponentDemoCategory.common,
  ),
  buttons(
    label: 'Buttons',
    route: '/buttons',
    category: ComponentDemoCategory.common,
  ),
  links(
    label: 'Links',
    route: '/links',
    category: ComponentDemoCategory.common,
  ),
  tsaiIcon(
    label: 'TsaiIcon',
    route: '/icons/tsai-icon',
    category: ComponentDemoCategory.icons,
  ),
  hitIcon(
    label: 'HitIcon',
    route: '/icons/hit-icon',
    category: ComponentDemoCategory.icons,
  ),
  circleIcon(
    label: 'CircleIcon',
    route: '/icons/circle-icon',
    category: ComponentDemoCategory.icons,
  ),
  cryptoIcon(
    label: 'Crypto Icon',
    route: '/icons/crypto-icon',
    category: ComponentDemoCategory.icons,
  ),
  avatar(
    label: 'Avatar',
    route: '/avatars/avatar',
    category: ComponentDemoCategory.avatars,
  ),
  userPill(
    label: 'UserPill',
    route: '/avatars/user-pill',
    category: ComponentDemoCategory.avatars,
  ),
  title(
    label: 'TsaiTitle',
    route: '/typography/title',
    category: ComponentDemoCategory.typography,
  ),
  textHeading(
    label: 'TsaiTextHeading',
    route: '/typography/heading',
    category: ComponentDemoCategory.typography,
  ),
  textBody(
    label: 'TsaiTextBody',
    route: '/typography/body',
    category: ComponentDemoCategory.typography,
  ),
  textButton(
    label: 'TsaiTextButton',
    route: '/typography/button-text',
    category: ComponentDemoCategory.typography,
  ),
  textCaption(
    label: 'TsaiTextCaption',
    route: '/typography/caption',
    category: ComponentDemoCategory.typography,
  ),
  textMonoHeading(
    label: 'TsaiTextMonoHeading',
    route: '/typography/mono-heading',
    category: ComponentDemoCategory.typography,
  ),
  textMonoBody(
    label: 'TsaiTextMonoBody',
    route: '/typography/mono-body',
    category: ComponentDemoCategory.typography,
  ),
  textMonoCaption(
    label: 'TsaiTextMonoCaption',
    route: '/typography/mono-caption',
    category: ComponentDemoCategory.typography,
  ),
  input(label: 'Input', route: '/input', category: ComponentDemoCategory.forms),
  inputSearch(
    label: 'Search Input',
    route: '/input-search',
    category: ComponentDemoCategory.forms,
  ),
  inputPhone(
    label: 'Phone Input',
    route: '/input-phone',
    category: ComponentDemoCategory.forms,
  ),
  inputOtp(
    label: 'OTP Input',
    route: '/input-otp',
    category: ComponentDemoCategory.forms,
  ),
  inputPin(
    label: 'PIN Input',
    route: '/input-pin',
    category: ComponentDemoCategory.forms,
  ),
  select(
    label: 'Select',
    route: '/select',
    category: ComponentDemoCategory.forms,
  ),
  checkbox(
    label: 'Checkbox',
    route: '/checkbox',
    category: ComponentDemoCategory.forms,
  ),
  radio(label: 'Radio', route: '/radio', category: ComponentDemoCategory.forms),
  switchControl(
    label: 'Switch',
    route: '/switch',
    category: ComponentDemoCategory.forms,
  ),
  sectionHeader(
    label: 'Section Header',
    route: '/ui-blocks/section-header',
    category: ComponentDemoCategory.uiBlocks,
  ),
  emptyState(
    label: 'Empty State',
    route: '/ui-blocks/empty-state',
    category: ComponentDemoCategory.uiBlocks,
  ),
  listItem(
    label: 'List Item',
    route: '/ui-blocks/list-item',
    category: ComponentDemoCategory.uiBlocks,
  ),
  list(
    label: 'List',
    route: '/ui-blocks/list',
    category: ComponentDemoCategory.uiBlocks,
  ),
  glow(
    label: 'Glow',
    route: '/effects/glow',
    category: ComponentDemoCategory.uiBlocks,
  ),
  toast(
    label: 'Toast',
    route: '/feedback/toast',
    category: ComponentDemoCategory.uiBlocks,
  ),
  inlineAlert(
    label: 'Inline Alert',
    route: '/feedback/inline-alert',
    category: ComponentDemoCategory.uiBlocks,
  ),
  progress(
    label: 'Progress',
    route: '/feedback/progress',
    category: ComponentDemoCategory.uiBlocks,
  ),
  skeleton(
    label: 'Skeleton',
    route: '/feedback/skeleton',
    category: ComponentDemoCategory.uiBlocks,
  ),
  card(
    label: 'Card',
    route: '/ui-blocks/card',
    category: ComponentDemoCategory.uiBlocks,
  ),
  tabsDocument(
    label: 'Tabs',
    route: '/tabs',
    category: ComponentDemoCategory.layout,
  ),
  bottomNavBar(
    label: 'Bottom Nav Bar',
    route: '/bottom-nav-bar',
    category: ComponentDemoCategory.layout,
  ),
  bottomSheet(
    label: 'Bottom Sheet',
    route: '/bottom-sheet',
    category: ComponentDemoCategory.layout,
  ),
  modalDialog(
    label: 'Modal Dialog',
    route: '/modal-dialog',
    category: ComponentDemoCategory.layout,
  ),
  homeTopBar(
    label: 'Home Top Bar',
    route: '/top-bars/home',
    category: ComponentDemoCategory.layout,
  ),
  pageTopBar(
    label: 'Page Top Bar',
    route: '/top-bars/page',
    category: ComponentDemoCategory.layout,
  ),
  pageWithTopBar(
    label: 'Page With Top Bar',
    route: '/top-bars/page-layout',
    category: ComponentDemoCategory.layout,
  ),
  pageWithSearchTopBar(
    label: 'Page With Search Top Bar',
    route: '/top-bars/page-search-layout',
    category: ComponentDemoCategory.layout,
  ),
  multiScreenApp(
    label: 'Multi-screen app example',
    route: '/app-examples/multi-screen',
    category: ComponentDemoCategory.appExamples,
  );

  const ComponentDemoSection({
    required this.label,
    required this.route,
    required this.category,
  });

  final String label;
  final String route;
  final ComponentDemoCategory category;
}

typedef AppExampleBuilder =
    Widget Function(BuildContext context, VoidCallback openCatalog);

class AppExampleWindow extends StatefulWidget {
  const AppExampleWindow({
    required this.section,
    required this.builder,
    super.key,
  });

  final ComponentDemoSection section;
  final AppExampleBuilder builder;

  @override
  State<AppExampleWindow> createState() => _AppExampleWindowState();
}

class _AppExampleWindowState extends State<AppExampleWindow> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _CatalogDrawer(
        section: widget.section,
        onSectionSelected: _openSection,
      ),
      body: SafeArea(
        child: widget.builder(
          context,
          () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ),
    );
  }

  void _openSection(ComponentDemoSection target) {
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    if (target != widget.section) {
      Navigator.of(context).pushReplacementNamed(target.route);
    }
  }
}

class ComponentDemoWindow extends StatefulWidget {
  const ComponentDemoWindow({
    required this.section,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.child,
    super.key,
  });

  final ComponentDemoSection section;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Widget child;

  @override
  State<ComponentDemoWindow> createState() => _ComponentDemoWindowState();
}

class _ComponentDemoWindowState extends State<ComponentDemoWindow> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _CatalogDrawer(
        section: widget.section,
        onSectionSelected: _openSection,
      ),
      body: SafeArea(
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.colors.canvas,
                border: Border(
                  bottom: BorderSide(
                    color: tokens.colors.borderSubtle,
                    width: tokens.borders.hairline,
                  ),
                ),
              ),
              child: HomeTopBar(
                dense: true,
                leading: [_CatalogTitle(label: widget.section.label)],
                trailing: [
                  HomeTopBarAction(
                    icon: TsaiIcon(_catalogThemeIcon(widget.themeMode)),
                    semanticLabel: _catalogThemeLabel(widget.themeMode),
                    onPressed: () => _toggleCatalogTheme(
                      widget.themeMode,
                      widget.onThemeModeChanged,
                    ),
                  ),
                  HomeTopBarAction(
                    icon: const TsaiIcon(LucideIcons.menu),
                    semanticLabel: 'Open component menu',
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
            ),
            Expanded(child: _DemoBody(child: widget.child)),
          ],
        ),
      ),
    );
  }

  void _openSection(ComponentDemoSection target) {
    Navigator.of(context).pop();
    if (target != widget.section) {
      Navigator.of(context).pushReplacementNamed(target.route);
    }
  }
}

class _CatalogTitle extends StatelessWidget {
  const _CatalogTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => TsaiTextHeading(
    label,
    size: TsaiHeadingSize.small,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

IconData _catalogThemeIcon(ThemeMode mode) =>
    mode == ThemeMode.dark ? LucideIcons.sun : LucideIcons.moon;

String _catalogThemeLabel(ThemeMode mode) =>
    mode == ThemeMode.dark ? 'Use light theme' : 'Use dark theme';

void _toggleCatalogTheme(ThemeMode mode, ValueChanged<ThemeMode> onChanged) =>
    onChanged(mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

class _CatalogDrawer extends StatelessWidget {
  const _CatalogDrawer({
    required this.section,
    required this.onSectionSelected,
  });

  final ComponentDemoSection section;
  final ValueChanged<ComponentDemoSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Drawer(
      width: MediaQuery.sizeOf(context).width.clamp(280, 360),
      backgroundColor: tokens.colors.canvas,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                tokens.spacing.space24,
                tokens.spacing.space16,
                tokens.spacing.space16,
                tokens.spacing.space8,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TsaiTextHeading(
                      'Tsai UI',
                      size: TsaiHeadingSize.medium,
                    ),
                  ),
                  PageTopBarAction(
                    icon: const TsaiIcon(LucideIcons.x),
                    semanticLabel: 'Close component menu',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  tokens.spacing.space16,
                  tokens.spacing.space8,
                  tokens.spacing.space16,
                  tokens.spacing.space24,
                ),
                children: [
                  for (final category in ComponentDemoCategory.values)
                    _DrawerCategory(
                      category: category,
                      selected: section,
                      onSelected: onSectionSelected,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBody extends StatelessWidget {
  const _DemoBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => ComponentPlaygroundViewport(
      height: constraints.maxHeight,
      child: SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: child,
      ),
    ),
  );
}

class _DrawerCategory extends StatelessWidget {
  const _DrawerCategory({
    required this.category,
    required this.selected,
    required this.onSelected,
  });

  final ComponentDemoCategory category;
  final ComponentDemoSection selected;
  final ValueChanged<ComponentDemoSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final sections = ComponentDemoSection.values
        .where((item) => item.category == category)
        .toList(growable: false);
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacing.space8,
              vertical: tokens.spacing.space4,
            ),
            child: TsaiTextCaption(
              category.label,
              size: TsaiCaptionSize.medium,
              weight: TsaiTextWeight.medium,
              color: tokens.colors.contentSecondary,
            ),
          ),
          for (final item in sections)
            _DrawerDestination(
              item: item,
              selected: item == selected,
              onPressed: () => onSelected(item),
            ),
        ],
      ),
    );
  }
}

class _DrawerDestination extends StatelessWidget {
  const _DrawerDestination({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final ComponentDemoSection item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Material(
      color: selected ? tokens.colors.surfaceAccent : Colors.transparent,
      borderRadius: BorderRadius.circular(tokens.radii.small),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(tokens.radii.small),
        splashFactory: NoSplash.splashFactory,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.space12,
            vertical: tokens.spacing.space12,
          ),
          child: TsaiTextBody(
            item.label,
            size: TsaiBodySize.medium,
            weight: selected ? TsaiTextWeight.medium : TsaiTextWeight.regular,
          ),
        ),
      ),
    );
  }
}
