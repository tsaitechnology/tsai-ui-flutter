import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';

class AppWithTwoPagesExampleScreen extends StatelessWidget {
  const AppWithTwoPagesExampleScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => AppExampleWindow(
    section: ComponentDemoSection.appWithTwoPages,
    builder: (context, openCatalog) => AppWithTwoPagesExample(
      themeMode: themeMode,
      onThemeModeChanged: onThemeModeChanged,
      onOpenCatalog: openCatalog,
    ),
  );
}

class AppWithTwoPagesExample extends StatefulWidget {
  const AppWithTwoPagesExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;

  @override
  State<AppWithTwoPagesExample> createState() => _AppWithTwoPagesExampleState();
}

class _AppWithTwoPagesExampleState extends State<AppWithTwoPagesExample> {
  static const _navigationItems = [
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.house, size: 20),
      label: 'Home',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.file_text, size: 20),
      label: 'Form',
    ),
  ];

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Stack(
    key: const ValueKey<String>('app-with-two-pages-example'),
    fit: StackFit.expand,
    children: [
      IndexedStack(
        key: const ValueKey<String>('app-example-pages'),
        index: _selectedIndex,
        children: [
          HomeScreenExample(
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
            onOpenCatalog: widget.onOpenCatalog,
          ),
          FormScreenExample(
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
            onOpenCatalog: widget.onOpenCatalog,
            onShowHome: () => setState(() => _selectedIndex = 0),
          ),
        ],
      ),
      PositionedDirectional(
        start: 0,
        end: 0,
        bottom: 0,
        child: BottomNavBar(
          items: _navigationItems,
          selectedIndex: _selectedIndex,
          onSelected: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    ],
  );
}

class HomeScreenExample extends StatefulWidget {
  const HomeScreenExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;

  @override
  State<HomeScreenExample> createState() => _HomeScreenExampleState();
}

class _HomeScreenExampleState extends State<HomeScreenExample> {
  String? _country = 'uy';

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ColoredBox(
      color: tokens.colors.canvas,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            key: const ValueKey<String>('home-screen-scroll'),
            padding: EdgeInsets.only(
              top: tokens.spacing.space64 + tokens.spacing.space12,
              bottom: tokens.spacing.space64 + 62,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: tokens.spacing.space16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: tokens.spacing.space24),
                      const TsaiTextHeading(
                        'Good morning',
                        size: TsaiHeadingSize.large,
                      ),
                      SizedBox(height: tokens.spacing.space4),
                      TsaiTextBody(
                        'Your accounts and recent activity are up to date.',
                        size: TsaiBodySize.large,
                        weight: TsaiTextWeight.regular,
                        color: tokens.colors.contentSecondary,
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      _BalanceSummary(
                        key: const ValueKey<String>('home-balance-summary'),
                        tokens: tokens,
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      const TsaiTextHeading(
                        'Quick actions',
                        size: TsaiHeadingSize.small,
                      ),
                      SizedBox(height: tokens.spacing.space12),
                      const Row(
                        children: [
                          Expanded(
                            child: _QuickAction(
                              icon: LucideIcons.send,
                              label: 'Transfer',
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _QuickAction(
                              icon: LucideIcons.receipt,
                              label: 'Pay',
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _QuickAction(
                              icon: LucideIcons.wallet_cards,
                              label: 'Cards',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      const TsaiTextHeading(
                        'Spending region',
                        size: TsaiHeadingSize.small,
                      ),
                      SizedBox(height: tokens.spacing.space12),
                      TsaiSelect<String>(
                        key: const ValueKey<String>('home-country-select'),
                        options: _countryOptions,
                        value: _country,
                        placeholder: 'Country',
                        description: 'Used for regional account insights.',
                        presentation: TsaiSelectPresentation.cupertinoPicker,
                        onChanged: (value) => setState(() => _country = value),
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      const _ActivityList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: HomeTopBar(
              leading: const [UserPill(name: 'Ilona T.', initials: 'IT')],
              trailing: [
                HomeTopBarAction(
                  icon: TsaiIcon(_themeIcon(widget.themeMode)),
                  semanticLabel: _themeLabel(widget.themeMode),
                  onPressed: () =>
                      _toggleTheme(widget.themeMode, widget.onThemeModeChanged),
                ),
                HomeTopBarAction(
                  icon: const TsaiIcon(LucideIcons.bell),
                  semanticLabel: 'Notifications',
                  showIndicator: true,
                  onPressed: () {},
                ),
                HomeTopBarAction(
                  icon: const TsaiIcon(LucideIcons.menu),
                  semanticLabel: 'Open component menu',
                  onPressed: widget.onOpenCatalog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FormScreenExample extends StatefulWidget {
  const FormScreenExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    required this.onShowHome,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;
  final VoidCallback onShowHome;

  @override
  State<FormScreenExample> createState() => _FormScreenExampleState();
}

class _FormScreenExampleState extends State<FormScreenExample> {
  String? _country = 'uy';
  bool? _updatesEnabled = true;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return PageWithTopBar(
      key: const ValueKey<String>('form-screen-page'),
      heading: 'Profile details',
      subtitle: 'Personal and account information',
      leading: [
        PageTopBarAction(
          icon: const TsaiIcon(LucideIcons.arrow_left),
          semanticLabel: 'Back to home',
          onPressed: widget.onShowHome,
        ),
      ],
      trailing: [
        PageTopBarAction(
          icon: TsaiIcon(_themeIcon(widget.themeMode)),
          semanticLabel: _themeLabel(widget.themeMode),
          onPressed: () =>
              _toggleTheme(widget.themeMode, widget.onThemeModeChanged),
        ),
        PageTopBarAction(
          icon: const TsaiIcon(LucideIcons.menu),
          semanticLabel: 'Open component menu',
          onPressed: widget.onOpenCatalog,
        ),
      ],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            key: const ValueKey<String>('form-screen-content'),
            padding: EdgeInsets.fromLTRB(
              tokens.spacing.space16,
              tokens.spacing.space24,
              tokens.spacing.space16,
              tokens.spacing.space64 + 62,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TsaiTextHeading(
                  'Personal information',
                  size: TsaiHeadingSize.small,
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  key: ValueKey<String>('first-name-input'),
                  initialValue: 'Ilona',
                  placeholder: 'First name',
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  key: ValueKey<String>('last-name-input'),
                  initialValue: 'Taylor',
                  placeholder: 'Last name',
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  initialValue: 'ilona@example.com',
                  placeholder: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  description: 'Account notifications are sent here.',
                ),
                SizedBox(height: tokens.spacing.space24),
                const TsaiTextHeading(
                  'Location and work',
                  size: TsaiHeadingSize.small,
                ),
                SizedBox(height: tokens.spacing.space16),
                TsaiSelect<String>(
                  key: const ValueKey<String>('form-country-select'),
                  options: _countryOptions,
                  value: _country,
                  placeholder: 'Country',
                  presentation: TsaiSelectPresentation.cupertinoPicker,
                  onChanged: (value) => setState(() => _country = value),
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  initialValue: 'Montevideo',
                  placeholder: 'City',
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  initialValue: 'Tsai Technology',
                  placeholder: 'Company',
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  initialValue: 'Product designer',
                  placeholder: 'Role',
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: tokens.spacing.space24),
                const TsaiTextHeading('Security', size: TsaiHeadingSize.small),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInput(
                  initialValue: 'correct horse battery staple',
                  placeholder: 'Password',
                  obscureText: true,
                  showVisibilityButton: true,
                  description: 'Use at least 12 characters.',
                ),
                SizedBox(height: tokens.spacing.space20),
                TsaiCheckbox(
                  value: _updatesEnabled,
                  label: 'Product updates',
                  description: 'Receive occasional account and product news.',
                  onChanged: (value) => setState(() => _updatesEnabled = value),
                ),
                SizedBox(height: tokens.spacing.space24),
                TsaiButton(
                  label: 'Save changes',
                  isExpanded: true,
                  leadingIcon: const TsaiIcon(
                    LucideIcons.circle_check,
                    size: 16,
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: tokens.spacing.space12),
                TsaiButton(
                  label: 'Cancel',
                  isExpanded: true,
                  variant: TsaiButtonVariant.ghost,
                  onPressed: widget.onShowHome,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.tokens, super.key});

  final TsaiThemeTokens tokens;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(tokens.spacing.space20),
    decoration: BoxDecoration(
      color: tokens.colors.surfaceRaised,
      border: Border.all(
        color: tokens.colors.borderSubtle,
        width: tokens.borders.hairline,
      ),
      borderRadius: BorderRadius.circular(tokens.radii.medium),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TsaiTextCaption(
          'Available balance',
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.medium,
          color: tokens.colors.contentSecondary,
        ),
        SizedBox(height: tokens.spacing.space8),
        const TsaiTextHeading(r'$24,891.42', size: TsaiHeadingSize.extraLarge),
        SizedBox(height: tokens.spacing.space4),
        TsaiTextBody(
          '+2.4% this month',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.medium,
          color: tokens.colors.accentSuccess,
        ),
        SizedBox(height: tokens.spacing.space20),
        Wrap(
          spacing: tokens.spacing.space8,
          runSpacing: tokens.spacing.space8,
          children: [
            TsaiButton(
              label: 'Add funds',
              size: TsaiButtonSize.medium,
              leadingIcon: const TsaiIcon(LucideIcons.plus, size: 16),
              onPressed: () {},
            ),
            TsaiButton(
              label: 'Transfer',
              size: TsaiButtonSize.medium,
              variant: TsaiButtonVariant.secondary,
              leadingIcon: const TsaiIcon(LucideIcons.send, size: 16),
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Material(
      color: tokens.colors.surfaceRaised,
      borderRadius: BorderRadius.circular(tokens.radii.medium),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        splashFactory: NoSplash.splashFactory,
        child: SizedBox(
          height: 88,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TsaiIcon(icon, size: 20, color: tokens.colors.iconPrimary),
              SizedBox(height: tokens.spacing.space8),
              TsaiTextCaption(
                label,
                size: TsaiCaptionSize.medium,
                weight: TsaiTextWeight.medium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return TsaiList(
      title: 'Recent activity',
      headerTrailingIcon: const TsaiIcon(LucideIcons.search),
      items: [
        for (final activity in _activities)
          TsaiListItem(
            icon: TsaiIcon(activity.icon, size: 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TsaiTextBody(
                  activity.title,
                  size: TsaiBodySize.medium,
                  weight: TsaiTextWeight.medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: tokens.spacing.space2),
                TsaiTextCaption(
                  activity.subtitle,
                  size: TsaiCaptionSize.medium,
                  weight: TsaiTextWeight.regular,
                  color: tokens.colors.contentTertiary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TsaiTextMonoBody(
                  activity.amount,
                  size: TsaiBodySize.medium,
                  color: activity.incoming
                      ? tokens.colors.accentSuccess
                      : tokens.colors.contentPrimary,
                ),
                SizedBox(height: tokens.spacing.space2),
                TsaiTextCaption(
                  activity.time,
                  size: TsaiCaptionSize.medium,
                  weight: TsaiTextWeight.regular,
                  color: tokens.colors.contentTertiary,
                ),
              ],
            ),
          ),
      ],
      button: TsaiButton(
        label: 'View all activity',
        size: TsaiButtonSize.medium,
        variant: TsaiButtonVariant.outline,
        isExpanded: true,
        leadingIcon: const TsaiIcon(LucideIcons.receipt_text, size: 16),
        onPressed: () {},
      ),
    );
  }
}

@immutable
class _Activity {
  const _Activity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    this.incoming = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final bool incoming;
}

const _countryOptions = [
  TsaiSelectOption(
    value: 'us',
    label: 'United States',
    icon: TsaiIcon.emoji('🇺🇸', size: 20),
  ),
  TsaiSelectOption(
    value: 'uy',
    label: 'Uruguay',
    icon: TsaiIcon.emoji('🇺🇾', size: 20),
  ),
  TsaiSelectOption(
    value: 'br',
    label: 'Brazil',
    icon: TsaiIcon.emoji('🇧🇷', size: 20),
  ),
  TsaiSelectOption(
    value: 'ar',
    label: 'Argentina',
    icon: TsaiIcon.emoji('🇦🇷', size: 20),
  ),
];

const _activities = [
  _Activity(
    icon: LucideIcons.briefcase,
    title: 'Tsai Technology',
    subtitle: 'Salary · Today',
    amount: r'+$4,800.00',
    time: '10:00',
    incoming: true,
  ),
  _Activity(
    icon: LucideIcons.receipt,
    title: 'Market Central',
    subtitle: 'Groceries · Yesterday',
    amount: r'-$86.20',
    time: '18:42',
  ),
  _Activity(
    icon: LucideIcons.building_2,
    title: 'Studio rent',
    subtitle: 'Transfer · Jul 29',
    amount: r'-$1,240.00',
    time: '09:12',
  ),
  _Activity(
    icon: LucideIcons.wallet,
    title: 'Savings transfer',
    subtitle: 'Internal · Jul 28',
    amount: r'-$600.00',
    time: '14:05',
  ),
  _Activity(
    icon: LucideIcons.receipt_text,
    title: 'Cloud services',
    subtitle: 'Software · Jul 27',
    amount: r'-$42.00',
    time: '21:47',
  ),
  _Activity(
    icon: LucideIcons.landmark,
    title: 'Interest payment',
    subtitle: 'Income · Jul 25',
    amount: r'+$18.42',
    time: '08:30',
    incoming: true,
  ),
  _Activity(
    icon: LucideIcons.map_pin,
    title: 'Corner coffee',
    subtitle: 'Dining · Jul 24',
    amount: r'-$7.80',
    time: '16:15',
  ),
];

IconData _themeIcon(ThemeMode mode) =>
    mode == ThemeMode.dark ? LucideIcons.sun : LucideIcons.moon;

String _themeLabel(ThemeMode mode) =>
    mode == ThemeMode.dark ? 'Use light theme' : 'Use dark theme';

void _toggleTheme(ThemeMode mode, ValueChanged<ThemeMode> onChanged) =>
    onChanged(mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
