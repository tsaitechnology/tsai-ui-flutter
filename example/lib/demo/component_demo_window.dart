import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

enum ComponentDemoSection {
  typography(label: 'Typography', route: '/typography'),
  buttons(label: 'Buttons', route: '/buttons'),
  icons(label: 'Icons', route: '/icons'),
  checkbox(label: 'Checkbox', route: '/checkbox'),
  radio(label: 'Radio', route: '/radio'),
  switchControl(label: 'Switch', route: '/switch'),
  select(label: 'Select', route: '/select'),
  input(label: 'Input', route: '/input'),
  inputPhone(label: 'Input Phone', route: '/input-phone'),
  inputOtp(label: 'OTP', route: '/input-otp'),
  inputPin(label: 'PIN', route: '/input-pin');

  const ComponentDemoSection({required this.label, required this.route});

  final String label;
  final String route;
}

class ComponentDemoWindow extends StatefulWidget {
  const ComponentDemoWindow({
    required this.title,
    required this.section,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.child,
    super.key,
  });

  final String title;
  final ComponentDemoSection section;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Widget child;

  @override
  State<ComponentDemoWindow> createState() => _ComponentDemoWindowState();
}

class _ComponentDemoWindowState extends State<ComponentDemoWindow> {
  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final dark = widget.themeMode == ThemeMode.dark;
    return DefaultTabController(
      key: ValueKey<ComponentDemoSection>(widget.section),
      initialIndex: widget.section.index,
      length: ComponentDemoSection.values.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TsaiHeading(widget.title, size: TsaiHeadingSize.small),
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
          bottom: _buildNavigation(context, tokens),
        ),
        body: widget.child,
      ),
    );
  }

  void _openSection(BuildContext context, ComponentDemoSection target) {
    if (target == widget.section) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(target.route);
  }

  PreferredSizeWidget _buildNavigation(
    BuildContext context,
    TsaiThemeTokens tokens,
  ) {
    if (MediaQuery.sizeOf(context).width >= 700) {
      return TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        dividerColor: tokens.colors.borderSubtle,
        onTap: (index) =>
            _openSection(context, ComponentDemoSection.values[index]),
        tabs: [
          for (final item in ComponentDemoSection.values) Tab(text: item.label),
        ],
      );
    }
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: tokens.colors.borderSubtle)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ComponentDemoSection>(
            value: widget.section,
            isExpanded: true,
            dropdownColor: tokens.colors.surfaceRaised,
            style: tokens.typography.bodyLarge.copyWith(
              color: tokens.colors.contentPrimary,
            ),
            items: [
              for (final item in ComponentDemoSection.values)
                DropdownMenuItem(value: item, child: Text(item.label)),
            ],
            onChanged: (target) {
              if (target != null) {
                _openSection(context, target);
              }
            },
          ),
        ),
      ),
    );
  }
}
