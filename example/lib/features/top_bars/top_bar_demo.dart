import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

class TopBarDemo extends StatelessWidget {
  const TopBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SingleChildScrollView(
      key: const ValueKey<String>('top-bar-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TsaiTextHeading('HomeTopBar', size: TsaiHeadingSize.small),
              SizedBox(height: tokens.spacing.space12),
              Center(
                child: SizedBox(
                  width: 390,
                  child: HomeTopBar(
                    leading: [
                      UserPill(
                        name: 'Ilona T.',
                        initials: 'IT',
                        semanticLabel: 'Open profile',
                        onPressed: () {},
                      ),
                    ],
                    trailing: [
                      HomeTopBarAction(
                        icon: const TsaiIcon(LucideIcons.scan_line),
                        semanticLabel: 'Scan',
                        onPressed: () {},
                      ),
                      HomeTopBarAction(
                        icon: const TsaiIcon(LucideIcons.bell),
                        semanticLabel: 'Notifications',
                        showIndicator: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.space32),
              const TsaiTextHeading('PageTopBar', size: TsaiHeadingSize.small),
              SizedBox(height: tokens.spacing.space12),
              Center(
                child: SizedBox(
                  width: 390,
                  child: PageTopBar(
                    leading: [
                      PageTopBarAction(
                        icon: const TsaiIcon(LucideIcons.arrow_left),
                        semanticLabel: 'Back',
                        onPressed: () {},
                      ),
                    ],
                    title: const Text('Card details'),
                    trailing: [
                      PageTopBarAction(
                        icon: const TsaiIcon(LucideIcons.plus),
                        semanticLabel: 'Add',
                        onPressed: () {},
                      ),
                      PageTopBarAction(
                        icon: const TsaiIcon(LucideIcons.ellipsis),
                        semanticLabel: 'More',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.space32),
              const TsaiTextHeading(
                'PageWithTopBar',
                size: TsaiHeadingSize.small,
              ),
              SizedBox(height: tokens.spacing.space12),
              Center(
                child: Container(
                  width: 390,
                  height: 420,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tokens.colors.borderSubtle,
                      width: tokens.borders.hairline,
                    ),
                    borderRadius: BorderRadius.circular(tokens.radii.small),
                  ),
                  child: PageWithTopBar(
                    heading: 'Portfolio',
                    leading: [
                      PageTopBarAction(
                        icon: const TsaiIcon(LucideIcons.arrow_left),
                        semanticLabel: 'Back',
                        onPressed: () {},
                      ),
                    ],
                    trailing: [
                      PageTopBarAction(
                        icon: const TsaiIcon(LucideIcons.plus),
                        semanticLabel: 'Add',
                        onPressed: () {},
                      ),
                      PageTopBarAction(
                        icon: const TsaiIcon(LucideIcons.ellipsis),
                        semanticLabel: 'More',
                        onPressed: () {},
                      ),
                    ],
                    body: const _PortfolioBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioBody extends StatelessWidget {
  const _PortfolioBody();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.space16,
        tokens.spacing.space24,
        tokens.spacing.space16,
        tokens.spacing.space32,
      ),
      child: Column(
        children: [
          for (final item in const [
            ('AAPL', 'Apple', r'$214.40'),
            ('MSFT', 'Microsoft', r'$441.92'),
            ('NVDA', 'NVIDIA', r'$173.74'),
            ('TSLA', 'Tesla', r'$316.06'),
            ('AMZN', 'Amazon', r'$232.22'),
            ('META', 'Meta', r'$712.50'),
            ('GOOG', 'Alphabet', r'$192.96'),
          ])
            _PortfolioRow(symbol: item.$1, name: item.$2, value: item.$3),
        ],
      ),
    );
  }
}

class _PortfolioRow extends StatelessWidget {
  const _PortfolioRow({
    required this.symbol,
    required this.name,
    required this.value,
  });

  final String symbol;
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Container(
      height: tokens.spacing.space64,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: tokens.colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: tokens.spacing.space64,
            child: TsaiTextMonoBody(symbol, size: TsaiBodySize.medium),
          ),
          Expanded(
            child: TsaiTextBody(
              name,
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.regular,
              color: tokens.colors.contentSecondary,
            ),
          ),
          TsaiTextBody(
            value,
            size: TsaiBodySize.medium,
            weight: TsaiTextWeight.medium,
          ),
        ],
      ),
    );
  }
}
