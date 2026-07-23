import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

class ComponentPlayground extends StatelessWidget {
  const ComponentPlayground({
    required this.preview,
    required this.controls,
    super.key,
  });

  final Widget preview;
  final List<Widget> controls;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Container(
      key: const ValueKey<String>('component-playground'),
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        border: Border.all(
          color: tokens.colors.borderSubtle,
          width: tokens.borders.hairline,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TsaiHeading('Playground', size: TsaiHeadingSize.small),
          ),
          Container(
            key: const ValueKey<String>('component-playground-controls'),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Wrap(
              key: const ValueKey<String>('component-playground-controls-wrap'),
              spacing: 12,
              runSpacing: 12,
              children: controls,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: tokens.colors.surfaceRaised,
              border: Border(
                top: BorderSide(
                  color: tokens.colors.borderSubtle,
                  width: tokens.borders.hairline,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview',
                  style: tokens.typography.captionMediumRegular.copyWith(
                    color: tokens.colors.contentSecondary,
                  ),
                ),
                SizedBox(height: tokens.spacing.space8),
                Container(
                  key: const ValueKey<String>('component-playground-preview'),
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 96),
                  alignment: AlignmentDirectional.centerStart,
                  child: LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      width: constraints.maxWidth.clamp(0, 360),
                      child: preview,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
            label,
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
  Widget build(BuildContext context) => PlaygroundField(
    label: label,
    child: TsaiInput(
      controller: controller,
      initialValue: controller == null ? value : null,
      showClearButton: false,
      onChanged: onChanged,
    ),
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
  Widget build(BuildContext context) => PlaygroundField(
    label: label,
    child: TsaiSelect<T>(
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
    ),
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

class PenpotBoard extends StatelessWidget {
  const PenpotBoard({
    required this.child,
    super.key,
    this.width,
    this.padding = const EdgeInsets.all(28),
  });

  final Widget child;
  final double? width;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: tokens.colors.actionPrimarySoft, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}

class PenpotExample extends StatelessWidget {
  const PenpotExample({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing.space32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TsaiHeading(title, size: TsaiHeadingSize.small),
          SizedBox(height: tokens.spacing.space16),
          child,
        ],
      ),
    );
  }
}
