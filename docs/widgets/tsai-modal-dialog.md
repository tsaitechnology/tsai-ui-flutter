# TsaiModalDialog

A compact 320-pixel modal surface with an icon, title, explanatory message,
and row or stacked action layouts.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/modal-dialog){ target="_blank" rel="noopener" .md-button }

```dart
await showTsaiModalDialog<void>(
  context: context,
  title: 'Delete card?',
  message: 'This action cannot be undone.',
  icon: const TsaiIcon(LucideIcons.trash2),
  primaryAction: Builder(
    builder: (context) => TsaiButton(
      label: 'Delete',
      size: TsaiButtonSize.medium,
      onPressed: () => Navigator.pop(context),
    ),
  ),
);
```

Use the stacked action layout for narrow or long labels. The modal helper uses
the theme overlay token, traps keyboard traversal inside the route, supports
Escape/back dismissal, and returns values passed to `Navigator.pop`.
The content uses 24-pixel outer padding, 16 pixels between icon and title, and
32 pixels between the message and action block.
