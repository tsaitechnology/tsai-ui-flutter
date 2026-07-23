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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TsaiHeading('Playground', size: TsaiHeadingSize.small),
        SizedBox(height: tokens.spacing.space16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < controls.length; index++) ...[
              controls[index],
              if (index < controls.length - 1)
                SizedBox(height: tokens.spacing.space16),
            ],
          ],
        ),
        SizedBox(height: tokens.spacing.space24),
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
          constraints: const BoxConstraints(minHeight: 144),
          padding: EdgeInsets.all(tokens.spacing.space24),
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            color: tokens.colors.surfaceRaised,
            border: Border.symmetric(
              horizontal: BorderSide(color: tokens.colors.borderSubtle),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              width: constraints.maxWidth.clamp(0, 360),
              child: preview,
            ),
          ),
        ),
        SizedBox(height: tokens.spacing.space32),
      ],
    );
  }
}

class PlaygroundField extends StatelessWidget {
  const PlaygroundField({
    required this.label,
    required this.child,
    super.key,
    this.width = 220,
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
          SizedBox(height: tokens.spacing.space4),
          child,
        ],
      ),
    );
  }
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
