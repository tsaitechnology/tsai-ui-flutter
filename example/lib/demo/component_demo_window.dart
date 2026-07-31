import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

enum ComponentDemoCategory {
  common('Common'),
  typography('Typography'),
  forms('Forms'),
  layout('Layout');

  const ComponentDemoCategory(this.label);

  final String label;
}

enum ComponentDemoSection {
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
  icons(
    label: 'Icons',
    route: '/icons',
    category: ComponentDemoCategory.common,
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
                leading: [_CatalogTitle(label: widget.section.label)],
                trailing: [
                  Tooltip(
                    message: widget.themeMode == ThemeMode.dark
                        ? 'Use light theme'
                        : 'Use dark theme',
                    child: TsaiSwitch(
                      value: widget.themeMode == ThemeMode.dark,
                      semanticLabel: widget.themeMode == ThemeMode.dark
                          ? 'Use light theme'
                          : 'Use dark theme',
                      onChanged: (value) => widget.onThemeModeChanged(
                        value ? ThemeMode.dark : ThemeMode.light,
                      ),
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
            Expanded(
              child: _DemoBody(
                edgeToEdge:
                    widget.section.category == ComponentDemoCategory.layout,
                child: widget.child,
              ),
            ),
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
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final reservedWidth =
        tokens.spacing.space16 * 2 +
        tokens.spacing.space8 * 2 +
        tokens.spacing.space48 +
        (tokens.spacing.space32 + tokens.spacing.space8);
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - reservedWidth).clamp(0, 720),
      child: TsaiTextHeading(
        label,
        size: TsaiHeadingSize.small,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

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
  const _DemoBody({required this.edgeToEdge, required this.child});

  final bool edgeToEdge;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (edgeToEdge) {
      return child;
    }
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SizedBox(
          width: constraints.maxWidth.clamp(0, 1120),
          height: constraints.maxHeight,
          child: child,
        ),
      ),
    );
  }
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
