import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';

class MultiScreenAppExampleScreen extends StatelessWidget {
  const MultiScreenAppExampleScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => AppExampleWindow(
    section: ComponentDemoSection.multiScreenApp,
    builder: (context, openCatalog) => MultiScreenAppExample(
      themeMode: themeMode,
      onThemeModeChanged: onThemeModeChanged,
      onOpenCatalog: openCatalog,
    ),
  );
}

class MultiScreenAppExample extends StatefulWidget {
  const MultiScreenAppExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;

  @override
  State<MultiScreenAppExample> createState() => _MultiScreenAppExampleState();
}

class _MultiScreenAppExampleState extends State<MultiScreenAppExample>
    with WidgetsBindingObserver {
  static const _navigationItems = [
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.house, size: 20),
      label: 'Home',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.user_round, size: 20),
      label: 'Account',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.badge_check, size: 20),
      label: 'Verify',
    ),
    BottomNavBarItem(icon: TsaiIcon(LucideIcons.send, size: 20), label: 'Pay'),
  ];

  var _selectedIndex = 0;
  var _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Read from the FlutterView: a parent Scaffold may already have stripped
    // ambient MediaQuery.viewInsets for its body, so viewInsetsOf(context)
    // can stay 0 while the keyboard is open.
    final next =
        MediaQueryData.fromView(View.of(context)).viewInsets.bottom > 0;
    if (next == _keyboardVisible) {
      return;
    }
    setState(() => _keyboardVisible = next);
  }

  @override
  Widget build(BuildContext context) {
    // Keep the shell's default Scaffold resize behavior so focused fields can
    // scroll into view. Hide the overlay nav while the keyboard is open so it
    // does not ride up and cover the active input. iOS and Android both report
    // keyboard coverage through viewInsets.
    return Stack(
      key: const ValueKey<String>('multi-screen-app-example'),
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
              onOpenPay: () => setState(() => _selectedIndex = 3),
              onOpenCards: () => setState(() => _selectedIndex = 1),
            ),
            FormScreenExample(
              themeMode: widget.themeMode,
              onThemeModeChanged: widget.onThemeModeChanged,
              onOpenCatalog: widget.onOpenCatalog,
              onShowHome: () => setState(() => _selectedIndex = 0),
            ),
            KycScreenExample(
              isActive: _selectedIndex == 2,
              themeMode: widget.themeMode,
              onThemeModeChanged: widget.onThemeModeChanged,
              onOpenCatalog: widget.onOpenCatalog,
            ),
            PurchaseScreenExample(
              themeMode: widget.themeMode,
              onThemeModeChanged: widget.onThemeModeChanged,
              onOpenCatalog: widget.onOpenCatalog,
            ),
          ],
        ),
        if (!_keyboardVisible)
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
}

class HomeScreenExample extends StatefulWidget {
  const HomeScreenExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    required this.onOpenPay,
    required this.onOpenCards,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;
  final VoidCallback onOpenPay;
  final VoidCallback onOpenCards;

  @override
  State<HomeScreenExample> createState() => _HomeScreenExampleState();
}

class _HomeScreenExampleState extends State<HomeScreenExample> {
  final _cardController = PageController();
  String? _currency = 'usd';
  var _cardIndex = 0;
  var _balanceHidden = false;

  static const _cards = [
    TsaiBankCard(number: '•••• 4821', network: 'VISA'),
    TsaiBankCard(wordmark: 'tsaitech', number: '•••• 9033', network: 'MC'),
    TsaiBankCard(wordmark: 'virtual', number: '•••• 1174', network: 'VISA'),
  ];

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _openNotifications(BuildContext context) => showTsaiModalDialog<void>(
    context: context,
    title: 'Notifications',
    message: 'Identity review is waiting on one supporting document.',
    icon: const TsaiIcon(LucideIcons.bell),
    primaryAction: Builder(
      builder: (dialogContext) => TsaiButton(
        label: 'Got it',
        onPressed: () => Navigator.of(dialogContext).pop(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ColoredBox(
      color: tokens.colors.canvas,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const PositionedDirectional(
            top: -120,
            end: -160,
            child: TsaiGlow(diameter: 360, blurRadius: 130),
          ),
          SingleChildScrollView(
            key: const ValueKey<String>('home-screen-scroll'),
            padding: EdgeInsets.only(
              top: tokens.spacing.space64 + tokens.spacing.space12,
              bottom: tokens.spacing.space64 + 62,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HomeMaxWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: tokens.spacing.space24),
                      Row(
                        children: [
                          const Expanded(
                            child: TsaiTextHeading(
                              'Good morning, Ilona',
                              size: TsaiHeadingSize.large,
                            ),
                          ),
                          TsaiIconButton(
                            icon: TsaiIcon(
                              _balanceHidden
                                  ? LucideIcons.eye_off
                                  : LucideIcons.eye,
                            ),
                            onPressed: () => setState(
                              () => _balanceHidden = !_balanceHidden,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spacing.space4),
                      TsaiTextBody(
                        'Everyday account · Montevideo',
                        size: TsaiBodySize.large,
                        weight: TsaiTextWeight.regular,
                        color: tokens.colors.contentSecondary,
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      _BalanceHero(
                        key: const ValueKey<String>('home-balance-summary'),
                        hidden: _balanceHidden,
                        currency: _currency,
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TsaiActionTile(
                            key: const ValueKey<String>('quick-transfer'),
                            icon: const TsaiIcon(LucideIcons.send),
                            label: 'Send',
                            onPressed: () => _openTransfer(context),
                          ),
                          SizedBox(width: tokens.spacing.space24),
                          TsaiActionTile(
                            key: const ValueKey<String>('quick-pay'),
                            icon: const TsaiIcon(LucideIcons.receipt),
                            label: 'Pay',
                            onPressed: widget.onOpenPay,
                          ),
                          SizedBox(width: tokens.spacing.space24),
                          TsaiActionTile(
                            icon: const TsaiIcon(LucideIcons.wallet_cards),
                            label: 'Cards',
                            onPressed: widget.onOpenCards,
                          ),
                          SizedBox(width: tokens.spacing.space24),
                          TsaiActionTile(
                            icon: const TsaiIcon(LucideIcons.plus),
                            label: 'Top up',
                            onPressed: () => _openTopUp(context),
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TsaiBadge(
                            label: 'Account verified',
                            tone: TsaiBadgeTone.success,
                            showDot: true,
                          ),
                          TsaiBadgeCounter(value: 3),
                          TsaiChip(
                            label: 'Personal',
                            selected: true,
                            showCheck: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tokens.spacing.space24),
                SizedBox(
                  height: 214,
                  child: PageView(
                    key: const ValueKey<String>('home-card-pager'),
                    controller: _cardController,
                    clipBehavior: Clip.none,
                    onPageChanged: (index) =>
                        setState(() => _cardIndex = index),
                    children: [for (final card in _cards) Center(child: card)],
                  ),
                ),
                SizedBox(height: tokens.spacing.space16),
                _HomeMaxWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: TsaiPageIndicator(
                          count: _cards.length,
                          index: _cardIndex,
                        ),
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      TsaiSelect<String>(
                        key: const ValueKey<String>('home-country-select'),
                        options: _currencyOptions,
                        value: _currency,
                        placeholder: 'Display currency',
                        description: 'Balances convert using midday rates.',
                        onChanged: (value) => setState(() => _currency = value),
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      TsaiTabs(
                        sections: [
                          TsaiTabSection.text(
                            label: 'Activity',
                            content: const _ActivityList(),
                          ),
                          TsaiTabSection.text(
                            label: 'Investments',
                            content: _InvestmentTabContent(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
                  onPressed: () => _openNotifications(context),
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

  Future<void> _openTransfer(BuildContext context) async {
    await showTsaiBottomSheet<void>(
      context: context,
      title: 'Transfer money',
      size: TsaiBottomSheetSize.full,
      child: const _TransferComposer(),
    );
  }

  Future<void> _openTopUp(BuildContext context) async {
    await showTsaiBottomSheet<void>(
      context: context,
      title: 'Add funds',
      size: TsaiBottomSheetSize.half,
      child: const TsaiTextBody(
        'Link a bank account or debit card to add funds the same day.',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
      ),
      primaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Start setup',
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    );
  }
}

class _HomeMaxWidth extends StatelessWidget {
  const _HomeMaxWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
          child: child,
        ),
      ),
    );
  }
}

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({required this.hidden, required this.currency, super.key});

  final bool hidden;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final value = switch (currency) {
      'uyu' => r'$U 978,420.00',
      'eur' => r'€22,410.18',
      _ => r'$24,562.80',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TsaiAmountDisplay(
          caption: 'Total balance',
          value: hidden ? '••••••••' : value,
          subtitle: hidden ? 'Hidden' : '+2.2% this month',
          subtitleColor: hidden
              ? tokens.colors.contentTertiary
              : tokens.colors.accentSuccess,
        ),
        SizedBox(height: tokens.spacing.space16),
        Row(
          children: const [
            CircleIcon(
              icon: TsaiIcon(LucideIcons.coins),
              semanticLabel: 'Account balance',
            ),
            SizedBox(width: 8),
            Avatar(initials: 'IT', semanticLabel: 'Ilona Taylor'),
            SizedBox(width: 8),
            TsaiCryptoIcon(TsaiCryptoAsset.usdc, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: TsaiTextBody(
                'USD · USDC pocket',
                size: TsaiBodySize.medium,
                weight: TsaiTextWeight.medium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TransferComposer extends StatefulWidget {
  const _TransferComposer();

  @override
  State<_TransferComposer> createState() => _TransferComposerState();
}

class _TransferComposerState extends State<_TransferComposer> {
  var _amount = '120.00';

  void _append(String digit) {
    setState(() {
      final next = _amount == '0' ? digit : '$_amount$digit';
      if (next.replaceAll('.', '').length > 8) {
        return;
      }
      _amount = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TsaiAmountDisplay(
          caption: 'You send',
          value: '\$$_amount',
          subtitle: 'From everyday account',
          alignment: TsaiAmountAlignment.center,
        ),
        SizedBox(height: tokens.spacing.space24),
        FittedBox(
          child: TsaiNumericKeypad(
            onDigit: _append,
            onDecimal: () {
              if (_amount.contains('.')) {
                return;
              }
              setState(() => _amount = '$_amount.');
            },
            onBackspace: () {
              setState(() {
                if (_amount.length <= 1) {
                  _amount = '0';
                  return;
                }
                _amount = _amount.substring(0, _amount.length - 1);
              });
            },
          ),
        ),
        SizedBox(height: tokens.spacing.space16),
        TsaiButton(
          label: 'Continue',
          isExpanded: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        SizedBox(height: tokens.spacing.space8),
        TsaiButton(
          label: 'Cancel',
          isExpanded: true,
          variant: TsaiButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
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
  String _accountType = 'personal';
  var _twoFactorEnabled = true;
  var _contactless = true;
  var _spendLimit = 2500.0;
  String? _faq = 'limits';

  void _saveProfile() => showTsaiModalDialog<void>(
    context: context,
    title: 'Profile saved',
    message: 'Your card controls and personal details are up to date.',
    icon: const TsaiIcon(LucideIcons.circle_check),
    primaryAction: Builder(
      builder: (dialogContext) => TsaiButton(
        label: 'Continue',
        onPressed: () => Navigator.of(dialogContext).pop(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return PageWithTopBar(
      key: const ValueKey<String>('form-screen-page'),
      heading: 'Account',
      subtitle: 'Profile, cards, and limits',
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
      body: SingleChildScrollView(
        child: Center(
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
                  const Center(
                    child: TsaiBankCard(number: '•••• 4821', network: 'VISA'),
                  ),
                  SizedBox(height: tokens.spacing.space24),
                  TsaiSectionHeader(
                    title: 'Daily spend limit',
                    trailingIcon: const TsaiIcon(LucideIcons.info),
                    trailingIconSemanticLabel: 'Limit details',
                    onTrailingIconPressed: () => showTsaiModalDialog<void>(
                      context: context,
                      title: 'Daily limit',
                      message:
                          'Contactless payments pause automatically when the limit is reached.',
                      icon: const TsaiIcon(LucideIcons.shield_check),
                      primaryAction: Builder(
                        builder: (dialogContext) => TsaiButton(
                          label: 'Close',
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: tokens.spacing.space8),
                  TsaiTextMonoBody(
                    '\$${_spendLimit.round()}',
                    size: TsaiBodySize.large,
                  ),
                  SizedBox(height: tokens.spacing.space12),
                  TsaiSlider(
                    value: _spendLimit,
                    min: 200,
                    max: 5000,
                    semanticLabel: 'Daily spend limit',
                    onChanged: (value) => setState(() => _spendLimit = value),
                  ),
                  SizedBox(height: tokens.spacing.space20),
                  TsaiSwitch(
                    value: _contactless,
                    label: 'Contactless payments',
                    description: 'Tap to pay with this physical card.',
                    onChanged: (value) => setState(() => _contactless = value),
                  ),
                  SizedBox(height: tokens.spacing.space24),
                  const TsaiTextHeading(
                    'Card help',
                    size: TsaiHeadingSize.small,
                  ),
                  TsaiAccordion(
                    title: 'What counts toward the limit?',
                    body:
                        'In-store, online, and wallet taps share the same daily cap. Bank transfers do not.',
                    expanded: _faq == 'limits',
                    showDivider: true,
                    onChanged: (open) =>
                        setState(() => _faq = open ? 'limits' : null),
                  ),
                  TsaiAccordion(
                    title: 'How do I freeze a card?',
                    body:
                        'Open the card, turn off contactless, then use Freeze card from the overflow menu. You can unfreeze instantly.',
                    expanded: _faq == 'freeze',
                    showDivider: true,
                    onChanged: (open) =>
                        setState(() => _faq = open ? 'freeze' : null),
                  ),
                  TsaiAccordion(
                    title: 'Virtual cards',
                    body:
                        'Create a virtual card for subscriptions. It uses the same balance and can be deleted without replacing the physical card.',
                    expanded: _faq == 'virtual',
                    onChanged: (open) =>
                        setState(() => _faq = open ? 'virtual' : null),
                  ),
                  SizedBox(height: tokens.spacing.space24),
                  const TsaiDivider(),
                  SizedBox(height: tokens.spacing.space24),
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
                    description: 'Statements and security alerts go here.',
                  ),
                  SizedBox(height: tokens.spacing.space24),
                  const TsaiTextHeading(
                    'Account type',
                    size: TsaiHeadingSize.small,
                  ),
                  SizedBox(height: tokens.spacing.space16),
                  TsaiRadio<String>(
                    value: 'personal',
                    groupValue: _accountType,
                    label: 'Personal account',
                    description: 'Everyday spending and transfers.',
                    onChanged: (value) => setState(() => _accountType = value!),
                  ),
                  SizedBox(height: tokens.spacing.space8),
                  TsaiRadio<String>(
                    value: 'business',
                    groupValue: _accountType,
                    label: 'Business account',
                    description: 'Invoices and team payments.',
                    onChanged: (value) => setState(() => _accountType = value!),
                  ),
                  SizedBox(height: tokens.spacing.space16),
                  TsaiSelect<String>(
                    key: const ValueKey<String>('form-country-select'),
                    options: _countryOptions,
                    value: _country,
                    placeholder: 'Country of residence',
                    onChanged: (value) => setState(() => _country = value),
                  ),
                  SizedBox(height: tokens.spacing.space24),
                  const TsaiTextHeading(
                    'Security',
                    size: TsaiHeadingSize.small,
                  ),
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
                    description: 'Occasional account and product news.',
                    onChanged: (value) =>
                        setState(() => _updatesEnabled = value),
                  ),
                  SizedBox(height: tokens.spacing.space16),
                  TsaiSwitch(
                    value: _twoFactorEnabled,
                    label: 'Require two-step approval',
                    description: 'Confirm outgoing payments on this device.',
                    onChanged: (value) =>
                        setState(() => _twoFactorEnabled = value),
                  ),
                  SizedBox(height: tokens.spacing.space24),
                  TsaiButton(
                    label: 'Save changes',
                    isExpanded: true,
                    leadingIcon: const TsaiIcon(
                      LucideIcons.circle_check,
                      size: 16,
                    ),
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KycScreenExample extends StatefulWidget {
  const KycScreenExample({
    required this.isActive,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    super.key,
  });

  final bool isActive;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;

  @override
  State<KycScreenExample> createState() => _KycScreenExampleState();
}

class _KycScreenExampleState extends State<KycScreenExample> {
  static const _loadDuration = Duration(seconds: 3);

  var _step = 0;
  var _documentUploaded = false;
  var _consentGiven = false;
  var _documentType = 'passport';
  var _yearsAtAddress = 3;
  var _isLoading = true;
  Timer? _loadTimer;

  void _advanceKyc() {
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    showTsaiModalDialog<void>(
      context: context,
      title: 'Identity submitted',
      message:
          'Your documents are queued for review. We will notify you shortly.',
      icon: const TsaiIcon(LucideIcons.circle_check),
      primaryAction: Builder(
        builder: (dialogContext) => TsaiButton(
          label: 'Done',
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _startLoad();
    }
  }

  @override
  void didUpdateWidget(KycScreenExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive && _isLoading) {
      _startLoad();
    }
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  void _startLoad() {
    if (_loadTimer != null) {
      return;
    }
    _loadTimer = Timer(_loadDuration, () {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
    });
  }

  Future<void> _uploadDocument() async {
    setState(() => _documentUploaded = true);
    await showTsaiToast(
      context: context,
      variant: TsaiToastVariant.action,
      message: 'Document ready to review',
      actionLabel: 'Review',
      bottomClearance: _toastBottomClearance(context),
      onAction: () => setState(() => _step = 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return PageWithTopBar(
      key: const ValueKey<String>('kyc-screen-page'),
      heading: 'Verify your identity',
      subtitle: 'Required to raise your transfer limits',
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
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                tokens.spacing.space16,
                tokens.spacing.space24,
                tokens.spacing.space16,
                tokens.spacing.space64 + 62,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isLoading)
                    _KycLoadingState()
                  else ...[
                    Center(child: TsaiPageIndicator(count: 3, index: _step)),
                    SizedBox(height: tokens.spacing.space16),
                    TsaiProgressBar(
                      value: (_step + 1) / 3,
                      label: 'Verification progress',
                      labelPosition: TsaiProgressBarLabelPosition.top,
                    ),
                    SizedBox(height: tokens.spacing.space16),
                    TsaiInlineAlert(
                      tone: _step == 2
                          ? TsaiInlineAlertTone.success
                          : TsaiInlineAlertTone.info,
                      title: 'Step ${_step + 1} of 3',
                      message: switch (_step) {
                        0 => 'Confirm the mobile number we should text.',
                        1 => 'Upload one government-issued document.',
                        _ => 'Review details and consent to continue.',
                      },
                    ),
                    SizedBox(height: tokens.spacing.space20),
                    TsaiCard(
                      title: switch (_step) {
                        0 => 'Contact details',
                        1 => 'Identity document',
                        _ => 'Final review',
                      },
                      trailing: const TsaiIcon(LucideIcons.badge_check),
                      child: switch (_step) {
                        0 => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TsaiPhoneInput(
                              initialValue: '099 123 45 67',
                              initialCountryCode: '598',
                              description:
                                  'We will send a one-time verification code.',
                            ),
                            SizedBox(height: tokens.spacing.space16),
                            Row(
                              children: [
                                const Expanded(
                                  child: TsaiTextBody(
                                    'Years at current address',
                                    size: TsaiBodySize.medium,
                                    weight: TsaiTextWeight.medium,
                                  ),
                                ),
                                TsaiStepper(
                                  value: _yearsAtAddress,
                                  min: 0,
                                  max: 20,
                                  onChanged: (value) =>
                                      setState(() => _yearsAtAddress = value),
                                ),
                              ],
                            ),
                            SizedBox(height: tokens.spacing.space16),
                            const TsaiOtpInput(
                              initialValue: '4821',
                              isSuccess: true,
                              semanticLabel: 'Verification code',
                            ),
                            SizedBox(height: tokens.spacing.space16),
                            const TsaiPinInput(
                              initialValue: '1234',
                              semanticLabel: 'App PIN',
                            ),
                          ],
                        ),
                        1 => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TsaiSelect<String>(
                              options: const [
                                TsaiSelectOption(
                                  value: 'passport',
                                  label: 'Passport',
                                ),
                                TsaiSelectOption(
                                  value: 'id',
                                  label: 'National ID',
                                ),
                              ],
                              value: _documentType,
                              placeholder: 'Document type',
                              onChanged: (value) =>
                                  setState(() => _documentType = value!),
                            ),
                            SizedBox(height: tokens.spacing.space16),
                            TsaiButton(
                              label: _documentUploaded
                                  ? 'Document uploaded'
                                  : 'Upload document',
                              variant: _documentUploaded
                                  ? TsaiButtonVariant.secondary
                                  : TsaiButtonVariant.outline,
                              leadingIcon: TsaiIcon(
                                _documentUploaded
                                    ? LucideIcons.check
                                    : LucideIcons.upload,
                              ),
                              onPressed: _documentUploaded
                                  ? null
                                  : _uploadDocument,
                            ),
                          ],
                        ),
                        _ => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TsaiTextBody(
                              '$_documentType on file · $_yearsAtAddress years at current address.',
                              size: TsaiBodySize.medium,
                              weight: TsaiTextWeight.regular,
                            ),
                            SizedBox(height: tokens.spacing.space16),
                            TsaiCheckbox(
                              value: _consentGiven,
                              label: 'I consent to identity verification',
                              onChanged: (value) => setState(
                                () => _consentGiven = value ?? false,
                              ),
                            ),
                          ],
                        ),
                      },
                    ),
                    SizedBox(height: tokens.spacing.space20),
                    TsaiButton(
                      label: _step == 2 ? 'Submit verification' : 'Continue',
                      isExpanded: true,
                      onPressed:
                          _step == 1 && !_documentUploaded ||
                              _step == 2 && !_consentGiven
                          ? null
                          : _advanceKyc,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KycLoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      key: const ValueKey<String>('kyc-loading-state'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const TsaiSpinner(
              size: TsaiSpinnerSize.medium,
              semanticLabel: 'Loading verification status',
            ),
            SizedBox(width: tokens.spacing.space12),
            const Expanded(
              child: TsaiTextBody(
                'Checking verification status',
                size: TsaiBodySize.medium,
                weight: TsaiTextWeight.medium,
              ),
            ),
          ],
        ),
        SizedBox(height: tokens.spacing.space24),
        const TsaiSkeletonCard(semanticLabel: 'Loading verification details'),
        SizedBox(height: tokens.spacing.space16),
        Row(
          children: [
            const TsaiSkeletonAvatar(size: TsaiSkeletonSize.small),
            SizedBox(width: tokens.spacing.space12),
            const Expanded(
              child: TsaiSkeletonText(size: TsaiSkeletonSize.small),
            ),
          ],
        ),
        SizedBox(height: tokens.spacing.space8),
        const TsaiSkeletonText(size: TsaiSkeletonSize.small),
        SizedBox(height: tokens.spacing.space8),
        const FractionallySizedBox(
          widthFactor: 0.7,
          alignment: AlignmentDirectional.centerStart,
          child: TsaiSkeletonText(size: TsaiSkeletonSize.small),
        ),
      ],
    );
  }
}

class PurchaseScreenExample extends StatefulWidget {
  const PurchaseScreenExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;

  @override
  State<PurchaseScreenExample> createState() => _PurchaseScreenExampleState();
}

class _PurchaseScreenExampleState extends State<PurchaseScreenExample> {
  var _authorized = false;
  var _quantity = 2;
  var _tip = 0.12;
  var _amount = '9.00';

  double get _base => (double.tryParse(_amount) ?? 0) * _quantity;
  double get _total => _base * (1 + _tip);

  Future<void> _authorizePayment() async {
    await showTsaiBottomSheet<void>(
      context: context,
      title: 'Confirm with PIN',
      size: TsaiBottomSheetSize.full,
      child: _PinSheet(
        total: _total,
        onAuthorized: () => setState(() => _authorized = true),
      ),
    );
    if (!mounted || !_authorized) {
      return;
    }
    final formatted = '\$${_total.toStringAsFixed(2)}';
    await showTsaiToast(
      context: context,
      variant: TsaiToastVariant.action,
      message: 'Receipt saved',
      actionLabel: 'View',
      bottomClearance: _toastBottomClearance(context),
      onAction: () {
        unawaited(
          showTsaiModalDialog<void>(
            context: context,
            title: 'Receipt',
            message: 'Coffee House Montevideo · $formatted',
            icon: const TsaiIcon(LucideIcons.receipt_text),
            primaryAction: Builder(
              builder: (dialogContext) => TsaiButton(
                label: 'Close',
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final formatted = '\$${_total.toStringAsFixed(2)}';
    return PageWithTopBar(
      key: const ValueKey<String>('purchase-screen-page'),
      heading: 'Send money',
      subtitle: 'Pay a person or a saved merchant',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          tokens.spacing.space16,
          tokens.spacing.space24,
          tokens.spacing.space16,
          tokens.spacing.space64 + 62,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TsaiAmountDisplay(
                  caption: _authorized ? 'Paid' : 'Amount due',
                  value: formatted,
                  subtitle: _authorized
                      ? 'Receipt saved to activity'
                      : 'Coffee House · $_quantity items',
                  alignment: TsaiAmountAlignment.center,
                ),
                SizedBox(height: tokens.spacing.space20),
                const TsaiSearchInput(
                  placeholder: 'Search people or merchants',
                ),
                SizedBox(height: tokens.spacing.space16),
                Row(
                  children: [
                    const Expanded(
                      child: TsaiTextBody(
                        'Items',
                        size: TsaiBodySize.medium,
                        weight: TsaiTextWeight.medium,
                      ),
                    ),
                    TsaiStepper(
                      value: _quantity,
                      min: 1,
                      max: 12,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.space16),
                TsaiTextCaption(
                  'Tip ${(_tip * 100).round()}%',
                  size: TsaiCaptionSize.medium,
                  weight: TsaiTextWeight.medium,
                  color: tokens.colors.contentSecondary,
                ),
                SizedBox(height: tokens.spacing.space8),
                TsaiSlider(
                  value: _tip,
                  min: 0,
                  max: 0.25,
                  semanticLabel: 'Tip percent',
                  onChanged: _authorized
                      ? null
                      : (value) => setState(() => _tip = value),
                ),
                SizedBox(height: tokens.spacing.space20),
                FittedBox(
                  child: TsaiNumericKeypad(
                    onDigit: _authorized
                        ? null
                        : (digit) {
                            setState(() {
                              final next = _amount == '0'
                                  ? digit
                                  : '$_amount$digit';
                              if (next.replaceAll('.', '').length > 6) {
                                return;
                              }
                              _amount = next;
                            });
                          },
                    onDecimal: _authorized
                        ? null
                        : () {
                            if (_amount.contains('.')) {
                              return;
                            }
                            setState(() => _amount = '$_amount.');
                          },
                    onBackspace: _authorized
                        ? null
                        : () {
                            setState(() {
                              if (_amount.length <= 1) {
                                _amount = '0';
                                return;
                              }
                              _amount = _amount.substring(
                                0,
                                _amount.length - 1,
                              );
                            });
                          },
                  ),
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInlineAlert(
                  tone: TsaiInlineAlertTone.info,
                  title: 'Secure checkout',
                  message: 'Payments stay on this device until you confirm.',
                ),
                SizedBox(height: tokens.spacing.space16),
                TsaiButton(
                  label: _authorized ? 'Payment sent' : 'Authorize payment',
                  isExpanded: true,
                  onPressed: _authorized ? null : _authorizePayment,
                ),
                SizedBox(height: tokens.spacing.space12),
                TsaiLink(
                  label: 'View transaction details',
                  onPressed: () => showTsaiModalDialog<void>(
                    context: context,
                    title: 'Transaction details',
                    icon: const TsaiIcon(LucideIcons.receipt_text),
                    message:
                        'Merchant: Coffee House Montevideo\nAmount: $formatted\nStatus: ${_authorized ? 'Sent' : 'Pending'}',
                    primaryAction: Builder(
                      builder: (dialogContext) => TsaiButton(
                        label: 'Close',
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: tokens.spacing.space12),
                const TsaiTextButton(
                  'Protected by Tsai Pay security',
                  size: TsaiButtonTextSize.medium,
                ),
                const TsaiTextMonoCaption(
                  'TXN-2026-08421',
                  weight: TsaiTextWeight.regular,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinSheet extends StatefulWidget {
  const _PinSheet({required this.total, required this.onAuthorized});

  final double total;
  final VoidCallback onAuthorized;

  @override
  State<_PinSheet> createState() => _PinSheetState();
}

class _PinSheetState extends State<_PinSheet> {
  var _pin = '';

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TsaiAmountDisplay(
          caption: 'Authorize',
          value: '\$${widget.total.toStringAsFixed(2)}',
          subtitle: _pin.isEmpty ? 'Enter your 4-digit PIN' : '•' * _pin.length,
          alignment: TsaiAmountAlignment.center,
        ),
        SizedBox(height: tokens.spacing.space24),
        FittedBox(
          child: TsaiNumericKeypad(
            mode: TsaiKeypadMode.pin,
            onDigit: (digit) {
              if (_pin.length >= 4) {
                return;
              }
              setState(() => _pin += digit);
              if (_pin.length == 4) {
                widget.onAuthorized();
                Navigator.of(context).pop();
              }
            },
            onBackspace: () {
              if (_pin.isEmpty) {
                return;
              }
              setState(() => _pin = _pin.substring(0, _pin.length - 1));
            },
            onBiometric: () {
              widget.onAuthorized();
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

class _InvestmentTabContent extends StatelessWidget {
  const _InvestmentTabContent();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: TsaiEmptyState(
      icon: TsaiIcon(LucideIcons.chart_no_axes_combined),
      title: 'No investments yet',
      description: 'Your portfolio will appear here after your first purchase.',
    ),
  );
}

class _ActivityList extends StatelessWidget {
  const _ActivityList();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TsaiList(
        title: 'Recent activity',
        headerTrailingIcon: HitIcon(
          icon: const TsaiIcon(LucideIcons.search),
          semanticLabel: 'Search activity',
          onPressed: () => showTsaiModalDialog<void>(
            context: context,
            title: 'Search activity',
            message: 'Find transfers, card taps, and incoming payments.',
            icon: const TsaiIcon(LucideIcons.search),
            primaryAction: Builder(
              builder: (dialogContext) => TsaiButton(
                label: 'Close',
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ),
        ),
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
          onPressed: () => showTsaiModalDialog<void>(
            context: context,
            title: 'Activity history',
            message: 'The full ledger stays in this account.',
            icon: const TsaiIcon(LucideIcons.receipt_text),
            primaryAction: Builder(
              builder: (dialogContext) => TsaiButton(
                label: 'Close',
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ),
        ),
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

const _currencyOptions = [
  TsaiSelectOption(
    value: 'usd',
    label: 'US Dollar',
    icon: TsaiIcon.emoji('🇺🇸', size: 20),
  ),
  TsaiSelectOption(
    value: 'uyu',
    label: 'Uruguayan peso',
    icon: TsaiIcon.emoji('🇺🇾', size: 20),
  ),
  TsaiSelectOption(
    value: 'eur',
    label: 'Euro',
    icon: TsaiIcon.emoji('🇪🇺', size: 20),
  ),
];

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

double _toastBottomClearance(BuildContext context) {
  if (MediaQuery.viewInsetsOf(context).bottom > 0) {
    return 0;
  }
  return BottomNavBar.barHeightOf(context);
}
