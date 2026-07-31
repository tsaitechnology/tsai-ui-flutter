import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

class BottomNavBarDemo extends StatefulWidget {
  const BottomNavBarDemo({super.key});

  @override
  State<BottomNavBarDemo> createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  final _selectedIndices = [0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: const ValueKey<String>('bottom-nav-bar-demo'),
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.space24,
        tokens.spacing.space32,
        tokens.spacing.space24,
        tokens.spacing.space64,
      ),
      children: [
        for (var count = 1; count <= 4; count++) ...[
          TsaiTextHeading(
            '$count ${count == 1 ? 'destination' : 'destinations'}',
            size: TsaiHeadingSize.small,
          ),
          SizedBox(height: tokens.spacing.space16),
          _BackdropExample(
            count: count,
            selectedIndex: _selectedIndices[count - 1],
            onSelected: (index) =>
                setState(() => _selectedIndices[count - 1] = index),
          ),
          if (count < 4) SizedBox(height: tokens.spacing.space32),
        ],
      ],
    );
  }
}

class _BackdropExample extends StatelessWidget {
  const _BackdropExample({
    required this.count,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int count;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      height: 210,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radii.medium),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: ColoredBox(color: tokens.colors.actionPrimary),
                  ),
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: ColoredBox(color: tokens.colors.positive),
                  ),
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: ColoredBox(color: tokens.colors.negative),
                  ),
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: ColoredBox(
                      color: tokens.colors.surfaceAccentPressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: TsaiTextHeading(
              'Content under the bar',
              size: TsaiHeadingSize.medium,
              color: tokens.colors.contentOnActionPrimary,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              items: _items.take(count).toList(growable: false),
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),
          ),
        ],
      ),
    );
  }
}

const _items = [
  BottomNavBarItem(icon: TsaiIcon(LucideIcons.house, size: 20), label: 'Home'),
  BottomNavBarItem(
    icon: TsaiIcon(LucideIcons.chart_no_axes_column, size: 20),
    label: 'Stats',
  ),
  BottomNavBarItem(
    icon: TsaiIcon(LucideIcons.credit_card, size: 20),
    label: 'Cards',
  ),
  BottomNavBarItem(
    icon: TsaiIcon(LucideIcons.user, size: 20),
    label: 'Profile',
  ),
];
