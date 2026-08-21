import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class BottomNavBarDemo extends StatefulWidget {
  const BottomNavBarDemo({super.key});

  @override
  State<BottomNavBarDemo> createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  var _destinationCount = 3;
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: const ValueKey<String>('bottom-nav-bar-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        ComponentPlayground(
          controls: [
            PlaygroundSelectControl<int>(
              label: 'Number of destinations',
              value: _destinationCount,
              values: const [1, 2, 3, 4, 5],
              onChanged: (value) => setState(() {
                _destinationCount = value;
                _selectedIndex = _selectedIndex.clamp(0, value - 1);
              }),
            ),
            PlaygroundOutput(
              label: 'Selected destination',
              value: _items[_selectedIndex].label,
            ),
          ],
          preview: BottomNavBar(
            items: _items.take(_destinationCount).toList(growable: false),
            selectedIndex: _selectedIndex,
            onSelected: (index) => setState(() => _selectedIndex = index),
          ),
        ),
      ],
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
  BottomNavBarItem(
    icon: TsaiIcon(LucideIcons.settings, size: 20),
    label: 'Settings',
  ),
];
