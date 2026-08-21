import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

/// Catalog page for one badge-related component.
class BadgeDemoScreen extends StatelessWidget {
  const BadgeDemoScreen({
    required this.section,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ComponentDemoSection section;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: section,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: ListView(
      key: ValueKey<String>('${section.name}-demo'),
      padding: const EdgeInsets.all(24),
      children: [
        switch (section) {
          ComponentDemoSection.badge => const _BadgePlayground(),
          ComponentDemoSection.badgeCounter => const _BadgeCounterPlayground(),
          ComponentDemoSection.badgeDot => const _BadgeDotPlayground(),
          ComponentDemoSection.chip => const _ChipPlayground(),
          ComponentDemoSection.iconButton => const _IconButtonPlayground(),
          _ => throw ArgumentError.value(section, 'section'),
        },
      ],
    ),
  );
}

class _BadgePlayground extends StatefulWidget {
  const _BadgePlayground();

  @override
  State<_BadgePlayground> createState() => _BadgePlaygroundState();
}

class _BadgePlaygroundState extends State<_BadgePlayground> {
  var _label = 'Verified';
  var _tone = TsaiBadgeTone.success;
  var _showDot = true;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiBadge(label: _label, tone: _tone, showDot: _showDot),
    controls: [
      PlaygroundTextControl(
        label: 'label',
        value: _label,
        onChanged: (value) => setState(() => _label = value),
      ),
      _ToneControl(
        value: _tone,
        onChanged: (value) => setState(() => _tone = value),
      ),
      PlaygroundToggleControl(
        label: 'showDot',
        value: _showDot,
        onChanged: (value) => setState(() => _showDot = value),
      ),
    ],
  );
}

class _BadgeCounterPlayground extends StatefulWidget {
  const _BadgeCounterPlayground();

  @override
  State<_BadgeCounterPlayground> createState() =>
      _BadgeCounterPlaygroundState();
}

class _BadgeCounterPlaygroundState extends State<_BadgeCounterPlayground> {
  var _value = 3;
  var _tone = TsaiBadgeTone.accent;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiBadgeCounter(value: _value, tone: _tone),
    controls: [
      PlaygroundTextControl(
        label: 'value',
        value: '$_value',
        onChanged: (value) => setState(() => _value = int.tryParse(value) ?? 0),
      ),
      PlaygroundSelectControl<TsaiBadgeTone>(
        label: 'tone',
        value: _tone,
        values: const [TsaiBadgeTone.accent, TsaiBadgeTone.error],
        labels: const ['Accent', 'Error'],
        onChanged: (value) => setState(() => _tone = value),
      ),
    ],
  );
}

class _BadgeDotPlayground extends StatefulWidget {
  const _BadgeDotPlayground();

  @override
  State<_BadgeDotPlayground> createState() => _BadgeDotPlaygroundState();
}

class _BadgeDotPlaygroundState extends State<_BadgeDotPlayground> {
  var _tone = TsaiBadgeTone.accent;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiBadgeDot(tone: _tone),
    controls: [
      _ToneControl(
        value: _tone,
        onChanged: (value) => setState(() => _tone = value),
      ),
    ],
  );
}

class _ChipPlayground extends StatefulWidget {
  const _ChipPlayground();

  @override
  State<_ChipPlayground> createState() => _ChipPlaygroundState();
}

class _ChipPlaygroundState extends State<_ChipPlayground> {
  var _label = 'Income';
  var _selected = true;
  var _showCheck = true;
  var _removable = false;
  var _tapCount = 0;
  var _deleteCount = 0;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiChip(
      label: _label,
      selected: _selected,
      showCheck: _showCheck,
      onTap: () => setState(() {
        _selected = !_selected;
        _tapCount++;
      }),
      onDeleted: _removable ? () => setState(() => _deleteCount++) : null,
    ),
    controls: [
      PlaygroundTextControl(
        label: 'label',
        value: _label,
        onChanged: (value) => setState(() => _label = value),
      ),
      PlaygroundToggleControl(
        label: 'selected',
        value: _selected,
        onChanged: (value) => setState(() => _selected = value),
      ),
      PlaygroundToggleControl(
        label: 'showCheck',
        value: _showCheck,
        onChanged: (value) => setState(() => _showCheck = value),
      ),
      PlaygroundToggleControl(
        label: 'removable',
        value: _removable,
        onChanged: (value) => setState(() => _removable = value),
      ),
      PlaygroundOutput(label: 'Tap count', value: '$_tapCount'),
      PlaygroundOutput(label: 'Delete count', value: '$_deleteCount'),
    ],
  );
}

enum _IconButtonBadgeKind { none, dot, count }

class _IconButtonPlayground extends StatefulWidget {
  const _IconButtonPlayground();

  @override
  State<_IconButtonPlayground> createState() => _IconButtonPlaygroundState();
}

class _IconButtonPlaygroundState extends State<_IconButtonPlayground> {
  var _badgeKind = _IconButtonBadgeKind.dot;
  var _tone = TsaiBadgeTone.accent;
  var _count = 3;
  var _enabled = true;
  var _pressCount = 0;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    preview: TsaiIconButton(
      icon: const Icon(Icons.notifications_none),
      onPressed: _enabled ? () => setState(() => _pressCount++) : null,
      badge: switch (_badgeKind) {
        _IconButtonBadgeKind.none => const TsaiIconButtonBadgeNone(),
        _IconButtonBadgeKind.dot => TsaiIconButtonBadgeDot(tone: _tone),
        _IconButtonBadgeKind.count => TsaiIconButtonBadgeCount(
          _count,
          tone: _tone,
        ),
      },
    ),
    controls: [
      PlaygroundSelectControl<_IconButtonBadgeKind>(
        label: 'badge',
        value: _badgeKind,
        values: _IconButtonBadgeKind.values,
        labels: const ['None', 'Dot', 'Count'],
        onChanged: (value) => setState(() => _badgeKind = value),
      ),
      PlaygroundSelectControl<TsaiBadgeTone>(
        label: 'tone',
        value: _tone,
        values: const [TsaiBadgeTone.accent, TsaiBadgeTone.error],
        labels: const ['Accent', 'Error'],
        onChanged: (value) => setState(() => _tone = value),
      ),
      PlaygroundTextControl(
        label: 'count',
        value: '$_count',
        onChanged: (value) => setState(() => _count = int.tryParse(value) ?? 0),
      ),
      PlaygroundToggleControl(
        label: 'enabled',
        value: _enabled,
        onChanged: (value) => setState(() => _enabled = value),
      ),
      PlaygroundOutput(label: 'Press count', value: '$_pressCount'),
    ],
  );
}

class _ToneControl extends StatelessWidget {
  const _ToneControl({required this.value, required this.onChanged});

  final TsaiBadgeTone value;
  final ValueChanged<TsaiBadgeTone> onChanged;

  @override
  Widget build(BuildContext context) => PlaygroundSelectControl<TsaiBadgeTone>(
    label: 'tone',
    value: value,
    values: TsaiBadgeTone.values,
    labels: const ['Neutral', 'Accent', 'Info', 'Success', 'Error', 'Warning'],
    onChanged: onChanged,
  );
}
