import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';
import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

/// Interactive catalog page for badges, chips, and icon-button overlays.
class BadgeDemoScreen extends StatefulWidget {
  const BadgeDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  @override
  State<BadgeDemoScreen> createState() => _BadgeDemoScreenState();
}

class _BadgeDemoScreenState extends State<BadgeDemoScreen> {
  var _selected = 0;
  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.badges,
    themeMode: widget.themeMode,
    onThemeModeChanged: widget.onThemeModeChanged,
    child: ListView(
      key: const ValueKey<String>('badges-demo'),
      padding: const EdgeInsets.all(24),
      children: [
        const ComponentPlayground(
          preview: Wrap(
            spacing: 8,
            children: [
              TsaiBadge(label: 'Verified', tone: TsaiBadgeTone.success),
              TsaiBadgeCounter(value: 3),
              TsaiBadgeDot(),
            ],
          ),
          controls: [],
        ),
        const TsaiTextHeading('Badges', size: TsaiHeadingSize.large),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TsaiBadge(label: 'Neutral'),
            TsaiBadge(label: 'Info', tone: TsaiBadgeTone.info, showDot: true),
            TsaiBadge(
              label: 'Success',
              tone: TsaiBadgeTone.success,
              showDot: true,
            ),
            TsaiBadge(label: 'Warning', tone: TsaiBadgeTone.warning),
            TsaiBadge(label: 'Error', tone: TsaiBadgeTone.error),
          ],
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 8,
          children: [
            TsaiBadgeCounter(value: 3),
            TsaiBadgeCounter(value: 120),
            TsaiBadgeCounter(value: 3, tone: TsaiBadgeTone.error),
            TsaiBadgeDot(),
          ],
        ),
        const SizedBox(height: 24),
        const TsaiTextHeading('Filter chips', size: TsaiHeadingSize.small),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            for (var i = 0; i < 3; i++)
              TsaiChip(
                label: ['All', 'Income', 'Expenses'][i],
                selected: _selected == i,
                showCheck: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
          ],
        ),
        const SizedBox(height: 24),
        const TsaiTextHeading(
          'Icon button overlays',
          size: TsaiHeadingSize.small,
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            TsaiIconButton(
              icon: TsaiIcon(Icons.notifications_none),
              onPressed: null,
              badge: TsaiIconButtonBadgeDot(),
            ),
            SizedBox(width: 16),
            TsaiIconButton(
              icon: TsaiIcon(Icons.mail_outline),
              onPressed: null,
              badge: TsaiIconButtonBadgeCount(3),
            ),
          ],
        ),
      ],
    ),
  );
}
