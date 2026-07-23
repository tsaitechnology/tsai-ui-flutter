import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() => runApp(const CatalogApp());

class CatalogApp extends StatefulWidget {
  const CatalogApp({super.key});

  @override
  State<CatalogApp> createState() => _CatalogAppState();
}

class _CatalogAppState extends State<CatalogApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Tsai UI',
    debugShowCheckedModeBanner: false,
    theme: TsaiTheme.light(),
    darkTheme: TsaiTheme.dark(),
    themeMode: _themeMode,
    home: ButtonCatalog(
      themeMode: _themeMode,
      onThemeModeChanged: (value) => setState(() => _themeMode = value),
    ),
  );
}

class ButtonCatalog extends StatefulWidget {
  const ButtonCatalog({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ButtonCatalog> createState() => _ButtonCatalogState();
}

class _ButtonCatalogState extends State<ButtonCatalog> {
  TsaiButtonSize _size = TsaiButtonSize.large;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final dark = widget.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
        centerTitle: false,
        backgroundColor: tokens.colors.canvas,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: dark ? 'Use light theme' : 'Use dark theme',
            onPressed: () => widget.onThemeModeChanged(
              dark ? ThemeMode.light : ThemeMode.dark,
            ),
            icon: TsaiIcon(dark ? LucideIcons.sun : LucideIcons.moon),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _CatalogToolbar(
              size: _size,
              onSizeChanged: (value) => setState(() => _size = value),
            ),
          ),
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
        ],
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Action activated')));
  }
}

class _CatalogToolbar extends StatelessWidget {
  const _CatalogToolbar({required this.size, required this.onSizeChanged});

  final TsaiButtonSize size;
  final ValueChanged<TsaiButtonSize> onSizeChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: tokens.colors.borderSubtle),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.space24,
          vertical: tokens.spacing.space16,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedButton<TsaiButtonSize>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: TsaiButtonSize.large, label: Text('Large')),
              ButtonSegment(
                value: TsaiButtonSize.medium,
                label: Text('Medium'),
              ),
            ],
            selected: {size},
            onSelectionChanged: (values) => onSizeChanged(values.single),
          ),
        ),
      ),
    );
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
          Text(title, style: tokens.typography.headingSmall),
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
          Text(
            variant.name,
            style: tokens.typography.captionMedium.copyWith(
              color: tokens.colors.contentSecondary,
            ),
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
