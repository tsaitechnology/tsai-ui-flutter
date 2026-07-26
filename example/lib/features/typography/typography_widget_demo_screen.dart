import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

enum TypographyWidgetRole {
  title(label: 'TsaiTitle', route: '/typography/title'),
  heading(label: 'TsaiTextHeading', route: '/typography/heading'),
  body(label: 'TsaiTextBody', route: '/typography/body'),
  buttonText(label: 'TsaiTextButton', route: '/typography/button-text'),
  caption(label: 'TsaiTextCaption', route: '/typography/caption'),
  monoHeading(label: 'TsaiTextMonoHeading', route: '/typography/mono-heading'),
  monoBody(label: 'TsaiTextMonoBody', route: '/typography/mono-body'),
  monoCaption(label: 'TsaiTextMonoCaption', route: '/typography/mono-caption');

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
    section: switch (role) {
      TypographyWidgetRole.title => ComponentDemoSection.title,
      TypographyWidgetRole.heading => ComponentDemoSection.textHeading,
      TypographyWidgetRole.body => ComponentDemoSection.textBody,
      TypographyWidgetRole.buttonText => ComponentDemoSection.textButton,
      TypographyWidgetRole.caption => ComponentDemoSection.textCaption,
      TypographyWidgetRole.monoHeading => ComponentDemoSection.textMonoHeading,
      TypographyWidgetRole.monoBody => ComponentDemoSection.textMonoBody,
      TypographyWidgetRole.monoCaption => ComponentDemoSection.textMonoCaption,
    },
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
        _TypographyPlayground(role: role),
      ],
    );
  }

  List<Widget> get _samples => switch (role) {
    TypographyWidgetRole.title => const [
      TsaiTitle('Title'),
      TsaiTitle('Title', subtitle: 'Supporting description'),
    ],
    TypographyWidgetRole.heading => const [
      TsaiTextHeading('Extra large heading', size: TsaiHeadingSize.extraLarge),
      TsaiTextHeading('Large heading', size: TsaiHeadingSize.large),
      TsaiTextHeading('Medium heading', size: TsaiHeadingSize.medium),
      TsaiTextHeading('Small heading', size: TsaiHeadingSize.small),
    ],
    TypographyWidgetRole.body => const [
      TsaiTextBody(
        'Large regular body',
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.regular,
      ),
      TsaiTextBody(
        'Large medium body',
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.medium,
      ),
      TsaiTextBody(
        'Medium regular body',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
      ),
      TsaiTextBody(
        'Medium medium body',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.medium,
      ),
    ],
    TypographyWidgetRole.buttonText => const [
      TsaiTextButton('Large button label', size: TsaiButtonTextSize.large),
      TsaiTextButton('Medium button label', size: TsaiButtonTextSize.medium),
    ],
    TypographyWidgetRole.caption => const [
      TsaiTextCaption(
        'Medium regular caption',
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.regular,
      ),
      TsaiTextCaption(
        'Medium caption',
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.medium,
      ),
      TsaiTextCaption(
        'Small regular caption',
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.regular,
      ),
      TsaiTextCaption(
        'Small caption',
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.medium,
      ),
    ],
    TypographyWidgetRole.monoHeading => const [
      TsaiTextMonoHeading('24,891.42', size: TsaiMonoHeadingSize.extraLarge),
      TsaiTextMonoHeading('24,891.42', size: TsaiMonoHeadingSize.large),
    ],
    TypographyWidgetRole.monoBody => const [
      TsaiTextMonoBody('ETH / USD  +4.81%', size: TsaiBodySize.large),
      TsaiTextMonoBody('ETH / USD  +4.81%', size: TsaiBodySize.medium),
    ],
    TypographyWidgetRole.monoCaption => const [
      TsaiTextMonoCaption('09:41:27 UTC', weight: TsaiTextWeight.medium),
      TsaiTextMonoCaption('09:41:27 UTC', weight: TsaiTextWeight.regular),
    ],
  };
}

class _TypographyPlayground extends StatefulWidget {
  const _TypographyPlayground({required this.role});

  final TypographyWidgetRole role;

  @override
  State<_TypographyPlayground> createState() => _TypographyPlaygroundState();
}

class _TypographyPlaygroundState extends State<_TypographyPlayground> {
  String _text = 'Make every decision visible';
  TextAlign _textAlign = TextAlign.start;
  bool _accent = false;
  bool _showSubtitle = true;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'text',
          value: _text,
          onChanged: (value) => setState(() => _text = value),
        ),
        if (widget.role == TypographyWidgetRole.title)
          PlaygroundToggleControl(
            label: 'subtitle',
            value: _showSubtitle,
            onChanged: (value) => setState(() => _showSubtitle = value),
          )
        else ...[
          PlaygroundSelectControl<TextAlign>(
            label: 'textAlign',
            value: _textAlign,
            values: const [TextAlign.start, TextAlign.center, TextAlign.end],
            onChanged: (value) => setState(() => _textAlign = value),
          ),
          PlaygroundToggleControl(
            label: 'accent color',
            value: _accent,
            onChanged: (value) => setState(() => _accent = value),
          ),
        ],
      ],
      preview: _preview(color: _accent ? tokens.colors.actionPrimary : null),
    );
  }

  Widget _preview({required Color? color}) => switch (widget.role) {
    TypographyWidgetRole.title => TsaiTitle(
      _text,
      subtitle: _showSubtitle ? 'Supporting description' : null,
    ),
    TypographyWidgetRole.heading => TsaiTextHeading(
      _text,
      size: TsaiHeadingSize.large,
      textAlign: _textAlign,
      color: color,
    ),
    TypographyWidgetRole.body => TsaiTextBody(
      _text,
      size: TsaiBodySize.medium,
      weight: TsaiTextWeight.regular,
      textAlign: _textAlign,
      color: color,
    ),
    TypographyWidgetRole.buttonText => TsaiTextButton(
      _text,
      size: TsaiButtonTextSize.medium,
      textAlign: _textAlign,
      color: color,
    ),
    TypographyWidgetRole.caption => TsaiTextCaption(
      _text,
      size: TsaiCaptionSize.medium,
      weight: TsaiTextWeight.regular,
      textAlign: _textAlign,
      color: color,
    ),
    TypographyWidgetRole.monoHeading => TsaiTextMonoHeading(
      _text,
      size: TsaiMonoHeadingSize.large,
      textAlign: _textAlign,
      color: color,
    ),
    TypographyWidgetRole.monoBody => TsaiTextMonoBody(
      _text,
      size: TsaiBodySize.medium,
      textAlign: _textAlign,
      color: color,
    ),
    TypographyWidgetRole.monoCaption => TsaiTextMonoCaption(
      _text,
      weight: TsaiTextWeight.regular,
      textAlign: _textAlign,
      color: color,
    ),
  };
}
