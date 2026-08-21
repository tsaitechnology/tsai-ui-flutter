import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class TypographyDemo extends StatelessWidget {
  const TypographyDemo({super.key, this.controller, this.physics});

  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('typography-demo'),
    controller: controller,
    physics: physics,
    padding: EdgeInsets.all(TsaiThemeTokens.of(context).spacing.space24),
    children: const [_TypographyPlayground()],
  );
}

enum _TypographyRole {
  heading,
  body,
  button,
  caption,
  monoHeading,
  monoBody,
  monoCaption,
}

enum _TypographyColor { defaultColor, secondary, error, success }

class _TypographyPlayground extends StatefulWidget {
  const _TypographyPlayground();

  @override
  State<_TypographyPlayground> createState() => _TypographyPlaygroundState();
}

class _TypographyPlaygroundState extends State<_TypographyPlayground> {
  String _text = 'Typography preview';
  _TypographyRole _role = _TypographyRole.heading;
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
      _TypographyColor.error => tokens.colors.accentError,
      _TypographyColor.success => tokens.colors.accentSuccess,
    };
    return ComponentPlayground(
      controls: [
        PlaygroundTextControl(
          label: 'Text',
          value: _text,
          onChanged: (value) => setState(() => _text = value),
        ),
        PlaygroundSelectControl<_TypographyRole>(
          label: 'Text style',
          value: _role,
          values: _TypographyRole.values,
          labels: const [
            'Heading',
            'Body',
            'Button',
            'Caption',
            'Mono heading',
            'Mono body',
            'Mono caption',
          ],
          onChanged: (value) => setState(() => _role = value),
        ),
        PlaygroundSelectControl<_TypographyColor>(
          label: 'Color',
          value: _color,
          values: _TypographyColor.values,
          labels: const ['Default', 'Secondary', 'Error', 'Success'],
          onChanged: (value) => setState(() => _color = value),
        ),
        PlaygroundSelectControl<TextAlign>(
          label: 'Text alignment',
          value: _textAlign,
          values: const [TextAlign.start, TextAlign.center, TextAlign.end],
          labels: const ['Start', 'Center', 'End'],
          onChanged: (value) => setState(() => _textAlign = value),
        ),
        PlaygroundSelectControl<TextOverflow>(
          label: 'Overflow behavior',
          value: _overflow,
          values: TextOverflow.values,
          labels: const ['Clip', 'Fade', 'Ellipsis', 'Visible'],
          onChanged: (value) => setState(() => _overflow = value),
        ),
        PlaygroundField(
          label: 'Maximum lines: ${_maxLines == 0 ? 'Unlimited' : _maxLines}',
          child: Slider(
            value: _maxLines.toDouble(),
            min: 0,
            max: 6,
            divisions: 6,
            onChanged: (value) => setState(() => _maxLines = value.round()),
          ),
        ),
        PlaygroundField(
          label: 'Text scale: ${_textScale.toStringAsFixed(1)}×',
          child: Slider(
            value: _textScale,
            min: 0.8,
            max: 2,
            divisions: 6,
            onChanged: (value) => setState(() => _textScale = value),
          ),
        ),
        PlaygroundToggleControl(
          label: 'Wrap text',
          value: _softWrap,
          onChanged: (value) => setState(() => _softWrap = value),
        ),
      ],
      preview: _buildText(color: color),
    );
  }

  TsaiText _buildText({required Color? color}) {
    final maxLines = _maxLines == 0 ? null : _maxLines;
    final scaler = TextScaler.linear(_textScale);
    return switch (_role) {
      _TypographyRole.heading => TsaiTextHeading(
        _text,
        size: TsaiHeadingSize.extraLarge,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
      _TypographyRole.body => TsaiTextBody(
        _text,
        size: TsaiBodySize.large,
        weight: TsaiTextWeight.regular,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
      _TypographyRole.button => TsaiTextButton(
        _text,
        size: TsaiButtonTextSize.large,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
      _TypographyRole.caption => TsaiTextCaption(
        _text,
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.regular,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
      _TypographyRole.monoHeading => TsaiTextMonoHeading(
        _text,
        size: TsaiMonoHeadingSize.extraLarge,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
      _TypographyRole.monoBody => TsaiTextMonoBody(
        _text,
        size: TsaiBodySize.large,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
      _TypographyRole.monoCaption => TsaiTextMonoCaption(
        _text,
        weight: TsaiTextWeight.regular,
        color: color,
        textAlign: _textAlign,
        overflow: _overflow,
        maxLines: maxLines,
        softWrap: _softWrap,
        textScaler: scaler,
      ),
    };
  }
}
