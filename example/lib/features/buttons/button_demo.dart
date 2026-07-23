import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({super.key, this.controller, this.physics});

  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  State<ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<ButtonDemo> {
  TsaiButtonSize _size = TsaiButtonSize.large;
  TsaiButtonVariant _variant = TsaiButtonVariant.primary;
  String _label = 'Button';
  String _semanticLabel = '';
  String _loadingSemanticLabel = 'Loading';
  bool _enabled = true;
  bool _showIcon = true;
  bool _isLoading = false;
  bool _isExpanded = false;
  bool _autofocus = false;
  int _pressCount = 0;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    key: const ValueKey<String>('button-demo'),
    controller: widget.controller,
    physics: widget.physics,
    slivers: [
      SliverList.list(
        children: [
          _StateSection(
            title: 'Default',
            size: _size,
            onPressed: () => _showConfirmation(context),
          ),
          _StateSection(
            title: 'Loading',
            size: _size,
            isLoading: true,
            onPressed: () {},
          ),
          _StateSection(
            title: 'Without icon',
            size: _size,
            showIcon: false,
            onPressed: () => _showConfirmation(context),
          ),
          _StateSection(title: 'Disabled', size: _size, onPressed: null),
        ],
      ),
      SliverPadding(
        padding: EdgeInsets.all(TsaiThemeTokens.of(context).spacing.space24),
        sliver: SliverToBoxAdapter(
          child: ComponentPlayground(
            controls: [
              PlaygroundTextControl(
                label: 'label',
                value: _label,
                onChanged: (value) => setState(() => _label = value),
              ),
              PlaygroundTextControl(
                label: 'semanticLabel',
                value: _semanticLabel,
                onChanged: (value) => setState(() => _semanticLabel = value),
              ),
              PlaygroundTextControl(
                label: 'loadingSemanticLabel',
                value: _loadingSemanticLabel,
                onChanged: (value) =>
                    setState(() => _loadingSemanticLabel = value),
              ),
              PlaygroundSelectControl<TsaiButtonVariant>(
                label: 'variant',
                value: _variant,
                values: TsaiButtonVariant.values,
                onChanged: (value) => setState(() => _variant = value),
              ),
              PlaygroundSelectControl<TsaiButtonSize>(
                label: 'size',
                value: _size,
                values: TsaiButtonSize.values,
                onChanged: (value) => setState(() => _size = value),
              ),
              PlaygroundToggleControl(
                label: 'enabled',
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              PlaygroundToggleControl(
                label: 'leadingIcon',
                value: _showIcon,
                onChanged: (value) => setState(() => _showIcon = value),
              ),
              PlaygroundToggleControl(
                label: 'isLoading',
                value: _isLoading,
                onChanged: (value) => setState(() => _isLoading = value),
              ),
              PlaygroundToggleControl(
                label: 'isExpanded',
                value: _isExpanded,
                onChanged: (value) => setState(() => _isExpanded = value),
              ),
              PlaygroundToggleControl(
                label: 'autofocus',
                value: _autofocus,
                onChanged: (value) => setState(() => _autofocus = value),
              ),
              PlaygroundOutput(
                label: 'onPressed',
                value: 'Called $_pressCount times',
              ),
            ],
            preview: TsaiButton(
              label: _label,
              variant: _variant,
              size: _size,
              leadingIcon: _showIcon
                  ? const TsaiIcon(LucideIcons.plus, size: 16)
                  : null,
              isLoading: _isLoading,
              isExpanded: _isExpanded,
              autofocus: _autofocus,
              semanticLabel: _emptyToNull(_semanticLabel),
              loadingSemanticLabel: _emptyToNull(_loadingSemanticLabel),
              onPressed: _enabled ? () => setState(() => _pressCount++) : null,
            ),
          ),
        ),
      ),
    ],
  );

  void _showConfirmation(BuildContext context) {
    ScaffoldMessenger.maybeOf(context)
      ?..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Action activated')));
  }
}

class _StateSection extends StatelessWidget {
  const _StateSection({
    required this.title,
    required this.size,
    required this.onPressed,
    this.isLoading = false,
    this.showIcon = true,
  });

  final String title;
  final TsaiButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.all(tokens.spacing.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TsaiHeading(title, size: TsaiHeadingSize.small),
          SizedBox(height: tokens.spacing.space16),
          Wrap(
            spacing: tokens.spacing.space24,
            runSpacing: tokens.spacing.space24,
            children: TsaiButtonVariant.values
                .map(
                  (variant) => _VariantSample(
                    variant: variant,
                    size: size,
                    isLoading: isLoading,
                    showIcon: showIcon,
                    onPressed: onPressed,
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _VariantSample extends StatelessWidget {
  const _VariantSample({
    required this.variant,
    required this.size,
    required this.isLoading,
    required this.showIcon,
    required this.onPressed,
  });

  final TsaiButtonVariant variant;
  final TsaiButtonSize size;
  final bool isLoading;
  final bool showIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TsaiCaption(
            variant.name,
            size: TsaiCaptionSize.medium,
            weight: TsaiTextWeight.medium,
            color: tokens.colors.contentSecondary,
          ),
          SizedBox(height: tokens.spacing.space8),
          TsaiButton(
            label: 'Button',
            variant: variant,
            size: size,
            isLoading: isLoading,
            loadingSemanticLabel: 'Loading',
            onPressed: onPressed,
            leadingIcon: showIcon
                ? const TsaiIcon(LucideIcons.plus, size: 16)
                : null,
          ),
        ],
      ),
    );
  }
}

String? _emptyToNull(String value) => value.isEmpty ? null : value;
