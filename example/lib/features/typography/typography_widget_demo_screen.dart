import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

enum TypographyWidgetRole {
  heading(label: 'TsaiHeading', route: '/typography/heading'),
  body(label: 'TsaiBody', route: '/typography/body'),
  buttonText(label: 'TsaiButtonText', route: '/typography/button-text'),
  caption(label: 'TsaiCaption', route: '/typography/caption'),
  monoHeading(label: 'TsaiMonoHeading', route: '/typography/mono-heading'),
  monoBody(label: 'TsaiMonoBody', route: '/typography/mono-body'),
  monoCaption(label: 'TsaiMonoCaption', route: '/typography/mono-caption');

  const TypographyWidgetRole({required this.label, required this.route});

  final String label;
  final String route;
}

class TypographyWidgetDemoScreen extends StatelessWidget {
  const TypographyWidgetDemoScreen({
    required this.role,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final TypographyWidgetRole role;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.typography,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: _TypographyWidgetDemo(role: role),
  );
}

class _TypographyWidgetDemo extends StatelessWidget {
  const _TypographyWidgetDemo({required this.role});

  final TypographyWidgetRole role;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: ValueKey<String>('${role.name}-widget-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        TsaiHeading(role.label, size: TsaiHeadingSize.large),
        SizedBox(height: tokens.spacing.space8),
        TsaiBody(
          _description,
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.regular,
          color: tokens.colors.contentSecondary,
        ),
        SizedBox(height: tokens.spacing.space32),
        PenpotExample(
          title: 'Variants',
          child: PenpotBoard(
            child: Wrap(
              spacing: tokens.spacing.space24,
              runSpacing: tokens.spacing.space24,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: _samples,
            ),
          ),
        ),
      ],
    );
  }

  String get _description => switch (role) {
    TypographyWidgetRole.heading => 'Inter headings in four semantic sizes.',
    TypographyWidgetRole.body =>
      'Inter body copy in two sizes and two semantic weights.',
    TypographyWidgetRole.buttonText =>
      'Inter labels for custom button compositions.',
    TypographyWidgetRole.caption =>
      'Compact Inter supporting text in two sizes and weights.',
    TypographyWidgetRole.monoHeading =>
      'JetBrains Mono headings for prominent numeric values.',
    TypographyWidgetRole.monoBody =>
      'JetBrains Mono body text for technical values.',
    TypographyWidgetRole.monoCaption =>
      'JetBrains Mono captions for compact technical metadata.',
  };

  List<Widget> get _samples => switch (role) {
    TypographyWidgetRole.heading => const [
      TsaiHeading('Extra large heading', size: TsaiHeadingSize.extraLarge),
      TsaiHeading('Large heading', size: TsaiHeadingSize.large),
      TsaiHeading('Medium heading', size: TsaiHeadingSize.medium),
      TsaiHeading('Small heading', size: TsaiHeadingSize.small),
    ],
    TypographyWidgetRole.body => const [
      TsaiBody(
        'Large regular body',
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.regular,
      ),
      TsaiBody(
        'Large medium body',
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.medium,
      ),
      TsaiBody(
        'Medium regular body',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
      ),
      TsaiBody(
        'Medium medium body',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.medium,
      ),
    ],
    TypographyWidgetRole.buttonText => const [
      TsaiButtonText('Large button label', size: TsaiButtonTextSize.large),
      TsaiButtonText('Medium button label', size: TsaiButtonTextSize.medium),
    ],
    TypographyWidgetRole.caption => const [
      TsaiCaption(
        'Medium regular caption',
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.regular,
      ),
      TsaiCaption(
        'Medium caption',
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.medium,
      ),
      TsaiCaption(
        'Small regular caption',
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.regular,
      ),
      TsaiCaption(
        'Small caption',
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.medium,
      ),
    ],
    TypographyWidgetRole.monoHeading => const [
      TsaiMonoHeading('24,891.42', size: TsaiMonoHeadingSize.extraLarge),
      TsaiMonoHeading('24,891.42', size: TsaiMonoHeadingSize.large),
    ],
    TypographyWidgetRole.monoBody => const [
      TsaiMonoBody('ETH / USD  +4.81%', size: TsaiBodySize.large),
      TsaiMonoBody('ETH / USD  +4.81%', size: TsaiBodySize.medium),
    ],
    TypographyWidgetRole.monoCaption => const [
      TsaiMonoCaption('09:41:27 UTC', weight: TsaiTextWeight.medium),
      TsaiMonoCaption('09:41:27 UTC', weight: TsaiTextWeight.regular),
    ],
  };
}
