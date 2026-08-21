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

class _MultiScreenAppExampleState extends State<MultiScreenAppExample> {
  static const _navigationItems = [
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.house, size: 20),
      label: 'Home',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.file_text, size: 20),
      label: 'Form',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.badge_check, size: 20),
      label: 'KYC',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.shopping_bag, size: 20),
      label: 'Pay',
    ),
  ];

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Stack(
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
          ),
          FormScreenExample(
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
            onOpenCatalog: widget.onOpenCatalog,
            onShowHome: () => setState(() => _selectedIndex = 0),
          ),
          KycScreenExample(
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

  void _openCards(BuildContext context) => showTsaiBottomSheet<void>(
    context: context,
    title: 'Your cards',
    child: const TsaiEmptyState(
      icon: TsaiIcon(LucideIcons.wallet_cards),
      title: 'No virtual cards yet',
      description: 'Create a card to start paying online.',
    ),
    primaryAction: Builder(
      builder: (sheetContext) => TsaiButton(
        label: 'Create virtual card',
        onPressed: () => Navigator.of(sheetContext).pop(),
      ),
    ),
  );

  void _openNotifications(BuildContext context) => showTsaiModalDialog<void>(
    context: context,
    title: 'Notifications',
    message: 'Your identity review is ready to continue.',
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
                      TsaiTabs(
                        sections: [
                          TsaiTabSection.text(
                            label: 'Overview',
                            content: const _OverviewTabContent(),
                          ),
                          TsaiTabSection.text(
                            label: 'Investments',
                            content: _InvestmentTabContent(),
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      const TsaiTextHeading(
                        'Quick actions',
                        size: TsaiHeadingSize.small,
                      ),
                      SizedBox(height: tokens.spacing.space12),
                      Wrap(
                        spacing: tokens.spacing.space8,
                        runSpacing: tokens.spacing.space8,
                        children: [
                          TsaiButton(
                            key: const ValueKey<String>('quick-transfer'),
                            label: 'Transfer',
                            size: TsaiButtonSize.medium,
                            leadingIcon: const TsaiIcon(
                              LucideIcons.send,
                              size: 16,
                            ),
                            onPressed: () => _openTransfer(context),
                          ),
                          TsaiButton(
                            key: const ValueKey<String>('quick-pay'),
                            label: 'Pay',
                            size: TsaiButtonSize.medium,
                            variant: TsaiButtonVariant.secondary,
                            leadingIcon: const TsaiIcon(
                              LucideIcons.receipt,
                              size: 16,
                            ),
                            onPressed: () => _openPayment(context),
                          ),
                          TsaiButton(
                            label: 'Cards',
                            size: TsaiButtonSize.medium,
                            variant: TsaiButtonVariant.outline,
                            leadingIcon: const TsaiIcon(
                              LucideIcons.wallet_cards,
                              size: 16,
                            ),
                            onPressed: () => _openCards(context),
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.spacing.space24),
                      const Wrap(
                        spacing: 8,
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
      size: TsaiBottomSheetSize.half,
      child: const TsaiTextBody(
        'Choose a recipient and amount to move money between accounts.',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
      ),
      secondaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Cancel',
          variant: TsaiButtonVariant.secondary,
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ),
      primaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Continue',
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    );
  }

  Future<void> _openPayment(BuildContext context) async {
    await showTsaiModalDialog<void>(
      context: context,
      title: 'Schedule a payment',
      message: 'Review your payment details before confirming the transaction.',
      icon: const TsaiIcon(LucideIcons.receipt),
      secondaryAction: Builder(
        builder: (dialogContext) => TsaiButton(
          label: 'Cancel',
          variant: TsaiButtonVariant.secondary,
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
      ),
      primaryAction: Builder(
        builder: (dialogContext) => TsaiButton(
          label: 'Confirm',
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
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
  String _accountType = 'personal';
  bool _twoFactorEnabled = true;

  void _saveProfile() => showTsaiModalDialog<void>(
    context: context,
    title: 'Profile saved',
    message: 'Your account details and security preferences are up to date.',
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
                  'Account access',
                  size: TsaiHeadingSize.small,
                ),
                SizedBox(height: tokens.spacing.space16),
                TsaiRadio<String>(
                  value: 'personal',
                  groupValue: _accountType,
                  label: 'Personal account',
                  description: 'For everyday spending and transfers.',
                  onChanged: (value) => setState(() => _accountType = value!),
                ),
                SizedBox(height: tokens.spacing.space8),
                TsaiRadio<String>(
                  value: 'business',
                  groupValue: _accountType,
                  label: 'Business account',
                  description: 'For invoices and team payments.',
                  onChanged: (value) => setState(() => _accountType = value!),
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
                  semanticLabel: 'Transaction PIN',
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
                SizedBox(height: tokens.spacing.space16),
                TsaiSwitch(
                  value: _twoFactorEnabled,
                  label: 'Require two-step approval',
                  description: 'Protect outgoing payments with an extra check.',
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

class KycScreenExample extends StatefulWidget {
  const KycScreenExample({
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenCatalog,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onOpenCatalog;

  @override
  State<KycScreenExample> createState() => _KycScreenExampleState();
}

class _KycScreenExampleState extends State<KycScreenExample> {
  int _step = 0;
  bool _documentUploaded = false;
  bool _consentGiven = false;
  String _documentType = 'passport';

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
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return PageWithTopBar(
      key: const ValueKey<String>('kyc-screen-page'),
      heading: 'Verify your identity',
      subtitle: 'Complete your account verification',
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
            padding: EdgeInsets.fromLTRB(
              tokens.spacing.space16,
              tokens.spacing.space24,
              tokens.spacing.space16,
              tokens.spacing.space64 + 62,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TsaiInlineAlert(
                  tone: _step == 2
                      ? TsaiInlineAlertTone.success
                      : TsaiInlineAlertTone.info,
                  title: 'Step ${_step + 1} of 3',
                  message: switch (_step) {
                    0 => 'Tell us where to send your verification code.',
                    1 => 'Upload one government-issued document.',
                    _ => 'Review your details and give consent to continue.',
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
                    0 => const TsaiPhoneInput(
                      initialValue: '099 123 45 67',
                      initialCountryCode: '598',
                      description: 'We will send a one-time verification code.',
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
                            TsaiSelectOption(value: 'id', label: 'National ID'),
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
                          onPressed: () =>
                              setState(() => _documentUploaded = true),
                        ),
                        SizedBox(height: tokens.spacing.space16),
                        if (!_documentUploaded)
                          const TsaiSkeletonCard(
                            size: TsaiSkeletonSize.small,
                            semanticLabel: 'Waiting for document upload',
                          ),
                      ],
                    ),
                    _ => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TsaiTextBody(
                          'We use your document only to verify your identity.',
                          size: TsaiBodySize.medium,
                          weight: TsaiTextWeight.regular,
                        ),
                        SizedBox(height: tokens.spacing.space16),
                        TsaiCheckbox(
                          value: _consentGiven,
                          label: 'I consent to identity verification',
                          onChanged: (value) =>
                              setState(() => _consentGiven = value ?? false),
                        ),
                      ],
                    ),
                  },
                ),
                SizedBox(height: tokens.spacing.space16),
                TsaiProgressBar(
                  value: (_step + 1) / 3,
                  label: 'Workspace setup',
                  labelPosition: TsaiProgressBarLabelPosition.top,
                ),
                SizedBox(height: tokens.spacing.space20),
                Row(
                  children: [
                    const TsaiSkeletonAvatar(size: TsaiSkeletonSize.small),
                    SizedBox(width: tokens.spacing.space12),
                    const Expanded(
                      child: TsaiSkeletonText(size: TsaiSkeletonSize.small),
                    ),
                    SizedBox(width: tokens.spacing.space12),
                    const TsaiSpinner(size: TsaiSpinnerSize.small),
                  ],
                ),
                SizedBox(height: tokens.spacing.space20),
                TsaiToast(
                  variant: TsaiToastVariant.info,
                  message: _documentUploaded
                      ? 'Document ready to review'
                      : 'Secure verification session',
                  actionLabel: _documentUploaded ? 'Review' : null,
                  onAction: _documentUploaded
                      ? () => setState(() => _step = 2)
                      : null,
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
            ),
          ),
        ),
      ),
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
  bool _authorized = false;

  Future<void> _authorizePayment() async {
    await showTsaiBottomSheet<void>(
      context: context,
      title: 'Confirm purchase',
      size: TsaiBottomSheetSize.half,
      child: const TsaiTextBody(
        'Authorize a payment of \$12.40 to Coffee House Montevideo?',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
      ),
      secondaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Cancel',
          variant: TsaiButtonVariant.secondary,
          onPressed: () => Navigator.of(sheetContext).pop(),
        ),
      ),
      primaryAction: Builder(
        builder: (sheetContext) => TsaiButton(
          label: 'Authorize',
          onPressed: () {
            setState(() => _authorized = true);
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return PageWithTopBar(
      key: const ValueKey<String>('purchase-screen-page'),
      heading: 'Pay a merchant',
      subtitle: 'Review and authorize a purchase',
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
                TsaiCard(
                  title: _authorized
                      ? 'Payment complete'
                      : 'Coffee House Montevideo',
                  trailing: TsaiIcon(LucideIcons.store),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TsaiTextBody(
                        _authorized
                            ? 'Receipt saved to activity'
                            : 'Flat white and pastry',
                        size: TsaiBodySize.medium,
                        weight: TsaiTextWeight.regular,
                      ),
                      TsaiTextMonoHeading(
                        '\$12.40',
                        size: TsaiMonoHeadingSize.large,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tokens.spacing.space16),
                const TsaiSearchInput(placeholder: 'Search saved merchants'),
                SizedBox(height: tokens.spacing.space16),
                const TsaiInlineAlert(
                  tone: TsaiInlineAlertTone.info,
                  title: 'Secure checkout',
                  message: 'Your payment is protected by device verification.',
                ),
                SizedBox(height: tokens.spacing.space16),
                TsaiSectionHeader(
                  title: 'Payment method',
                  trailingIcon: const TsaiIcon(LucideIcons.chevron_down),
                  trailingIconSemanticLabel: 'Change payment method',
                  onTrailingIconPressed: () => showTsaiBottomSheet<void>(
                    context: context,
                    title: 'Payment method',
                    child: const TsaiTextBody(
                      'Debit card ending in 4821',
                      size: TsaiBodySize.medium,
                      weight: TsaiTextWeight.regular,
                    ),
                    primaryAction: Builder(
                      builder: (sheetContext) => TsaiButton(
                        label: 'Use this card',
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: tokens.spacing.space12),
                TsaiButton(
                  label: _authorized
                      ? 'Payment authorized'
                      : 'Authorize payment',
                  isExpanded: true,
                  onPressed: _authorized ? null : _authorizePayment,
                ),
                SizedBox(height: tokens.spacing.space12),
                TsaiToast(
                  variant: _authorized
                      ? TsaiToastVariant.action
                      : TsaiToastVariant.info,
                  message: _authorized
                      ? 'Receipt saved'
                      : 'Ready for secure checkout',
                  actionLabel: _authorized ? 'View' : null,
                  onAction: _authorized
                      ? () => showTsaiModalDialog<void>(
                          context: context,
                          title: 'Receipt',
                          message:
                              'Your receipt is available in activity history.',
                          icon: const TsaiIcon(LucideIcons.receipt_text),
                          primaryAction: Builder(
                            builder: (dialogContext) => TsaiButton(
                              label: 'Close',
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(height: tokens.spacing.space12),
                TsaiLink(
                  label: 'View transaction details',
                  onPressed: () => showTsaiModalDialog<void>(
                    context: context,
                    title: 'Transaction details',
                    icon: const TsaiIcon(LucideIcons.receipt_text),
                    message:
                        'Merchant: Coffee House Montevideo\nAmount: \$12.40\nStatus: ${_authorized ? 'Authorized' : 'Pending'}',
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

class _OverviewTabContent extends StatelessWidget {
  const _OverviewTabContent();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        const CircleIcon(
          icon: TsaiIcon(LucideIcons.coins),
          semanticLabel: 'Account balance',
        ),
        const SizedBox(width: 8),
        const Avatar(initials: 'IT', semanticLabel: 'Ilona Taylor'),
        const SizedBox(width: 8),
        const TsaiCryptoIcon(TsaiCryptoAsset.usdc, size: 24),
        const SizedBox(width: 12),
        const Expanded(
          child: TsaiTextBody(
            'Multi-currency account',
            size: TsaiBodySize.medium,
            weight: TsaiTextWeight.medium,
          ),
        ),
        TsaiTextMonoBody(
          'USDC 1,240.00',
          size: TsaiBodySize.medium,
          color: TsaiThemeTokens.of(context).colors.contentSecondary,
        ),
      ],
    ),
  );
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
              onPressed: () => showTsaiBottomSheet<void>(
                context: context,
                title: 'Add funds',
                child: const TsaiTextBody(
                  'Connect a bank account or card to add funds securely.',
                  size: TsaiBodySize.medium,
                  weight: TsaiTextWeight.regular,
                ),
                primaryAction: Builder(
                  builder: (sheetContext) => TsaiButton(
                    label: 'Start setup',
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
              ),
            ),
            TsaiButton(
              label: 'Transfer',
              size: TsaiButtonSize.medium,
              variant: TsaiButtonVariant.secondary,
              leadingIcon: const TsaiIcon(LucideIcons.send, size: 16),
              onPressed: () => showTsaiModalDialog<void>(
                context: context,
                title: 'Transfer money',
                message: 'Choose a recipient from your saved beneficiaries.',
                icon: const TsaiIcon(LucideIcons.send),
                primaryAction: Builder(
                  builder: (dialogContext) => TsaiButton(
                    label: 'Close',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ActivityList extends StatelessWidget {
  const _ActivityList();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return TsaiList(
      title: 'Recent activity',
      headerTrailingIcon: HitIcon(
        icon: const TsaiIcon(LucideIcons.search),
        semanticLabel: 'Search activity',
        onPressed: () => showTsaiModalDialog<void>(
          context: context,
          title: 'Search activity',
          message: 'Use the activity catalog to find transfers and payments.',
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
          message:
              'All transfers and payments are shown in your full activity history.',
          icon: const TsaiIcon(LucideIcons.receipt_text),
          primaryAction: Builder(
            builder: (dialogContext) => TsaiButton(
              label: 'Close',
              onPressed: () => Navigator.of(dialogContext).pop(),
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
