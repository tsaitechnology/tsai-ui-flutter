import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

class _ContrastPatternPainter extends CustomPainter {
  const _ContrastPatternPainter({
    required this.baseColor,
    required this.accentColor,
  });

  final Color baseColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    const tileExtent = 32.0;
    final paint = Paint();
    for (var y = 0.0, row = 0; y < size.height; y += tileExtent, row++) {
      for (var x = 0.0, column = 0; x < size.width; x += tileExtent, column++) {
        paint.color = (row + column).isEven ? baseColor : accentColor;
        canvas.drawRect(Rect.fromLTWH(x, y, tileExtent, tileExtent), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ContrastPatternPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor ||
      accentColor != oldDelegate.accentColor;
}

class ComponentPlayground extends StatefulWidget {
  const ComponentPlayground({
    required this.preview,
    required this.controls,
    super.key,
  });

  final Widget preview;
  final List<Widget> controls;

  @override
  State<ComponentPlayground> createState() => _ComponentPlaygroundState();
}

class _ComponentPlaygroundState extends State<ComponentPlayground> {
  bool _checkerboardBackground = false;
  bool? _controlsVisible;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        final showControls = _controlsVisible ?? !isCompact;
        return Container(
          key: widget.key ?? const ValueKey<String>('component-playground'),
          width: double.infinity,
          decoration: BoxDecoration(
            color: tokens.colors.canvas,
            border: Border.all(
              color: tokens.colors.borderSubtle,
              width: tokens.borders.hairline,
            ),
            borderRadius: BorderRadius.circular(tokens.radii.large),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radii.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(showControls),
                if (isCompact)
                  Column(
                    children: [
                      _buildPreview(tokens),
                      if (showControls) _buildControls(tokens, isCompact: true),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildPreview(tokens)),
                      if (showControls)
                        SizedBox(
                          width: 336,
                          child: _buildControls(tokens, isCompact: false),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool showControls) {
    return PageTopBar(
      title: 'Playground',
      trailing: [
        PageTopBarAction(
          key: const ValueKey<String>(
            'component-playground-checkerboard-toggle',
          ),
          icon: TsaiIcon(
            _checkerboardBackground
                ? LucideIcons.grid_2x2_check
                : LucideIcons.grid_2x2,
          ),
          semanticLabel: _checkerboardBackground
              ? 'Hide contrast background'
              : 'Show contrast background',
          onPressed: () => setState(
            () => _checkerboardBackground = !_checkerboardBackground,
          ),
        ),
        PageTopBarAction(
          key: const ValueKey<String>('component-playground-controls-toggle'),
          icon: const TsaiIcon(LucideIcons.sliders_horizontal),
          semanticLabel: showControls ? 'Hide controls' : 'Show controls',
          onPressed: () => setState(() => _controlsVisible = !showControls),
        ),
      ],
    );
  }

  Widget _buildControls(TsaiThemeTokens tokens, {required bool isCompact}) {
    final groups = <String, List<Widget>>{};
    for (final control in widget.controls) {
      groups.putIfAbsent(_controlGroup(control), () => []).add(control);
    }
    return DecoratedBox(
      key: const ValueKey<String>('component-playground-controls'),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceRaised,
        border: isCompact
            ? Border(
                top: BorderSide(
                  color: tokens.colors.borderSubtle,
                  width: tokens.borders.hairline,
                ),
              )
            : Border(
                left: BorderSide(
                  color: tokens.colors.borderSubtle,
                  width: tokens.borders.hairline,
                ),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: SingleChildScrollView(
          child: Column(
            key: const ValueKey<String>('component-playground-controls-wrap'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TsaiTextHeading('Customize', size: TsaiHeadingSize.small),
              SizedBox(height: tokens.spacing.space16),
              for (final entry in groups.entries) ...[
                TsaiTextCaption(
                  entry.key,
                  size: TsaiCaptionSize.small,
                  weight: TsaiTextWeight.medium,
                  color: tokens.colors.contentTertiary,
                ),
                SizedBox(height: tokens.spacing.space8),
                for (final control in entry.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: control,
                  ),
                if (entry.key != groups.keys.last)
                  Padding(
                    padding: EdgeInsets.only(bottom: tokens.spacing.space16),
                    child: Divider(
                      height: tokens.borders.hairline,
                      color: tokens.colors.borderSubtle,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _controlGroup(Widget control) {
    final type = control.runtimeType.toString().toLowerCase();
    if (control is PlaygroundTextControl || type.contains('textproperty')) {
      return 'CONTENT';
    }
    if (control is PlaygroundToggleControl || type.contains('toggle')) {
      return 'BEHAVIOR';
    }
    if (control is PlaygroundOutput || type.contains('event')) {
      return 'EVENTS';
    }
    return 'OPTIONS';
  }

  Widget _buildPreview(TsaiThemeTokens tokens) => DecoratedBox(
    decoration: BoxDecoration(color: tokens.colors.canvas),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TsaiTextCaption(
            'Preview',
            size: TsaiCaptionSize.small,
            weight: TsaiTextWeight.medium,
            color: tokens.colors.contentSecondary,
          ),
          SizedBox(height: tokens.spacing.space8),
          DecoratedBox(
            key: const ValueKey<String>('component-playground-preview'),
            decoration: BoxDecoration(
              color: tokens.colors.surface,
              border: Border.all(
                color: tokens.colors.borderSubtle,
                width: tokens.borders.hairline,
              ),
              borderRadius: BorderRadius.circular(tokens.radii.medium),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(tokens.radii.medium),
              child: CustomPaint(
                key: const ValueKey<String>(
                  'component-playground-checkerboard',
                ),
                painter: _checkerboardBackground
                    ? _ContrastPatternPainter(
                        baseColor: tokens.colors.canvas,
                        accentColor: tokens.colors.contentPrimary,
                      )
                    : null,
                child: SizedBox(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 180),
                    child: LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        width: constraints.maxWidth.clamp(0, 480),
                        child: Align(
                          alignment: AlignmentDirectional.center,
                          child: widget.preview,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class PlaygroundField extends StatelessWidget {
  const PlaygroundField({
    required this.label,
    required this.child,
    super.key,
    this.width = 200,
  });

  final String label;
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            humanize(label),
            style: tokens.typography.captionMediumRegular.copyWith(
              color: tokens.colors.contentSecondary,
            ),
          ),
          SizedBox(height: tokens.spacing.space2),
          child,
        ],
      ),
    );
  }

  static String humanize(String value) {
    final words = value
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
    return words;
  }
}

class PlaygroundTextControl extends StatelessWidget {
  const PlaygroundTextControl({
    required this.label,
    required this.onChanged,
    super.key,
    this.value,
    this.controller,
  }) : assert(value == null || controller == null);

  final String label;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TsaiInput(
    placeholder: PlaygroundField.humanize(label),
    controller: controller,
    initialValue: controller == null ? value : null,
    showClearButton: false,
    onChanged: onChanged,
  );
}

class PlaygroundSelectControl<T> extends StatelessWidget {
  const PlaygroundSelectControl({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
    super.key,
    this.labels,
  }) : assert(labels == null || labels.length == values.length);

  final String label;
  final T value;
  final List<T> values;
  final List<String>? labels;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => TsaiSelect<T>(
    placeholder: PlaygroundField.humanize(label),
    value: value,
    options: [
      for (var index = 0; index < values.length; index++)
        TsaiSelectOption<T>(
          value: values[index],
          label: labels?[index] ?? _defaultLabel(values[index]),
        ),
    ],
    showClearButton: false,
    presentation: TsaiSelectPresentation.menu,
    onChanged: (value) {
      if (value != null) {
        onChanged(value);
      }
    },
  );

  static String _defaultLabel(Object? value) =>
      value is Enum ? value.name : '$value';
}

class PlaygroundToggleControl extends StatelessWidget {
  const PlaygroundToggleControl({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.width = 150,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) => PlaygroundField(
    label: label,
    width: width,
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: TsaiSwitch(value: value, onChanged: onChanged),
    ),
  );
}

class PlaygroundRadioGroup<T> extends StatelessWidget {
  const PlaygroundRadioGroup({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
    this.width = 200,
  });

  final String label;
  final T value;
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return PlaygroundField(
      label: label,
      width: width,
      child: Wrap(
        key: const ValueKey<String>('playground-radio-options'),
        spacing: tokens.spacing.space8,
        runSpacing: 0,
        children: [
          for (final option in options)
            TsaiRadio<T>(
              value: option.$1,
              groupValue: value,
              label: option.$2,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
        ],
      ),
    );
  }
}

class PlaygroundOutput extends StatelessWidget {
  const PlaygroundOutput({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => PlaygroundField(
    label: label,
    child: TsaiInput(
      key: ValueKey<String>(value),
      initialValue: value,
      readOnly: true,
      showClearButton: false,
    ),
  );
}
