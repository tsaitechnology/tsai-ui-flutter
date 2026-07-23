import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class TypographyDemo extends StatelessWidget {
  const TypographyDemo({super.key, this.controller, this.physics});

  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    key: const ValueKey<String>('typography-demo'),
    controller: controller,
    physics: physics,
    slivers: [
      const SliverToBoxAdapter(
        child: _TypographySection(
          title: 'Inter / Heading',
          samples: [
            _TypographySample(
              name: 'headingExtraLarge',
              sample: TsaiHeading(
                'Make every decision visible',
                size: TsaiHeadingSize.extraLarge,
              ),
            ),
            _TypographySample(
              name: 'headingLarge',
              sample: TsaiHeading(
                'Make every decision visible',
                size: TsaiHeadingSize.large,
              ),
            ),
            _TypographySample(
              name: 'headingMedium',
              sample: TsaiHeading(
                'Make every decision visible',
                size: TsaiHeadingSize.medium,
              ),
            ),
            _TypographySample(
              name: 'headingSmall',
              sample: TsaiHeading(
                'Make every decision visible',
                size: TsaiHeadingSize.small,
              ),
            ),
          ],
        ),
      ),
      const SliverToBoxAdapter(
        child: _TypographySection(
          title: 'Inter / Body',
          samples: [
            _TypographySample(
              name: 'bodyLargeMedium',
              sample: TsaiBody(
                'Clear interfaces turn complex work into focused action.',
                size: TsaiBodySize.large,
                weight: TsaiTextWeight.medium,
              ),
            ),
            _TypographySample(
              name: 'bodyLarge',
              sample: TsaiBody(
                'Clear interfaces turn complex work into focused action.',
                size: TsaiBodySize.large,
                weight: TsaiTextWeight.regular,
              ),
            ),
            _TypographySample(
              name: 'bodyMediumMedium',
              sample: TsaiBody(
                'Clear interfaces turn complex work into focused action.',
                size: TsaiBodySize.medium,
                weight: TsaiTextWeight.medium,
              ),
            ),
            _TypographySample(
              name: 'bodyMedium',
              sample: TsaiBody(
                'Clear interfaces turn complex work into focused action.',
                size: TsaiBodySize.medium,
                weight: TsaiTextWeight.regular,
              ),
            ),
          ],
        ),
      ),
      const SliverToBoxAdapter(
        child: _TypographySection(
          title: 'Inter / Button',
          samples: [
            _TypographySample(
              name: 'buttonLarge',
              sample: TsaiButtonText(
                'Continue',
                size: TsaiButtonTextSize.large,
              ),
            ),
            _TypographySample(
              name: 'buttonMedium',
              sample: TsaiButtonText(
                'Continue',
                size: TsaiButtonTextSize.medium,
              ),
            ),
          ],
        ),
      ),
      const SliverToBoxAdapter(
        child: _TypographySection(
          title: 'Inter / Caption',
          samples: [
            _TypographySample(
              name: 'captionMedium',
              sample: TsaiCaption(
                'Updated a moment ago',
                size: TsaiCaptionSize.medium,
                weight: TsaiTextWeight.medium,
              ),
            ),
            _TypographySample(
              name: 'captionMediumRegular',
              sample: TsaiCaption(
                'Updated a moment ago',
                size: TsaiCaptionSize.medium,
                weight: TsaiTextWeight.regular,
              ),
            ),
            _TypographySample(
              name: 'captionSmall',
              sample: TsaiCaption(
                'Updated a moment ago',
                size: TsaiCaptionSize.small,
                weight: TsaiTextWeight.medium,
              ),
            ),
            _TypographySample(
              name: 'captionSmallRegular',
              sample: TsaiCaption(
                'Updated a moment ago',
                size: TsaiCaptionSize.small,
                weight: TsaiTextWeight.regular,
              ),
            ),
          ],
        ),
      ),
      const SliverToBoxAdapter(
        child: _TypographySection(
          title: 'JetBrains Mono',
          samples: [
            _TypographySample(
              name: 'monoHeadingExtraLarge',
              sample: TsaiMonoHeading(
                '24,891.42',
                size: TsaiMonoHeadingSize.extraLarge,
              ),
            ),
            _TypographySample(
              name: 'monoHeadingLarge',
              sample: TsaiMonoHeading(
                '24,891.42',
                size: TsaiMonoHeadingSize.large,
              ),
            ),
            _TypographySample(
              name: 'monoBodyLarge',
              sample: TsaiMonoBody(
                'ETH / USD  +4.81%',
                size: TsaiBodySize.large,
              ),
            ),
            _TypographySample(
              name: 'monoBodyMedium',
              sample: TsaiMonoBody(
                'ETH / USD  +4.81%',
                size: TsaiBodySize.medium,
              ),
            ),
            _TypographySample(
              name: 'monoCaption',
              sample: TsaiMonoCaption(
                '09:41:27 UTC',
                weight: TsaiTextWeight.medium,
              ),
            ),
            _TypographySample(
              name: 'monoCaptionRegular',
              sample: TsaiMonoCaption(
                '09:41:27 UTC',
                weight: TsaiTextWeight.regular,
              ),
            ),
          ],
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(TsaiThemeTokens.of(context).spacing.space24),
        sliver: const SliverToBoxAdapter(child: _TypographyPlayground()),
      ),
    ],
  );
}

enum _TypographyRole {
  headingExtraLarge,
  headingLarge,
  headingMedium,
  headingSmall,
  bodyLargeMedium,
  bodyLarge,
  bodyMediumMedium,
  bodyMedium,
  buttonLarge,
  buttonMedium,
  captionMedium,
  captionMediumRegular,
  captionSmall,
  captionSmallRegular,
  monoHeadingExtraLarge,
  monoHeadingLarge,
  monoBodyLarge,
  monoBodyMedium,
  monoCaption,
  monoCaptionRegular,
}

enum _TypographyColor { defaultColor, secondary, negative, positive }

class _TypographyPlayground extends StatefulWidget {
  const _TypographyPlayground();

  @override
  State<_TypographyPlayground> createState() => _TypographyPlaygroundState();
}

class _TypographyPlaygroundState extends State<_TypographyPlayground> {
  String _data = 'Typography preview';
  String _semanticsLabel = '';
  _TypographyRole _role = _TypographyRole.headingExtraLarge;
  _TypographyColor _color = _TypographyColor.defaultColor;
  TextAlign _textAlign = TextAlign.start;
  TextOverflow _overflow = TextOverflow.clip;
  int _maxLines = 0;
  bool _softWrap = true;
  double _textScale = 1;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final color = switch (_color) {
      _TypographyColor.defaultColor => null,
      _TypographyColor.secondary => tokens.colors.contentSecondary,
      _TypographyColor.negative => tokens.colors.negative,
      _TypographyColor.positive => tokens.colors.positive,
    };
    return ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'data',
          value: _data,
          onChanged: (value) => setState(() => _data = value),
        ),
        PlaygroundTextControl(
          label: 'semanticsLabel',
          value: _semanticsLabel,
          onChanged: (value) => setState(() => _semanticsLabel = value),
        ),
        PlaygroundSelectControl<_TypographyRole>(
          label: 'role',
          value: _role,
          values: _TypographyRole.values,
          onChanged: (value) => setState(() => _role = value),
        ),
        PlaygroundSelectControl<_TypographyColor>(
          label: 'color',
          value: _color,
          values: _TypographyColor.values,
          onChanged: (value) => setState(() => _color = value),
        ),
        PlaygroundSelectControl<TextAlign>(
          label: 'textAlign',
          value: _textAlign,
          values: const [TextAlign.start, TextAlign.center, TextAlign.end],
          onChanged: (value) => setState(() => _textAlign = value),
        ),
        PlaygroundSelectControl<TextOverflow>(
          label: 'overflow',
          value: _overflow,
          values: TextOverflow.values,
          onChanged: (value) => setState(() => _overflow = value),
        ),
        PlaygroundField(
          label: 'maxLines: ${_maxLines == 0 ? 'null' : _maxLines}',
          child: Slider(
            value: _maxLines.toDouble(),
            min: 0,
            max: 6,
            divisions: 6,
            onChanged: (value) => setState(() => _maxLines = value.round()),
          ),
        ),
        PlaygroundField(
          label: 'textScaler: ${_textScale.toStringAsFixed(1)}',
          child: Slider(
            value: _textScale,
            min: 0.8,
            max: 2,
            divisions: 6,
            onChanged: (value) => setState(() => _textScale = value),
          ),
        ),
        PlaygroundToggleControl(
          label: 'softWrap',
          value: _softWrap,
          onChanged: (value) => setState(() => _softWrap = value),
        ),
      ],
      preview: _buildText(
        color: color,
        maxLines: _maxLines == 0 ? null : _maxLines,
      ),
    );
  }

  TsaiText _buildText({required Color? color, required int? maxLines}) {
    final common = (
      color: color,
      textAlign: _textAlign,
      overflow: _overflow,
      maxLines: maxLines,
      softWrap: _softWrap,
      textScaler: TextScaler.linear(_textScale),
      semanticsLabel: _emptyToNull(_semanticsLabel),
    );
    return switch (_role) {
      _TypographyRole.headingExtraLarge => TsaiHeading(
        _data,
        size: TsaiHeadingSize.extraLarge,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.headingLarge => TsaiHeading(
        _data,
        size: TsaiHeadingSize.large,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.headingMedium => TsaiHeading(
        _data,
        size: TsaiHeadingSize.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.headingSmall => TsaiHeading(
        _data,
        size: TsaiHeadingSize.small,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.bodyLargeMedium => TsaiBody(
        _data,
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.bodyLarge => TsaiBody(
        _data,
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.regular,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.bodyMediumMedium => TsaiBody(
        _data,
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.bodyMedium => TsaiBody(
        _data,
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.buttonLarge => TsaiButtonText(
        _data,
        size: TsaiButtonTextSize.large,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.buttonMedium => TsaiButtonText(
        _data,
        size: TsaiButtonTextSize.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.captionMedium => TsaiCaption(
        _data,
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.captionMediumRegular => TsaiCaption(
        _data,
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.regular,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.captionSmall => TsaiCaption(
        _data,
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.captionSmallRegular => TsaiCaption(
        _data,
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.regular,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.monoHeadingExtraLarge => TsaiMonoHeading(
        _data,
        size: TsaiMonoHeadingSize.extraLarge,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.monoHeadingLarge => TsaiMonoHeading(
        _data,
        size: TsaiMonoHeadingSize.large,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.monoBodyLarge => TsaiMonoBody(
        _data,
        size: TsaiBodySize.large,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.monoBodyMedium => TsaiMonoBody(
        _data,
        size: TsaiBodySize.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.monoCaption => TsaiMonoCaption(
        _data,
        weight: TsaiTextWeight.medium,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
      _TypographyRole.monoCaptionRegular => TsaiMonoCaption(
        _data,
        weight: TsaiTextWeight.regular,
        color: common.color,
        textAlign: common.textAlign,
        overflow: common.overflow,
        maxLines: common.maxLines,
        softWrap: common.softWrap,
        textScaler: common.textScaler,
        semanticsLabel: common.semanticsLabel,
      ),
    };
  }
}

String? _emptyToNull(String value) => value.isEmpty ? null : value;

class _TypographySection extends StatelessWidget {
  const _TypographySection({required this.title, required this.samples});

  final String title;
  final List<_TypographySample> samples;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.colors.borderSubtle)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: EdgeInsets.all(tokens.spacing.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TsaiHeading(title, size: TsaiHeadingSize.small),
                SizedBox(height: tokens.spacing.space16),
                ...samples,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypographySample extends StatelessWidget {
  const _TypographySample({required this.name, required this.sample});

  final String name;
  final TsaiText sample;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.colors.borderSubtle)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.spacing.space16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final label = TsaiMonoCaption(
              name,
              weight: TsaiTextWeight.regular,
              color: tokens.colors.contentSecondary,
            );
            if (constraints.maxWidth < 680) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label,
                  SizedBox(height: tokens.spacing.space16),
                  sample,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 232, child: label),
                Expanded(child: sample),
              ],
            );
          },
        ),
      ),
    );
  }
}
